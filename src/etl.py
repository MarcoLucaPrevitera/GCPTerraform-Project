import pandas as pd
from pathlib import Path

# Define file paths
input_file = Path("data/orders.csv")
output_file = Path("data/orders_clean.csv")

# Extract
print("Reading input dataset...")
df = pd.read_csv(input_file)

print(f"Original rows: {len(df)}")

# Transform
print("Cleaning dataset...")

# Remove duplicate orders
df = df.drop_duplicates(subset=["order_id"])

# Remove rows with missing values
df = df.dropna()

# Remove invalid quantities and prices
df = df[
    (df["quantity"] > 0) &
    (df["unit_price"] > 0)
].copy()

# Convert date column
df["date"] = pd.to_datetime(df["date"])

# Calculate total amount
df["total_amount"] = df["quantity"] * df["unit_price"]

# Load
df.to_csv(output_file, index=False)

print(f"Clean rows: {len(df)}")
print(f"Clean dataset saved to: {output_file}")

print("\nClean dataset preview:")
print(df)
