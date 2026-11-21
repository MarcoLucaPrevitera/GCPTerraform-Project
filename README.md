# Cloud-Based Restaurant Data Pipeline with GCP and Terraform

## Project Overview
The project involves building a cloud-based data pipeline to process and analyse a simplified demo restaurant sales dataset using Python, Terraform, Google Cloud Platform (GCP), and BigQuery.

This is a personal project to learn and get hands-on experience with cloud-based Data Engineering technologies.

This pipeline processes sales records, identifies and removes invalid and duplicate entries, and uploads the resulting cleaned dataset to Google Cloud Storage (GCS). The cleaned dataset is subsequently loaded into Google BigQuery, where it can be queried with SQL and analysed directly within the cloud environment.

The infrastructure is managed as code using Terraform, allowing cloud
resources to be provisioned and maintained in a reproducible way.

The project demonstrates fundamental Data Engineering concepts,
including:

-   Data ingestion and transformation with Python.
-   Data quality checks and cleaning.
-   Cloud object storage with Google Cloud Storage.
-   Data warehousing with BigQuery.
-   Infrastructure as Code with Terraform.
-   Analytical SQL queries.

## Architecture



## Repository Structure

``` text
restaurant-data-pipeline/
│
├── data/
│   ├── orders.csv
│   └── orders_clean.csv
│
├── src/
│   └── etl.py
│
├── terraform/
│   ├── main.tf
│   ├── storage.tf
│   ├── bigquery.tf
│   ├── table.tf
│   ├── object.tf
│   └── load.tf
│
├── sql/
│   ├── sales_analysis.sql
│   ├── daily_sales.sql
│   └── top_products.sql
│
├── .gitignore
└── README.md
```

## 1. Prerequisites

Before getting started, make sure you have the following prerequisites installed and configured:

-   A Google Cloud account.
-   An existing Google Cloud project.
-   Python 3 and pip.
-   Ubuntu 22.04 or later (or another compatible Linux environment).

The project uses the following GCP configuration:

| Setting | Value |
|---|---|
| Project name | `restaurant-data-pipeline` |
| Region | `europe-west1` |
| Storage location | `EU` |
| BigQuery dataset name | `restaurant_analytics` |
| BigQuery table name | `orders` |

## 2. Input Dataset

The pipeline uses a simplified demo dataset of restaurant orders stored in CSV format.

Since this is a personal project aimed at learning and experimenting with cloud technologies, the dataset is intentionally kept simple. The main focus is on building and understanding the data pipeline rather than working with a complex or realistic dataset.

The dataset uses the following structure:

| Field | Data type | Description
|---|---|---|
| `order_id` | INTEGER | Unique identifier assigned to each order.
| `date` | DATE | Date when the order was placed. |
| `product` | STRING | Name of the product ordered. |
| `quantity` | INTEGER | Number of units ordered. |
| `unit_price` | FLOAT | Price of a single unit of the product. |

The original dataset also contains intentionally duplicated and invalid
records to demonstrate data quality checks.

## 3. Python Environment Setup

Clone the repository and navigate to the project directory:

``` bash
git clone https://github.com/MarcoLucaPrevitera/GCPTerraform-Project
cd restaurant-data-pipeline
```

Create a virtual environment:

``` bash
python3 -m venv .venv
```

Activate it:

``` bash
source .venv/bin/activate
```

Install the required Python library:

``` bash
pip install pandas
```

## 4. Python ETL Process

The ETL script is responsible for reading, cleaning, transforming, and
exporting the dataset.

Run the script from the project root:

``` bash
python src/etl.py
```

The script performs the following operations:

1.  Reads the original CSV file.
2.  Removes duplicated orders based on `order_id`.
3.  Removes rows containing missing values.
4.  Filters out non-positive quantities and unit prices.
5.  Converts the order date into a date format.
6.  Calculates the total amount for each order.
7.  Exports the cleaned dataset to `data/orders_clean.csv`.

The resulting dataset contains the following columns:

| Column | Description |
|---|---|
| `order_id` | Unique order identifier. |
| `date` | Date when the order was placed. |
| `product` | Name of the ordered product. |
| `quantity` | Number of units ordered. |
| `unit_price` | Price per unit. |
| `total_amount` | Total order amount, calculated by multiplying quantity by unit price. |

