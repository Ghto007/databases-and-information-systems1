import redis

# Підключення до Redis (локально, порт 6379)
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

# Збільшуємо лічильник
r.incr('mycounter')
print("Лічильник:", r.get('mycounter'))

# Додаємо задачі в список
r.lpush('tasks', 'Написати звіт', 'Пройти захист')
print("Список задач:")
print(r.lrange('tasks', 0, -1))

# Публікуємо повідомлення (наприклад, у канал)
r.publish('updates', 'Користувач виконав завдання!')
