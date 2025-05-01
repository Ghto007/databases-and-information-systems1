# query_with_index.py
import time
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

start_time = time.time()

# Виконання запиту з індексом
results = list(collection.find({"category": "Electronics"}))

end_time = time.time()

print(f"Час виконання запиту з індексом: {end_time - start_time:.6f} секунд")
