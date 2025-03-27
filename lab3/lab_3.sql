-- Лабораторна робота №3
-- З дисципліни: Бази даних та інформаційні системи
-- Студента групи МІТ-31 Якоба Романа

INSERT INTO
	OWNER (NAME, CONTACT)
VALUES
	('Олексій Коваленко', 'kovalenko@example.com'),
	('Анна Бондар', 'bondar@example.com');

INSERT INTO
	PET (NAME, SPECIES, BREED, AGE, OWNERID)
VALUES
	('Барсик', 'Кіт', 'Персидський', 3, 1),
	('Рекс', 'Собака', 'Німецька вівчарка', 5, 2);

INSERT INTO Pet (Name, Species, Breed, Age, OwnerID)
VALUES 
    ('Мурзик', 'Кіт', 'Дворовий', 2, 1),
    ('Мурзик', 'Кіт', 'Дворовий', 2, 1),  -- Дублікат
    ('Шарик', 'Собака', 'Дворовий', 4, 1),
    ('Тузик', 'Собака', 'Дворовий', 3, 2),
    ('Тузик', 'Собака', 'Дворовий', 3, 2); -- Дублікат

INSERT INTO
	VETERINARIAN (NAME, SPECIALIZATION, CONTACT)
VALUES
	(
		'Дмитро Іванов',
		'Дерматолог',
		'ivanov@example.com'
	),
	('Олена Петрова', 'Ортопед', 'petrova@example.com');

	INSERT INTO
	VETERINARIAN (NAME, SPECIALIZATION, CONTACT)
VALUES
    ('Марія Сидоренко', 'Дерматолог', 'sydorenko@example.com'),
    ('Ігор Василенко', 'Ортопед', 'vasylenko@example.com'),
    ('Наталія Коваль', 'Терапевт', 'koval@example.com'),
    ('Андрій Мельник', 'Хірург', 'melnyk@example.com'),
    ('Софія Лисенко', 'Дерматолог', 'lysenko@example.com');

INSERT INTO
	APPOINTMENT (PETID, VETID, DATE, DIAGNOSIS)
VALUES
	(1, 1, '2024-02-10', 'Алергія'),
	(2, 2, '2024-02-12', 'Травма лапи');

INSERT INTO
	MEDICATION (NAME, PURPOSE, PRICE)
VALUES
	('Антигістамін', 'Лікування алергії', 300.00),
	('Знеболювальне', 'Зменшення болю', 500.00);


INSERT INTO Medication (Name, Purpose, Price)
VALUES ('Новий ліки', 'Тестовий препарат', 100.00);

INSERT INTO
	PRESCRIPTION (APPOINTMENTID, MEDICATIONID, DOSAGE, DURATION)
VALUES
	(1, 1, '1 таблетка', 7),
	(2, 2, '2 мл', 5);

-- Вибірка всіх тварин
SELECT * FROM Pet;

-- Унікальні види тварин
SELECT DISTINCT Species FROM Pet;

-- Максимальний і мінімальний вік тварин
SELECT MAX(Age) AS MaxAge, MIN(Age) AS MinAge FROM Pet;

-- Кількість прийомів у кожного лікаря
SELECT VetID, COUNT(AppointmentID) AS TotalAppointments FROM Appointment GROUP BY VetID;

-- Кількість тварин у кожного власника
SELECT OwnerID, COUNT(PetID) AS TotalPets FROM Pet GROUP BY OwnerID;

-- Загальна сума проданих ліків
SELECT SUM(Price) AS TotalMedicationSales FROM Medication;


-- Логічні оператори (AND, OR, NOT) 
-- 1. Тварини старші 3 років, які належать власнику з ID=2
SELECT * FROM Pet 
WHERE Age > 3 AND OwnerID = 2;

-- 2. Прийоми після 2024-02-11 з діагнозом "Травма"
SELECT * FROM Appointment 
WHERE DATE > '2024-02-11' OR Diagnosis LIKE '%Травма%';

-- 3. Ліки вартістю від 200 до 600 грн
SELECT * FROM Medication 
WHERE Price BETWEEN 200 AND 600;

-- Агрегатні функції (COUNT, SUM, AVG, MIN, MAX)
-- 4. Кількість тварин кожного виду
SELECT Species, COUNT(*) AS Total 
FROM Pet 
GROUP BY Species;

-- 5. Середній вік тварин
SELECT AVG(Age) AS AverageAge FROM Pet;

-- 6. Найдорожчий та найдешевший ліки
SELECT MAX(Price) AS MaxPrice, MIN(Price) AS MinPrice 
FROM Medication;

-- 7. Загальна сума витрат на ліки для кожного призначення
SELECT PrescriptionID, SUM(Price) AS TotalCost 
FROM Prescription 
JOIN Medication ON Prescription.MedicationID = Medication.MedicationID 
GROUP BY PrescriptionID;

