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