## 5. Google Cloud CLI Installation and Configuration

The Google Cloud CLI (`gcloud`) is used in this project to authenticate with Google Cloud, configure the active project, and verify the connection. Infrastructure resources will then be created and managed through Terraform, rather than manually through the CLI.

### 5.1 Install Google Cloud CLI

On Ubuntu (64-bit), to install gcloud and automatically receive updates add the Google repository to the apt package manager:

Firstly import the public gpg key:
```bash
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
```

Then add the gcloud repo URI in apt packets origin sources:
```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

FInally update apt and install gcloud CLI:
```bash
sudo apt-get update && sudo apt-get install google-cloud-cli
```
### 5.2 Login in Google Cloud CLI
First, authenticate your Google account. This opens a browser window where you can select your Google account and grant the required permissions.
```bash
gcloud auth login
```

Next, configure Application Default Credentials (ADC), which allow tools such as the Terraform Google provider to authenticate:
```bash
gcloud auth application-default login
```

### 5.3 Set the working project
Set the project used by the CLI:
```bash
gcloud config set project <insert-project-id>
```

Verify the active project:
```bash
gcloud config get-value project
```
## 6. Terraform Installation and Configuration

Terraform is used in this project to define, provision, and manage Google Cloud infrastructure as code (IaC). Instead of creating resources manually through the Google Cloud Console or Google Cloud CLI, Terraform uses configuration files written in HCL (HashiCorp Configuration Language) to manage resources such as the Cloud Storage bucket, BigQuery dataset, and BigQuery table.

### 6.1 Install Terraform

On Ubuntu (64-bit), download the official Terraform binary from HashiCorp.

Firstly import the public gpg key:
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```

Then add the HashiCorp repository to apt packets origin sources:
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

Finally update apt and install Terraform:
```bash
sudo apt-get update && sudo apt-get install terraform
```

Verify the installation:

```bash
terraform version
```

### 6.2 Initialize the Terraform project

Navigate to the Terraform configuration directory:

```bash
cd ~/restaurant-data-pipeline/terraform
```

Initialize the working directory:

```bash
terraform init
```

This command downloads the required providers and initializes the Terraform working environment. In this project, the Google provider (`hashicorp/google`) is used to interact with Google Cloud.


## 7. Terraform Infrastructure

After succesful gcloud CLI installation and configuration, Terraform is ready to manage the GCP infrastructure.

Navigate to the Terraform directory:

``` bash
cd terraform
```

### 7.1 Provider Configuration

The `main.tf` file defines the Google provider and the required
Terraform version.

``` hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "google" {
  project = "sincere-cortex-515213-t6"
  region  = "europe-west1"
}
```

### 7.2 Google Cloud Storage Bucket

The `storage.tf` file defines the storage bucket.

``` hcl
resource "google_storage_bucket" "orders_bucket" {
  name          = "restaurant-orders-data-73811378311"
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }
}
```

The bucket stores the cleaned restaurant orders dataset CSV file.

Uniform bucket-level access is enabled to manage permissions through IAM
rather than individual object ACLs.

### 7.3 BigQuery Dataset

The `bigquery.tf` file defines the analytical dataset.

``` hcl
resource "google_bigquery_dataset" "restaurant_analytics" {
  dataset_id = "restaurant_analytics"
  location   = "EU"

  description = "Dataset for restaurant sales analytics"
}
```

The dataset is created in the EU multi-region.

### 7.4 BigQuery Table

The `table.tf` file defines the destination table and its schema.

``` hcl
resource "google_bigquery_table" "orders" {
  dataset_id = google_bigquery_dataset.restaurant_analytics.dataset_id
  table_id   = "orders"

  description = "Cleaned restaurant orders data"

  schema = jsonencode([
    {
      name = "order_id"
      type = "INTEGER"
      mode = "NULLABLE"
    },
    {
      name = "date"
      type = "DATE"
      mode = "NULLABLE"
    },
    {
      name = "product"
      type = "STRING"
      mode = "NULLABLE"
    },
    {
      name = "quantity"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "unit_price"
      type = "FLOAT"
      mode = "NULLABLE"
    },
    {
      name = "total_amount"
      type = "FLOAT"
      mode = "NULLABLE"
    }
  ])
}
```

