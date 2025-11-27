# E-commerce Product Analytics - Data Cleaning
# Author: Arun Santhosh
# Tools: Python, Pandas

import pandas as pd

# Load datasets
products = pd.read_csv("amazon_products_2024.csv")
categories = pd.read_csv("amazon_categories_2024.csv")

print("Raw Products Shape:", products.shape)
print("Raw Categories Shape:", categories.shape)

# 1. Remove duplicates
products = products.drop_duplicates()
categories = categories.drop_duplicates()

# 2. Clean Price (remove ₹, commas, convert to number)
products["price"] = (
    products["price"]
    .astype(str)
    .str.replace("₹", "", regex=False)
    .str.replace(",", "", regex=False)
    .astype(float)
)

# 3. Clean Rating (replace missing or 'No rating')
products["rating"] = (
    products["rating"]
    .replace("No rating", None)
    .astype(float)
)

# 4. Replace missing reviews with 0
products["reviews"] = (
    products["reviews"]
    .replace("No reviews", 0)
    .fillna(0)
    .astype(int)
)

# 5. Merge products + categories
final_df = products.merge(categories, how="left", on="category_id")

# 6. Summary statistics
summary = final_df.groupby("main_category").agg(
    total_products=("product_id", "count"),
    avg_price=("price", "mean"),
    avg_rating=("rating", "mean")
)

# Save outputs
final_df.to_csv("cleaned_ecommerce_data.csv", index=False)
summary.to_csv("category_summary.csv")

print("Cleaning Completed.")
print("Final Cleaned Rows:", final_df.shape[0])
