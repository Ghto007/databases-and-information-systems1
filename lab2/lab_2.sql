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
	APPOINTMENT (PETID, VETID, DATE, DIAGNOSIS)
VALUES
	(1, 1, '2024-02-10', 'Алергія'),
	(2, 2, '2024-02-12', 'Травма лапи');

INSERT INTO
	MEDICATION (NAME, PURPOSE, PRICE)
VALUES
	('Антигістамін', 'Лікування алергії', 300.00),
	('Знеболювальне', 'Зменшення болю', 500.00);

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