-- JOIN (INNER, LEFT, RIGHT, FULL, CROSS, SELF)
-- 8. INNER JOIN: Прийоми з деталями тварин та лікарів
SELECT A.Date, P.Name AS PetName, V.Name AS VetName 
FROM Appointment A
INNER JOIN Pet P ON A.PetID = P.PetID
INNER JOIN Veterinarian V ON A.VetID = V.VetID;

-- 9. LEFT JOIN: Всі власники та їхні тварини (навіть без тварин)
SELECT O.Name AS OwnerName, P.Name AS PetName 
FROM Owner O
LEFT JOIN Pet P ON O.OwnerID = P.OwnerID;

-- 10. RIGHT JOIN: Всі ліки та їхні призначення (навіть невикористані)
SELECT M.Name, P.PrescriptionID 
FROM Medication M
RIGHT JOIN Prescription P ON M.MedicationID = P.MedicationID;

-- 11. FULL JOIN: Всі лікарі та прийоми (навіть без прийомів)
SELECT V.Name, A.AppointmentID 
FROM Veterinarian V
FULL JOIN Appointment A ON V.VetID = A.VetID;

-- 12. CROSS JOIN: Всі комбінації тварин та лікарів
SELECT P.Name AS PetName, V.Name AS VetName 
FROM Pet P
CROSS JOIN Veterinarian V;

-- Приклад 13: Лікарі з однаковою спеціалізацією
SELECT 
    V1.Name AS Vet1, 
    V2.Name AS Vet2, 
    V1.Specialization 
FROM Veterinarian V1
JOIN Veterinarian V2 
    ON V1.Specialization = V2.Specialization 
WHERE V1.VetID <> V2.VetID;

-- Підзапити (WHERE, IN, EXISTS, NOT EXISTS)
-- 14. Тварини, які мали прийоми у дерматологів (IN)
SELECT * FROM Pet 
WHERE PetID IN (
    SELECT PetID FROM Appointment 
    WHERE VetID IN (
        SELECT VetID FROM Veterinarian 
        WHERE Specialization = 'Дерматолог'
    )
);

-- 15. Власники без тварин (NOT EXISTS)
SELECT * FROM Owner O
WHERE NOT EXISTS (
    SELECT 1 FROM Pet P 
    WHERE P.OwnerID = O.OwnerID
);

-- 16. Ліки, які ніколи не призначалися (NOT IN)
SELECT * FROM Medication 
WHERE MedicationID NOT IN (
    SELECT MedicationID FROM Prescription
);

-- 17. Прийоми з ліками вартістю понад 400 грн (EXISTS)
SELECT * FROM Appointment A
WHERE EXISTS (
    SELECT 1 FROM Prescription P 
    JOIN Medication M ON P.MedicationID = M.MedicationID 
    WHERE P.AppointmentID = A.AppointmentID AND M.Price > 400
);

-- Операції над множинами (UNION, INTERSECT, EXCEPT)
-- 18. UNION: Імена власників та лікарів
SELECT Name FROM Owner
UNION
SELECT Name FROM Veterinarian;

-- 19. UNION ALL: Всі контакти (з дублями)
SELECT Contact FROM Owner
UNION ALL
SELECT Contact FROM Veterinarian;

-- 20. INTERSECT: Спеціалізації лікарів, які мали прийоми
SELECT Specialization FROM Veterinarian
INTERSECT
SELECT Specialization FROM Veterinarian 
WHERE VetID IN (SELECT VetID FROM Appointment);

-- 21. EXCEPT: Ліки, які не призначалися
SELECT Name FROM Medication
EXCEPT
SELECT M.Name FROM Medication M 
JOIN Prescription P ON M.MedicationID = P.MedicationID;

-- CTE (Common Table Expressions)
-- 22. CTE: Середній вік тварин за видами
WITH SpeciesAvg AS (
    SELECT Species, AVG(Age) AS AvgAge 
    FROM Pet 
    GROUP BY Species
)
SELECT * FROM SpeciesAvg;

-- 23. CTE з JOIN: Прийоми з інформацією про ліки
WITH AppointmentsWithMeds AS (
    SELECT A.AppointmentID, M.Name AS MedicationName 
    FROM Appointment A
    JOIN Prescription P ON A.AppointmentID = P.AppointmentID
    JOIN Medication M ON P.MedicationID = M.MedicationID
)
SELECT * FROM AppointmentsWithMeds;

-- 24. Рекурсивний CTE: Власники та кількість їхніх тварин (приклад)
WITH OwnerPetCount AS (
    SELECT OwnerID, COUNT(PetID) AS TotalPets 
    FROM Pet 
    GROUP BY OwnerID
)
SELECT O.Name, COALESCE(OPC.TotalPets, 0) AS Pets 
FROM Owner O
LEFT JOIN OwnerPetCount OPC ON O.OwnerID = OPC.OwnerID;

