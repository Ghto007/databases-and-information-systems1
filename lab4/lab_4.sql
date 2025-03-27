
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
SELECT * FROM APPOINTMENT;
SELECT * FROM VETERINARIAN;


-- Етап 1:
-- Створення користувацького типу ENUM:
CREATE TYPE appointment_status AS ENUM ('scheduled', 'completed', 'canceled');

-- Додавання нового стовпця до таблиці Appointment:
ALTER TABLE Appointment ADD COLUMN status appointment_status DEFAULT 'scheduled';

--Перевірка цілісності даних:
SELECT * FROM Appointment;

-- Етап 2:
-- Створення функції для розрахунку середнього віку тварин:
CREATE OR REPLACE FUNCTION calculate_average_pet_age() RETURNS NUMERIC AS $$
BEGIN
    RETURN (SELECT AVG(Age) FROM Pet);
END;
$$ LANGUAGE plpgsql;

-- Використання функції у тестовому запиті:
SELECT calculate_average_pet_age() AS average_pet_age;

-- Етап 3:
-- Створення таблиці для логування змін у таблиці Appointment:
CREATE TABLE appointment_log (
    log_id SERIAL PRIMARY KEY,
    appointment_id INT,
    operation CHAR(1),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Створення тригерної функції для логування:
CREATE OR REPLACE FUNCTION log_appointment_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO appointment_log (appointment_id, operation)
    VALUES (NEW.AppointmentID, SUBSTRING(TG_OP, 1, 1)); -- Записує перший символ ('I', 'U', 'D')
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Прив’язання тригера до таблиці Appointment:
CREATE TRIGGER track_appointment_changes
AFTER INSERT OR UPDATE OR DELETE ON Appointment
FOR EACH ROW
EXECUTE FUNCTION log_appointment_changes();


-- Додавання нового запису
INSERT INTO Appointment (PetID, VetID, Date, Diagnosis, status)
VALUES (3, 1, '2024-03-01', 'Перевірка', 'scheduled');

-- Оновлення запису
UPDATE Appointment SET status = 'completed' WHERE AppointmentID = 1;

-- Видалення запису
DELETE FROM Appointment WHERE AppointmentID
= 9;

SELECT * FROM appointment_log;

DELETE FROM  appointment_log WHERE log_ID
= 3;

-- Додавання стовпця totalappointments
ALTER TABLE Veterinarian 
ADD COLUMN totalappointments INT DEFAULT 0;

--  тригер для оновлення totalappointments
CREATE OR REPLACE FUNCTION update_vet_appointments()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE Veterinarian 
        SET totalappointments = totalappointments + 1 
        WHERE VetID = NEW.VetID;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE Veterinarian 
        SET totalappointments = totalappointments - 1 
        WHERE VetID = OLD.VetID;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER track_vet_appointments
AFTER INSERT OR DELETE ON Appointment
FOR EACH ROW
EXECUTE FUNCTION update_vet_appointments();

-- Перевірка роботи тригера
INSERT INTO Appointment (PetID, VetID, Date, Diagnosis, status)
VALUES (1, 1, '2024-03-01', 'Тест', 'scheduled');

-- Після додавання прийому
INSERT INTO Appointment (...) VALUES (...);
SELECT TotalAppointments FROM Veterinarian WHERE VetID = 1;

SELECT * FROM VETERINARIAN;