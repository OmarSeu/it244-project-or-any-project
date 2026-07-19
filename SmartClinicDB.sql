```sql
-- ==========================================
-- Smart Clinic Database System
-- Complete SQL Implementation
-- ==========================================

-- ==========================================
-- Create Database
-- ==========================================

DROP DATABASE IF EXISTS SmartClinicDB;

CREATE DATABASE SmartClinicDB;

USE SmartClinicDB;

-- ==========================================
-- Create Tables
-- ==========================================

CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender ENUM('Male','Female') NOT NULL,
    DOB DATE NOT NULL,
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(200),
    BloodGroup VARCHAR(5)
);

CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(100),
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(10,2) NOT NULL
);

CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Status VARCHAR(20),
    Notes TEXT,

    FOREIGN KEY (PatientID)
        REFERENCES Patients(PatientID),

    FOREIGN KEY (DoctorID)
        REFERENCES Doctors(DoctorID)
);

CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT UNIQUE,
    Diagnosis VARCHAR(200),
    ProcedureName VARCHAR(100),
    Cost DECIMAL(10,2),

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointments(AppointmentID)
);

CREATE TABLE Medicines (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineName VARCHAR(100) NOT NULL,
    Manufacturer VARCHAR(100),
    Price DECIMAL(8,2)
);

CREATE TABLE Prescriptions (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    TreatmentID INT NOT NULL,
    MedicineID INT NOT NULL,
    Dosage VARCHAR(50),
    Duration VARCHAR(50),

    FOREIGN KEY (TreatmentID)
        REFERENCES Treatments(TreatmentID),

    FOREIGN KEY (MedicineID)
        REFERENCES Medicines(MedicineID)
);

CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT UNIQUE,
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(30),
    PaymentStatus VARCHAR(20),

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointments(AppointmentID)
);

-- ==========================================
-- Insert Sample Data
-- ==========================================

INSERT INTO Patients
(FirstName,LastName,Gender,DOB,Phone,Email,Address,BloodGroup)
VALUES
('Ahmed','Ali','Male','1995-03-12','01011111111','ahmed@gmail.com','Cairo','A+'),
('Sara','Mohamed','Female','1998-08-21','01022222222','sara@gmail.com','Giza','B+'),
('Omar','Hassan','Male','1990-02-11','01033333333','omar@gmail.com','Alexandria','O+'),
('Mona','Ibrahim','Female','1996-07-15','01044444444','mona@gmail.com','Zagazig','AB+'),
('Youssef','Mahmoud','Male','2001-01-30','01055555555','youssef@gmail.com','Mansoura','A-');

INSERT INTO Doctors
(FirstName,LastName,Specialty,Phone,Email,Salary)
VALUES
('Khaled','Adel','Cardiology','01111111111','khaled@clinic.com',25000),
('Nour','Samy','Dentistry','01122222222','nour@clinic.com',22000),
('Mahmoud','Salem','Dermatology','01133333333','mahmoud@clinic.com',23000),
('Heba','Ali','Pediatrics','01144444444','heba@clinic.com',21000),
('Tamer','Ahmed','Orthopedics','01155555555','tamer@clinic.com',26000);

INSERT INTO Appointments
(PatientID,DoctorID,AppointmentDate,Status,Notes)
VALUES
(1,1,'2026-07-20 10:00:00','Completed','Routine checkup'),
(2,2,'2026-07-20 11:00:00','Completed','Tooth pain'),
(3,3,'2026-07-21 09:30:00','Completed','Skin allergy'),
(4,4,'2026-07-21 12:00:00','Pending','Child fever'),
(5,5,'2026-07-22 14:00:00','Completed','Knee injury');

INSERT INTO Treatments
(AppointmentID,Diagnosis,ProcedureName,Cost)
VALUES
(1,'Hypertension','Blood Pressure Monitoring',500),
(2,'Dental Cavity','Tooth Filling',800),
(3,'Skin Infection','Medication',450),
(4,'Viral Fever','Medical Consultation',300),
(5,'Ligament Injury','Physical Therapy',1200);

INSERT INTO Medicines
(MedicineName,Manufacturer,Price)
VALUES
('Panadol','GSK',35),
('Augmentin','GSK',120),
('Brufen','Abbott',60),
('Voltaren','Novartis',75),
('Cetirizine','Pfizer',40);

INSERT INTO Prescriptions
(TreatmentID,MedicineID,Dosage,Duration)
VALUES
(1,1,'2 Tablets Daily','5 Days'),
(2,2,'1 Tablet Daily','7 Days'),
(3,5,'1 Tablet Daily','10 Days'),
(4,1,'3 Tablets Daily','3 Days'),
(5,4,'2 Tablets Daily','14 Days');

INSERT INTO Payments
(AppointmentID,Amount,PaymentDate,PaymentMethod,PaymentStatus)
VALUES
(1,500,'2026-07-20','Cash','Paid'),
(2,800,'2026-07-20','Card','Paid'),
(3,450,'2026-07-21','Cash','Paid'),
(4,300,'2026-07-21','Cash','Pending'),
(5,1200,'2026-07-22','Card','Paid');

-- ==========================================
-- SELECT Statements
-- ==========================================

SELECT * FROM Patients;
SELECT * FROM Doctors;
SELECT * FROM Appointments;
SELECT * FROM Treatments;
SELECT * FROM Medicines;
SELECT * FROM Prescriptions;
SELECT * FROM Payments;

-- ==========================================
-- JOIN Query
-- ==========================================

SELECT
A.AppointmentID,
P.FirstName AS Patient,
D.FirstName AS Doctor,
A.AppointmentDate,
A.Status
FROM Appointments A
JOIN Patients P
ON A.PatientID=P.PatientID
JOIN Doctors D
ON A.DoctorID=D.DoctorID;

-- ==========================================
-- Nested Query
-- ==========================================

SELECT FirstName, LastName
FROM Patients
WHERE PatientID IN
(
SELECT PatientID
FROM Appointments
WHERE Status='Completed'
);

-- ==========================================
-- Aggregate Function
-- ==========================================

SELECT
DoctorID,
COUNT(*) AS TotalAppointments
FROM Appointments
GROUP BY DoctorID;

-- ==========================================
-- UPDATE Statement
-- ==========================================

UPDATE Appointments
SET Status='Completed'
WHERE AppointmentID=4;

SELECT * FROM Appointments
WHERE AppointmentID=4;

-- ==========================================
-- DELETE Statement
-- ==========================================

DELETE FROM Payments
WHERE PaymentID=5;

SELECT * FROM Payments;

-- ==========================================
-- VIEW
-- ==========================================

CREATE VIEW AppointmentDetails AS

SELECT
A.AppointmentID,
P.FirstName AS Patient,
D.FirstName AS Doctor,
A.AppointmentDate,
A.Status

FROM Appointments A
JOIN Patients P
ON A.PatientID=P.PatientID
JOIN Doctors D
ON A.DoctorID=D.DoctorID;

SELECT * FROM AppointmentDetails;

-- ==========================================
-- TRIGGER
-- ==========================================

DELIMITER $$

CREATE TRIGGER trg_payment_status

BEFORE INSERT ON Payments

FOR EACH ROW

BEGIN

IF NEW.Amount > 0 THEN
SET NEW.PaymentStatus='Paid';
END IF;

END$$

DELIMITER ;

-- ==========================================
-- Trigger Test
-- ==========================================

INSERT INTO Payments
(AppointmentID,Amount,PaymentDate,PaymentMethod)

VALUES
(5,1200,'2026-07-22','Cash');

SELECT *
FROM Payments
WHERE AppointmentID=5;

-- ==========================================
-- End of Script
-- ==========================================
```
