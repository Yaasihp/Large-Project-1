# Big Data Preprocessing of Myocardial Infarction Dataset using Spark-Hadoop Cluster
## Project Overview
This project focuses on building a distributed data processing system using Apache Hadoop and Apache Spark on Fedora virtual machines. It configures hadoop1 as the master node and hadoop2 (Or as many that the user can add) as worker nodes to process the UCI Myocardial Infarction dataset efficiently. By combining Hadoop’s distributed storage and Spark’s parallel computation, the project enables scalable preprocessing and analysis of healthcare data to support predictive modeling and clinical decision-making
## Project Ojectives and Activities
- 🧠 Built a distributed data processing environment using Apache Hadoop and Apache Spark on Fedora virtual machines.
- 🖥️ Set up two interconnected VMs and configured a network cluster for scalable data handling.
- 🔑 Implemented passwordless SSH access to enable secure, seamless communication between nodes.
- 🧩 Assigned hadoop1 as the master node and hadoop2 as the worker node to support parallel computation.
- 💻 Launched PySpark sessions across the cluster for distributed data processing.
- 🧹Performed data preprocessing on the UCI Myocardial Infarction dataset, including cleaning, transformation, and feature selection.
- 📊 Demonstrated scalable analytics in a simulated healthcare data pipeline using Spark and HDFS integration
## Technologies Used
- 🐘 Apache Hadoop – for distributed storage and cluster management
- ⚡ Apache Spark – for parallel data processing and computation
- 🐍 PySpark – for executing Python-based distributed data workflows
- 🧩 Fedora Linux – as the base operating system for virtual machines
- 🔑 SSH (Secure Shell) – for passwordless and secure inter-node communication
- 🗂️ HDFS (Hadoop Distributed File System) – for scalable data storage and access
## Challenges Faced
- 💾 Limited RAM — The virtual machines had low memory capacity, which increased the execution time for most Spark and Hadoop commands.
- 🌐 Network Configuration Issues — Setting up the cluster network was challenging, and an Amazon Network shutdown temporarily disrupted connectivity between nodes.
- 🐧 Fedora Navigation Difficulties — Navigating and configuring system files in Fedora required additional learning, especially during environment setup and SSH configuration.
## Carry-on Lessons
- 🧩 Acquired practical experience in configuring and managing Apache Hadoop and Apache Spark clusters within a Fedora Linux environment.
- 🔑 Gained proficiency in setting up secure, passwordless SSH communication to facilitate seamless interaction between master and worker nodes.
- 💾 Recognized the impact of hardware limitations, particularly limited RAM, on the performance and efficiency of distributed systems.
- 🧰 Enhanced skills in network configuration, troubleshooting, and system integration within a clustered architecture.
- 💻 Strengthened command-line and system administration expertise, improving confidence in Linux-based operations.
- 🚀 Developed advanced problem-solving and debugging abilities through practical deployment and testing challenges.
- 🌐 Deepened understanding of distributed computing principles and their application to scalable data processing.
- 🧮 Appreciated the importance of resource planning and optimization for stable and efficient system performance.
- 🔓 Built confidence in leveraging open-source big data tools for research and healthcare data analytics applications.
