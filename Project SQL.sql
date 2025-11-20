CREATE DATABASE HealthcareDB;
USE HealthcareDB;

-- Patient table
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    contact VARCHAR(15)
);

-- Doctor table
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(50),
    contact VARCHAR(15)
);

-- Appointments table
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    diagnosis VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- Medication table 
CREATE TABLE Medications (
    medication_id INT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

-- Prescription table 
CREATE TABLE Prescriptions (
    prescription_id INT PRIMARY KEY,
    appointment_id INT,
    medication_id INT,
    dosage VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id),
    FOREIGN KEY (medication_id) REFERENCES Medications(medication_id)
);

-- Sample Data 

INSERT INTO Patients VALUES
(1, 'Ali Khan', 35, 'Male', '9001234567'),
(2, 'Sara Sheikh', 28, 'Female', '9012345678'); 

INSERT INTO Doctors VALUES
(1, 'Dr. Arjun Rao', 'Cardiology', '9123456789'),
(2, 'Dr. Meera Shah', 'Dermatology', '9234567890');

INSERT INTO Appointments VALUES
(1, 1, 1, '2025-06-20', 'High BP'),
(2, 2, 2, '2025-06-25', 'Skin Allergy');

INSERT INTO Medications VALUES
(1, 'Atenolol', 'Used for high blood pressure'),
(2, 'Cetirizine', 'Used for allergies');

INSERT INTO Prescriptions VALUES
(1, 1, 1, '50mg daily'),
(2, 2, 2, '10mg daily');



-- 	Querises

-- 1 
-- List of Patients 
select * from Patients;

-- 2 
-- List all doctors with their specialization
SELECT name, specialization FROM Doctors;

-- 3 
--  Show all appointments with patient and doctor names
SELECT a.appointment_id, p.name AS patient_name, d.name AS doctor_name, a.appointment_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- 4 
-- Count total patients 
SELECT COUNT(*) AS total_patients FROM Patients;

-- 5 
-- Patients over 30 years old
SELECT * FROM Patients WHERE age > 30;

-- 6 
-- Find most common doctor specialty
SELECT specialization, COUNT(*) AS count
FROM Doctors
GROUP BY specialization
ORDER BY count DESC
LIMIT 1;


-- 7 
--  Show names of all male patients
SELECT name FROM Patients WHERE gender = 'Male';

-- 8 
-- Show total appointments for each doctor
SELECT d.name, a.doctor_id, COUNT(*) AS total_appointments
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY a.doctor_id, d.name;

-- 9 
-- Find the oldest patient 
SELECT * FROM Patients ORDER BY age DESC LIMIT 1; 

-- 10 
--  Find the youngest patient 
SELECT * FROM Patients ORDER BY age ASC LIMIT 1;

-- 11 
-- Find doctors who have prescribed all medications available 
SELECT d.name
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(DISTINCT pr.medication_id) = (
    SELECT COUNT(*) FROM Medications
); 

-- 12 
--  Find patients whose diagnosis contains the word “Allergy” (string search) 
SELECT 
    p.name,
    a.diagnosis
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.diagnosis LIKE '%Allergy%'; 

-- 13 
-- Count appointments per month (time series analysis) 
SELECT 
    DATE_FORMAT(appointment_date, '%Y-%m') AS month,
    COUNT(*) AS total_appointments
FROM Appointments
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY month;

-- 14 
-- Find patients who have taken a specific medication (Cetirizine) 
SELECT DISTINCT p.name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
JOIN Medications m ON pr.medication_id = m.medication_id
WHERE m.name = 'Cetirizine'; 

-- 15 
-- Show doctor with maximum appointments using a subquery
SELECT name
FROM Doctors
WHERE doctor_id = (
    SELECT doctor_id
    FROM Appointments
    GROUP BY doctor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 16 
--Show patient name and number of days since last appointment 
SELECT 
    p.name,
    DATEDIFF(CURDATE(),
        (SELECT MAX(appointment_date) 
         FROM Appointments 
         WHERE patient_id = p.patient_id)
    ) AS days_since_last_visit
FROM Patients p;

-- 17
-- Conditional aggregation - Count male vs female patients 
SELECT 
    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_patients,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_patients
FROM Patients;

-- 18 
-- Window function – Running total of appointments by date 
SELECT 
    appointment_date,
    COUNT(*) AS daily_count,
    SUM(COUNT(*)) OVER (ORDER BY appointment_date) AS running_total
FROM Appointments
GROUP BY appointment_date;

-- 19 
-- Correlated subquery – Patients who have more appointments than the average number 
SELECT 
    p.name,
    (SELECT COUNT(*) FROM Appointments a WHERE a.patient_id = p.patient_id) AS appointment_count
FROM Patients p
WHERE 
    (SELECT COUNT(*) FROM Appointments a WHERE a.patient_id = p.patient_id) >
    (SELECT AVG(cnt) 
     FROM (
        SELECT COUNT(*) AS cnt
        FROM Appointments
        GROUP BY patient_id
     ) x);

-- 20 
-- Find doctors who have never treated a patient above 30 years 
SELECT d.name
FROM Doctors d
WHERE d.doctor_id NOT IN (
    SELECT DISTINCT a.doctor_id
    FROM Appointments a
    JOIN Patients p ON a.patient_id = p.patient_id
    WHERE p.age > 30
);















