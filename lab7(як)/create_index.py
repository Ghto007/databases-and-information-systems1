# create_index.py
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

# Створення індексу на полі "category"
collection.create_index("category")

print("Індекс створено.")
