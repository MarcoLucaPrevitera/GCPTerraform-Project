resource "google_bigquery_dataset" "restaurant_analytics" {
  dataset_id = "restaurant_analytics"
  location   = "EU"

  description = "Dataset for restaurant sales analytics"
}
