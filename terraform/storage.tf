resource "google_storage_bucket" "orders_bucket" {
  name          = "restaurant-orders-data-738"
  location      = "EU"
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }
}
