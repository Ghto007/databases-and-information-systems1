# create_compound_index.py
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

# Створення складеного індексу на category і timestamp
collection.create_index([("category", 1), ("timestamp", -1)])

print("Складений індекс створено.")
