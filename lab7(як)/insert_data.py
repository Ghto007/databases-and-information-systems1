from pymongo import MongoClient
import random
import datetime

# Підключення до MongoDB
client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

# Категорії товарів
categories = ["Electronics", "Clothing", "Books", "Home", "Sports"]

# Генерація 100 000 документів
documents = [
    {
        "customer_id": random.randint(1, 1000),
        "category": random.choice(categories),
        "amount": round(random.uniform(5, 500), 2),
        "timestamp": datetime.datetime(2024, random.randint(1, 12), random.randint(1, 28))
    }
    for _ in range(100000)
]

# Вставка документів
collection.insert_many(documents)
print(" Успішно вставлено 100 000 документів у колекцію 'sales'.")
