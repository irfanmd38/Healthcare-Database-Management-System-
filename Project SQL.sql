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