-- Віконні функції (Window Functions)
-- 25. RANK: Рейтинг лікарів за кількістю прийомів
SELECT VetID, COUNT(*) AS Appointments,
RANK() OVER (ORDER BY COUNT(*) DESC) AS Rank
FROM Appointment 
GROUP BY VetID;

-- 26. ROW_NUMBER: Нумерація тварин за віком
SELECT Name, Age, 
ROW_NUMBER() OVER (ORDER BY Age DESC) AS AgeRank 
FROM Pet;

-- 27. DENSE_RANK: Рейтинг ліків за ціною
SELECT Name, Price,
DENSE_RANK() OVER (ORDER BY Price DESC) AS PriceRank 
FROM Medication;

-- 28. SUM() OVER: Накопичувальна сума витрат на ліки
SELECT PrescriptionID, Price,
SUM(Price) OVER (ORDER BY PrescriptionID) AS CumulativeSum 
FROM Prescription 
JOIN Medication ON Prescription.MedicationID = Medication.MedicationID;

-- 29. LEAD: Порівняння ціни ліків з наступним записом
SELECT Name, Price,
LEAD(Price) OVER (ORDER BY Price) AS NextPrice 
FROM Medication;

-- Складні комбінації
-- 30. Підзапит у SELECT: Кількість прийомів для кожної тварини
SELECT P.Name, 
(SELECT COUNT(*) FROM Appointment A WHERE A.PetID = P.PetID) AS Appointments 
FROM Pet P;

-- 31. Фільтрація в GROUP BY: Види тварин з середнім віком > 4
SELECT Species, AVG(Age) AS AvgAge 
FROM Pet 
GROUP BY Species 
HAVING AVG(Age) > 4;

-- 32. Використання CASE: Класифікація тварин за віком
SELECT Name, Age,
CASE 
    WHEN Age < 2 THEN 'Молода'
    WHEN Age BETWEEN 2 AND 5 THEN 'Доросла'
    ELSE 'Старша'
END AS AgeCategory 
FROM Pet;

-- 33. JOIN з агрегатною функцією: Лікарі та кількість їхніх призначень
SELECT V.Name, COUNT(A.AppointmentID) AS TotalAppointments 
FROM Veterinarian V
LEFT JOIN Appointment A ON V.VetID = A.VetID 
GROUP BY V.Name;

-- 34. Вкладений CTE: Аналіз ліків та їх використання
WITH MedUsage AS (
    SELECT M.Name, COUNT(P.PrescriptionID) AS TimesPrescribed 
    FROM Medication M
    LEFT JOIN Prescription P ON M.MedicationID = P.MedicationID 
    GROUP BY M.Name
)
SELECT * FROM MedUsage 
WHERE TimesPrescribed > 0;

-- 35. Віконна функція з PARTITION BY: Середня ціна ліків за призначенням
SELECT PrescriptionID, M.Name, M.Price,
AVG(Price) OVER (PARTITION BY A.VetID) AS AvgPricePerVet 
FROM Prescription P
JOIN Medication M ON P.MedicationID = M.MedicationID
JOIN Appointment A ON P.AppointmentID = A.AppointmentID;

-- 36. Використання WITH TIES: Топ-2 найдорожчих ліків
SELECT Name, Price 
FROM Medication 
ORDER BY Price DESC 
LIMIT 2;

-- 37. Рекурсивний запит: Генерація послідовності дат (приклад)
WITH Dates AS (
    SELECT CAST('2024-01-01' AS DATE) AS Date
    UNION ALL
    SELECT '2024-01-02'::DATE
    UNION ALL
    SELECT '2024-01-03'::DATE
)
SELECT * FROM Dates;

-- 38. PIVOT: Кількість тварин за видами та власниками (приклад)
SELECT OwnerID,
    COUNT(CASE WHEN Species = 'Кіт' THEN 1 END) AS "Кіт",
    COUNT(CASE WHEN Species = 'Собака' THEN 1 END) AS "Собака"
FROM Pet
GROUP BY OwnerID;

-- 39. Видалення дублікатів через CTE
DELETE FROM Pet
WHERE PetID IN (
    SELECT PetID
    FROM (
        SELECT PetID,
               ROW_NUMBER() OVER (PARTITION BY Name, Species ORDER BY PetID) AS RN
        FROM Pet
    ) AS Subquery
    WHERE RN > 1
);

-- 40. Динамічний SQL: Створення тимчасової таблиці (приклад)
CREATE OR REPLACE FUNCTION create_temp_table(table_name TEXT) RETURNS VOID AS $$
BEGIN
    EXECUTE 'CREATE TABLE ' || table_name || ' (ID INT)';
END;
$$ LANGUAGE plpgsql;

-- Виклик функції
SELECT create_temp_table('TempTable');
