from pyspark.sql import SparkSession, functions as F, types as T
import json, shutil
from pathlib import Path

# Input and output paths
INPUT = "/home/sat3812/Downloads/mi_complications.csv."
OUT_SINGLE_CSV = "/home/sat3812/Downloads/mi_clean_light.csv"
REPORT_PATH = "/home/sat3812/Downloads/mi_clean_light_report.json"

# Spark session (lightweight config for low-RAM VM)
spark = (
    SparkSession.builder
    .appName("mi_preprocess_light")
    .config("spark.sql.shuffle.partitions", "8")
    .config("spark.default.parallelism", "8")
    .getOrCreate()
)
spark.sparkContext.setLogLevel("WARN")

# Loading dataset
df = (
    spark.read
    .option("header", True)
    .option("inferSchema", True)
    .csv(INPUT)
)

df.printSchema()
print(f"Total rows (raw): {df.count()}")

# Replace placeholders for missing data
placeholders = ["", " ", "?", "NA", "NaN", "nan", "N/A", "None", "null", "NULL"]
df = df.replace(placeholders, None)

# Trim string columns
string_cols = [f.name for f in df.schema.fields if isinstance(f.dataType, T.StringType)]
if string_cols:
    df = df.select([F.trim(F.col(c)).alias(c) if c in string_cols else F.col(c) for c in df.columns])

# Calculate missing ratios
row_count = df.count()
null_counts_row = df.select([F.count(F.when(F.col(c).isNull(), c)).alias(c) for c in df.columns]).first()
null_counts = null_counts_row.asDict() if null_counts_row is not None else {}
missing_ratio = {c: (null_counts.get(c, 0) / row_count if row_count else 0.0) for c in df.columns}

# Drop columns with >90% missing
to_drop = [c for c, r in missing_ratio.items() if r > 0.90]
if to_drop:
    df = df.drop(*to_drop)

# Impute (<40% missing): numeric = mean, string = "Unknown"
num_cols = [c for c, t in df.dtypes if t in ('double', 'float', 'int', 'bigint')]
str_cols = [c for c, t in df.dtypes if t == 'string']
to_impute = [c for c, r in missing_ratio.items() if r < 0.40]
impute_num = [c for c in to_impute if c in num_cols]
impute_str = [c for c in to_impute if c in str_cols]

if impute_num:
    means_row = df.select([F.avg(F.col(c)).alias(c) for c in impute_num]).first()
    means = means_row.asDict() if means_row is not None else {}
    df = df.na.fill({c: means[c] for c in impute_num if means.get(c) is not None})

if impute_str:
    df = df.na.fill({c: "Unknown" for c in impute_str})

# Normalize yes/no text on string columns
def norm_bool(col):
    return (
        F.when(F.lower(F.col(col)).isin("true","t","yes","y","1"), "true")
         .when(F.lower(F.col(col)).isin("false","f","no","n","0"), "false")
         .otherwise(F.col(col))
    )

for c in str_cols:
    df = df.withColumn(c, norm_bool(c))

# Remove duplicates
df = df.dropDuplicates()

# Save single clean CSV
tmp_dir = Path("/home/sat3812/Downloads/mi_clean_light_tmp")
df.coalesce(1).write.mode("overwrite").option("header", True).csv(str(tmp_dir))
part_files = list(tmp_dir.glob("part-*.csv"))
if part_files:
    out_path = Path(OUT_SINGLE_CSV)
    if out_path.exists():
        out_path.unlink()
    shutil.move(str(part_files[0]), OUT_SINGLE_CSV)

# Cleanup temp dir
if tmp_dir.exists():
    for p in tmp_dir.glob("*"):
        try:
            p.unlink()
        except IsADirectoryError:
            shutil.rmtree(p, ignore_errors=True)
    try:
        tmp_dir.rmdir()
    except OSError:
        shutil.rmtree(tmp_dir, ignore_errors=True)

# Create and save summary report
report = {
    "rows": row_count,
    "cols": len(df.columns),
    "dropped_columns_over_90pct_missing": to_drop,
    "imputed_columns_under_40pct_missing": to_impute,
    "output_csv": OUT_SINGLE_CSV
}
with open(REPORT_PATH, "w") as f:
    json.dump(report, f, indent=2)
print(json.dumps(report, indent=2))

spark.stop()