The schema reflects the data types detected in the existing BigQuery
table.

## 8. Validate and Run Terraform Configuration

Format the configuration files:

``` bash
terraform fmt
```

Validate the configuration:

``` bash
terraform validate
```

Review the proposed infrastructure changes:

``` bash
terraform plan
```

If the plan is correct, apply it:

``` bash
terraform apply
```


## 9. Uploading the Cleaned CSV to Google Cloud Storage

++++++++++aggiungi creazione infrastuttura

### 9.1 Loading the Dataset into the Bucket
After executing the Python ETL script, the cleaned dataset is saved as `data/orders_clean.csv`.

Upload the file to the Google Cloud Storage bucket using the Google Cloud CLI:

```bash
gcloud storage cp data/orders_clean.csv gs://restaurant-orders-data-73811378311/
```

This command uploads the cleaned CSV file to the previously created Cloud Storage bucket.

To verify the upload:

```bash
gcloud storage ls gs://restaurant-orders-data-73811378311/
```

### 9.2 Loading Data into BigQuery

Once the CSV file is available in Cloud Storage, load it into the existing BigQuery table using the BigQuery command-line tool (`bq`):

```bash
bq load \
  --location=EU \
  --replace \
  --source_format=CSV \
  --skip_leading_rows=1 \
  restaurant_analytics.orders \
  gs://restaurant-orders-data-73811378311/orders_clean.csv
```

The command uses the following options:

- `--location=EU`: specifies the BigQuery dataset location.
- `--replace`: replaces the existing table data instead of appending duplicate records.
- `--source_format=CSV`: specifies the input file format.
- `--skip_leading_rows=1`: skips the CSV header row.

The destination is the existing `orders` table in the `restaurant_analytics` dataset.

## 10. SQL Analytics

SQL queries are maintained separately in the `sql/` directory and can be
executed using the BigQuery Console.

### 10.1 Sales Analysis by Product

File: `sql/sales_analysis.sql`

``` sql
SELECT
    product,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(total_amount), 2) AS revenue
FROM
    `sincere-cortex-515213-t6.restaurant_analytics.orders`
GROUP BY
    product
ORDER BY
    revenue DESC;
```

This query calculates total units sold and revenue for each product.

### 10.2 Daily Sales Analysis

File: `sql/daily_sales.sql`

``` sql
SELECT
    date,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(total_amount), 2) AS daily_revenue
FROM
    `sincere-cortex-515213-t6.restaurant_analytics.orders`
GROUP BY
    date
ORDER BY
    date;
```

This query provides daily order counts and revenue.

### 10.3 Top Selling Products

File: `sql/top_products.sql`

``` sql
SELECT
    product,
    SUM(quantity) AS units_sold,
    ROUND(SUM(total_amount), 2) AS revenue
FROM
    `sincere-cortex-515213-t6.restaurant_analytics.orders`
GROUP BY
    product
ORDER BY
    units_sold DESC;
```

This query ranks products by sales volume.


## 11. Running SQL Queries with BigQuery CLI

The SQL queries stored in the `sql/` directory can be executed directly from the terminal using the BigQuery command-line tool (`bq`).

For example, to run the sales analysis query:

```bash
bq query --use_legacy_sql=false < sql/sales_analysis.sql
```

The `--use_legacy_sql=false` option enables **GoogleSQL (Standard SQL)**, which is used by the queries in this project.

Query results are printed directly in the terminal. The queries analyze the data stored in the `restaurant_analytics.orders` BigQuery table. The result of the sales analysis query is shown:

| Product | Units Sold | Revenue |
|---|---:|---:|
| Burger | 6 | 54.00 |
| Pizza | 6 | 51.00 |
| Pasta | 3 | 30.00 |
| Salad | 1 | 7.50 |
| **Total** | **16** | **142.50** |

## Conclusion

This project demonstrates a basic cloud-based data pipeline using
Python, Google Cloud Storage, BigQuery, SQL, and Terraform. It provides practical experience with Infrastructure as Code, data ingestion, transformation,
storage and analytical querying.
