--create all necessary tables
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS  doctor CASCADE;
DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS medical_record CASCADE;
DROP TABLE IF EXISTS prescription CASCADE;
DROP TABLE IF EXISTS billing CASCADE;
DROP TABLE IF EXISTS insurance CASCADE;
DROP TABLE IF EXISTS lab_test CASCADE;

CREATE TABLE patient(
	patientID SERIAL PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR (20),
	dob DATE NOT NULL,
	gender VARCHAR (20),
	address VARCHAR (50) NOT NULL,
	phone CHAR(10) NOT NULL,
	email varchar(50),
	CONSTRAINT gender_check CHECK(gender IN ('Male','Female','Non-Binary'))); 

CREATE TABLE doctor(
	doctorID SERIAL PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	specialty VARCHAR(50) NOT NULL,
	phone_number CHAR(10));

CREATE TABLE appointment(
	appointmentID SERIAL PRIMARY KEY,
	patientID INT, --fk
	doctorID INT, --fk
	appointment_date DATE,
	appointment_time TIME,
	status VARCHAR(20)
	CONSTRAINT appointmentStatus_check CHECK(status IN ('Scheduled','Completed','Cancelled')));

CREATE TABLE medical_record(
	recordID SERIAL PRIMARY KEY,
	patientID INT, --fk
	doctorID INT, --fk
	visit_date DATE NOT NULL,
	diagnosis TEXT NOT NULL);

CREATE TABLE prescription(
	prescriptionID SERIAL PRIMARY KEY,
	medication_name VARCHAR(20) NOT NULL,
	patientID INT, --fk
	dosage VARCHAR(50) NOT NULL);

CREATE TABLE billing (
	billingID SERIAL PRIMARY KEY,
	patientID INT, --fk
	appointmentID INT, --fk
	billing_date DATE NOT NULL,
	amount DECIMAL(10,2) NOT NULL,
	status VARCHAR(20) NOT NULL,
	CONSTRAINT billStatus_check CHECK(status IN ('Paid','Pending','Unpaid')));

CREATE TABLE insurance(
	insuranceID SERIAL PRIMARY KEY,
	insurance_name VARCHAR(20) NOT NULL,
	patientID INT, --fk
	policy_number VARCHAR(20) NOT NULL,
	expiration_date DATE NOT NULL);

CREATE TABLE lab_test(
	testID SERIAL PRIMARY KEY,
	patientID INT, --fk
	doctorID INT, --fk
	test_name VARCHAR(20) NOT NULL,
	order_date DATE NOT NULL,
	test_result TEXT NOT NULL);

-- Add foreign keys
ALTER TABLE appointment ADD CONSTRAINT appointment_patient_FK FOREIGN KEY (patientID) REFERENCES patient(patientID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE appointment ADD CONSTRAINT appointment_doctor_FK FOREIGN KEY (doctorID) REFERENCES doctor(doctorID)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE medical_record ADD CONSTRAINT medRecord_patient_FK FOREIGN KEY (patientID) REFERENCES patient(patientID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE medical_record ADD CONSTRAINT medRecord_doctor_FK FOREIGN KEY (doctorID) REFERENCES doctor(doctorID)
	ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE prescription ADD CONSTRAINT prescription_patient_FK FOREIGN KEY (patientID) REFERENCES patient(patientID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE billing ADD CONSTRAINT billing_patient_FK FOREIGN KEY (patientID) REFERENCES patient(patientID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE billing ADD CONSTRAINT billing_appointment_FK FOREIGN KEY (appointmentID) REFERENCES appointment(appointmentID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE insurance ADD CONSTRAINT insurance_patient_FK FOREIGN KEY (patientID) REFERENCES patient(patientID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE lab_test ADD CONSTRAINT labTest_patient_FK FOREIGN KEY (patientID) REFERENCES patient(patientID)
	ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE lab_test ADD CONSTRAINT labTest_doctor_FK FOREIGN KEY (doctorID) REFERENCES doctor(doctorID)
	ON DELETE RESTRICT ON UPDATE CASCADE;

--Add indices
CREATE INDEX idx_gender ON patient(gender);
CREATE INDEX idx_specialty ON doctor(specialty);
CREATE INDEX idx_appt_status ON appointment(status);
CREATE INDEX idx_appt_patientID ON appointment(patientID);
CREATE INDEX idx_medRecord_patientID ON medical_record(patientID);
CREATE INDEX idx_billing_patientID ON billing(patientID);
CREATE INDEX idx_ins_patientID ON insurance(patientID);
CREATE INDEX idx_lab_patientID ON lab_test(patientID);

--Insert dummy data
-- Insert 50 dummy data into the patient table
INSERT INTO patient (first_name, last_name, dob, gender, address, phone, email)
VALUES
('John', 'Doe', '1985-07-15', 'Male', '123 Elm St, Springfield, IL', '5551234567', 'john.doe01@gmail.com'),
('Jane', 'Smith', '1990-03-22', 'Female', '456 Oak St, Springfield, IL', '5552345678', 'jane.smith91@yahoo.com'),
('Alex', 'Johnson', '1995-11-30', 'Non-Binary', '789 Pine St, Springfield, IL', '5553456789', 'alex.johnson123@outlook.com'),
('Michael', 'Brown', '1982-01-10', 'Male', '101 Maple St, Springfield, IL', '5554567890', 'mike.brown82@hotmail.com'),
('Emily', 'Davis', '1993-04-05', 'Female', '202 Birch St, Springfield, IL', '5555678901', 'emily.davis94@icloud.com'),
('Chris', 'Wilson', '1987-08-14', 'Male', '303 Cedar St, Springfield, IL', '5556789012', 'chris.wilson87@aol.com'),
('Taylor', 'Moore', '1991-12-25', 'Non-Binary', '404 Walnut St, Springfield, IL', '5557890123', 'taylor.moore2020@protonmail.com'),
('Jessica', 'Taylor', '1989-09-18', 'Female', '505 Ash St, Springfield, IL', '5558901234', 'jessica.taylor89@gmail.com'),
('David', 'Anderson', '1984-05-02', 'Male', '606 Pine St, Springfield, IL', '5559012345', 'david.anderson@yahoo.com'),
('Sarah', 'Thomas', '1992-07-27', 'Female', '707 Oak St, Springfield, IL', '5550123456', 'sarah.thomas92@outlook.com'),
('Jordan', 'Jackson', '1986-02-18', 'Non-Binary', '808 Maple St, Springfield, IL', '5551234567', 'jordan.jackson@zoho.com'),
('Ryan', 'White', '1990-10-04', 'Male', '909 Birch St, Springfield, IL', '5552345678', 'ryan.white2020@icloud.com'),
('Olivia', 'Harris', '1994-06-20', 'Female', '1010 Cedar St, Springfield, IL', '5553456789', 'olivia.harris@me.com'),
('Ethan', 'Martin', '1988-03-11', 'Male', '1111 Walnut St, Springfield, IL', '5554567890', 'ethan.martin88@aol.com'),
('Sophia', 'Garcia', '1996-04-30', 'Female', '1212 Ash St, Springfield, IL', '5555678901', 'sophia.garcia96@gmail.com'),
('Mason', 'Roberts', '1983-01-01', 'Male', '1313 Pine St, Springfield, IL', '5556789012', 'mason.roberts1983@hotmail.com'),
('Charlotte', 'Williams', '1997-12-15', 'Female', '1414 Oak St, Springfield, IL', '5557890123', 'charlotte.williams@outlook.com'),
('Jack', 'Clark', '1990-02-22', 'Male', '1515 Birch St, Springfield, IL', '5558901234', 'jack.clark@aol.com'),
('Lily', 'Adams', '1989-08-18', 'Female', '1616 Cedar St, Springfield, IL', '5559012345', 'lily.adams@zoho.com'),
('Jacob', 'Baker', '1993-10-14', 'Male', '1717 Walnut St, Springfield, IL', '5550123456', 'jacob.baker93@gmail.com'),
('Megan', 'Nelson', '1995-12-08', 'Female', '1818 Ash St, Springfield, IL', '5551234567', 'megan.nelson@outlook.com'),
('Zoe', 'King', '1992-01-25', 'Non-Binary', '1919 Pine St, Springfield, IL', '5552345678', 'zoe.king@protonmail.com'),
('Aiden', 'Scott', '1986-09-19', 'Male', '2020 Oak St, Springfield, IL', '5553456789', 'aiden.scott1986@yahoo.com'),
('Madison', 'Young', '1994-07-02', 'Female', '2121 Maple St, Springfield, IL', '5554567890', 'madison.young94@gmail.com'),
('Lucas', 'Walker', '1991-03-05', 'Male', '2222 Birch St, Springfield, IL', '5555678901', 'lucas.walker91@zoho.com'),
('Chloe', 'Allen', '1996-11-09', 'Female', '2323 Cedar St, Springfield, IL', '5556789012', 'chloe.allen@aol.com'),
('Oliver', 'Martinez', '1992-05-19', 'Male', '2424 Walnut St, Springfield, IL', '5557890123', 'oliver.martinez92@hotmail.com'),
('Ella', 'Rodriguez', '1995-04-02', 'Female', '2525 Ash St, Springfield, IL', '5558901234', 'ella.rodriguez95@gmail.com'),
('James', 'Lopez', '1987-06-10', 'Male', '2626 Pine St, Springfield, IL', '5559012345', 'james.lopez87@outlook.com'),
('Grace', 'Gonzalez', '1990-08-20', 'Female', '2727 Oak St, Springfield, IL', '5550123456', 'grace.gonzalez@icloud.com'),
('Benjamin', 'Perez', '1984-04-15', 'Male', '2828 Maple St, Springfield, IL', '5551234567', 'benjamin.perez84@me.com'),
('Avery', 'Davis', '1992-09-03', 'Non-Binary', '2929 Birch St, Springfield, IL', '5552345678', 'avery.davis@zoho.com'),
('William', 'Hernandez', '1989-07-28', 'Male', '3030 Cedar St, Springfield, IL', '5553456789', 'william.hernandez89@gmail.com'),
('Samantha', 'Morris', '1994-05-16', 'Female', '3131 Walnut St, Springfield, IL', '5554567890', 'samantha.morris94@aol.com'),
('Joshua', 'Rodgers', '1991-11-01', 'Male', '3232 Ash St, Springfield, IL', '5555678901', 'joshua.rodgers91@outlook.com'),
('Abigail', 'Mitchell', '1997-02-18', 'Female', '3333 Pine St, Springfield, IL', '5556789012', 'abigail.mitchell97@icloud.com'),
('Samuel', 'Carter', '1987-10-11', 'Male', '3434 Oak St, Springfield, IL', '5557890123', 'samuel.carter87@hotmail.com'),
('Sophie', 'Parker', '1992-06-24', 'Female', '3535 Cedar St, Springfield, IL', '5558901234', 'sophie.parker92@gmail.com'),
('Isaac', 'Evans', '1995-03-29', 'Male', '3636 Birch St, Springfield, IL', '5559012345', 'isaac.evans95@aol.com'),
('Madeline', 'Murphy', '1996-10-10', 'Female', '3737 Walnut St, Springfield, IL', '5550123456', 'madeline.murphy96@gmail.com'),
('Leo', 'Morgan', '1989-12-07', 'Male', '3838 Ash St, Springfield, IL', '5551234567', 'leo.morgan89@zoho.com'),
('Amelia', 'James', '1991-05-23', 'Female', '3939 Pine St, Springfield, IL', '5552345678', 'amelia.james91@outlook.com'),
('Matthew', 'Taylor', '1993-08-30', 'Male', '4040 Oak St, Springfield, IL', '5553456789', 'matthew.taylor93@gmail.com'),
('Victoria', 'Clark', '1997-01-17', 'Female', '4141 Cedar St, Springfield, IL', '5554567890', 'victoria.clark97@me.com'),
('Wyatt', 'Lopez', '1990-02-27', 'Male', '4242 Birch St, Springfield, IL', '5555678901', 'wyatt.lopez90@outlook.com'),
('Ruby', 'Martinez', '1988-11-12', 'Female', '4343 Walnut St, Springfield, IL', '5556789012', 'ruby.martinez88@gmail.com'),
('Henry', 'Wilson', '1987-03-08', 'Male', '4444 Ash St, Springfield, IL', '5557890123', 'henry.wilson87@zoho.com'),
('Liam', 'Taylor', '1996-08-14', 'Male', '4545 Pine St, Springfield, IL', '5558901234', 'liam.taylor96@protonmail.com'),
('Dylan', 'Evans', '1995-10-05', 'Male', '4646 Oak St, Springfield, IL', '5559012345', 'dylan.evans95@icloud.com'),
('Natalie', 'Garcia', '1992-04-17', 'Female', '4747 Cedar St, Springfield, IL', '5550123456', 'natalie.garcia92@outlook.com');

--Insert 10 dummy doctor data
INSERT INTO doctor (first_name, last_name, specialty, phone_number)
VALUES
('John', 'Smith', 'Cardiologist', '5551234567'),
('Emily', 'Johnson', 'Neurologist', '5552345678'),
('Michael', 'Brown', 'Pediatrician', '5553456789'),
('Olivia', 'Williams', 'Orthopedic Surgeon', '5554567890'),
('David', 'Davis', 'General Practitioner', '5555678901'),
('Sophia', 'Miller', 'Dermatologist', '5556789012'),
('James', 'Wilson', 'Ophthalmologist', '5557890123'),
('Lily', 'Moore', 'Gynecologist', '5558901234'),
('Daniel', 'Taylor', 'Endocrinologist', '5559012345'),
('Ava', 'Anderson', 'Primary Care Doctor', '5550123456'),
('Lucas', 'White', 'Primary Care Doctor', '5552345670');

INSERT INTO appointment (patientID, doctorID, appointment_date, appointment_time, status)
VALUES
(1, 2, '2024-12-10', '09:00:00', 'Scheduled'),
(2, 3, '2024-12-11', '10:30:00', 'Completed'),
(3, 4, '2024-12-12', '14:00:00', 'Cancelled'),
(4, 5, '2024-12-13', '08:45:00', 'Scheduled'),
(5, 6, '2024-12-14', '11:15:00', 'Completed'),
(6, 7, '2024-12-15', '13:30:00', 'Scheduled'),
(7, 8, '2024-12-16', '15:00:00', 'Completed'),
(8, 9, '2024-12-17', '16:45:00', 'Cancelled'),
(9, 10, '2024-12-18', '07:30:00', 'Scheduled'),
(10, 1, '2024-12-19', '12:00:00', 'Completed'),
(1, 3, '2024-12-20', '09:30:00', 'Scheduled'),
(2, 4, '2024-12-21', '10:00:00', 'Cancelled'),
(3, 5, '2024-12-22', '11:00:00', 'Completed'),
(4, 6, '2024-12-23', '14:30:00', 'Scheduled'),
(5, 7, '2024-12-24', '08:15:00', 'Completed'),
(6, 8, '2024-12-25', '13:00:00', 'Scheduled'),
(7, 9, '2024-12-26', '15:15:00', 'Cancelled'),
(8, 10, '2024-12-27', '16:00:00', 'Scheduled'),
(9, 1, '2024-12-28', '07:45:00', 'Completed'),
(10, 2, '2024-12-29', '12:15:00', 'Scheduled'),
(1, 4, '2024-12-30', '09:15:00', 'Cancelled'),
(2, 5, '2024-12-31', '10:45:00', 'Completed'),
(3, 6, '2025-01-01', '11:30:00', 'Scheduled'),
(4, 7, '2025-01-02', '14:00:00', 'Completed'),
(5, 8, '2025-01-03', '08:00:00', 'Cancelled'),
(6, 9, '2025-01-04', '13:45:00', 'Scheduled'),
(7, 10, '2025-01-05', '15:30:00', 'Completed'),
(8, 1, '2025-01-06', '16:30:00', 'Cancelled'),
(9, 2, '2025-01-07', '07:00:00', 'Scheduled'),
(10, 3, '2025-01-08', '12:30:00', 'Completed'),
(1, 5, '2025-01-09', '09:00:00', 'Scheduled'),
(2, 6, '2025-01-10', '10:30:00', 'Completed'),
(3, 7, '2025-01-11', '14:00:00', 'Cancelled'),
(4, 8, '2025-01-12', '08:45:00', 'Scheduled'),
(5, 9, '2025-01-13', '11:15:00', 'Completed'),
(6, 10, '2025-01-14', '13:30:00', 'Scheduled'),
(7, 1, '2025-01-15', '15:00:00', 'Completed'),
(8, 2, '2025-01-16', '16:45:00', 'Cancelled'),
(9, 3, '2025-01-17', '07:30:00', 'Scheduled'),
(10, 4, '2025-01-18', '12:00:00', 'Completed'),
(1, 6, '2025-01-19', '09:30:00', 'Scheduled'),
(2, 7, '2025-01-20', '10:00:00', 'Cancelled'),
(3, 8, '2025-01-21', '11:00:00', 'Completed'),
(4, 9, '2025-01-22', '14:30:00', 'Scheduled'),
(5, 10, '2025-01-23', '08:15:00', 'Completed');

INSERT INTO medical_record (patientID, doctorID, visit_date, diagnosis)
VALUES
(1, 2, '2024-12-10', 'Hypertension'),
(2, 3, '2024-12-11', 'Type 2 Diabetes'),
(3, 4, '2024-12-12', 'Asthma'),
(4, 5, '2024-12-13', 'Upper Respiratory Infection'),
(5, 6, '2024-12-14', 'Back Pain'),
(6, 7, '2024-12-15', 'Anxiety Disorder'),
(7, 8, '2024-12-16', 'Seasonal Allergies'),
(8, 9, '2024-12-17', 'Migraine'),
(9, 10, '2024-12-18', 'Gastroesophageal Reflux Disease (GERD)'),
(10, 1, '2024-12-19', 'Chronic Fatigue Syndrome'),
(1, 3, '2024-12-20', 'Obesity'),
(2, 4, '2024-12-21', 'Osteoarthritis'),
(3, 5, '2024-12-22', 'Depression'),
(4, 6, '2024-12-23', 'Hyperthyroidism'),
(5, 7, '2024-12-24', 'Pneumonia'),
(6, 8, '2024-12-25', 'Sinusitis'),
(7, 9, '2024-12-26', 'Chronic Bronchitis'),
(8, 10, '2024-12-27', 'Diabetic Neuropathy'),
(9, 1, '2024-12-28', 'Rheumatoid Arthritis'),
(10, 2, '2024-12-29', 'Sleep Apnea'),
(1, 4, '2024-12-30', 'Peptic Ulcer Disease'),
(2, 5, '2024-12-31', 'Heart Disease'),
(3, 6, '2025-01-01', 'Allergic Rhinitis'),
(4, 7, '2025-01-02', 'Chronic Sinusitis'),
(5, 8, '2025-01-03', 'Gout'),
(6, 9, '2025-01-04', 'Psoriasis'),
(7, 10, '2025-01-05', 'Anemia'),
(8, 1, '2025-01-06', 'Epilepsy'),
(9, 2, '2025-01-07', 'Celiac Disease'),
(10, 3, '2025-01-08', 'Irritable Bowel Syndrome (IBS)'),
(1, 5, '2025-01-09', 'Chronic Kidney Disease'),
(2, 6, '2025-01-10', 'Bipolar Disorder'),
(3, 7, '2025-01-11', 'Bronchial Asthma'),
(4, 8, '2025-01-12', 'Skin Infection'),
(5, 9, '2025-01-13', 'High Cholesterol'),
(6, 10, '2025-01-14', 'Cirrhosis'),
(7, 1, '2025-01-15', 'Ovarian Cysts'),
(8, 2, '2025-01-16', 'Hypothyroidism'),
(9, 3, '2025-01-17', 'Hypertensive Heart Disease'),
(10, 4, '2025-01-18', 'Liver Disease'),
(1, 6, '2025-01-19', 'Glaucoma'),
(2, 7, '2025-01-20', 'Thyroid Disease'),
(3, 8, '2025-01-21', 'Chronic Fatigue Syndrome'),
(4, 9, '2025-01-22', 'Lung Cancer'),
(5, 10, '2025-01-23', 'Tuberculosis'),
(6, 1, '2025-01-24', 'Multiple Sclerosis'),
(7, 2, '2025-01-25', 'Cognitive Impairment'),
(8, 3, '2025-01-26', 'Obstructive Sleep Apnea'),
(9, 4, '2025-01-27', 'Post-Traumatic Stress Disorder (PTSD)'),
(10, 5, '2025-01-28', 'Cardiovascular Disease');

INSERT INTO prescription (medication_name, patientID, dosage)
VALUES
('Lisinopril', 1, '10 mg, once daily'),
('Metformin', 2, '500 mg, twice daily with meals'),
('Albuterol', 3, '90 mcg, inhale 2 puffs as needed'),
('Amoxicillin', 4, '500 mg, every 8 hours for 7 days'),
('Ibuprofen', 5, '200 mg, every 4-6 hours as needed'),
('Sertraline', 6, '50 mg, once daily'),
('Loratadine', 7, '10 mg, once daily'),
('Sumatriptan', 8, '50 mg, 1 tablet at migraine onset'),
('Omeprazole', 9, '20 mg, once daily before breakfast'),
('Fluoxetine', 10, '20 mg, once daily in morning'),
('Amlodipine', 1, '5 mg, once daily'),
('Simvastatin', 2, '40 mg, once daily at night'),
('Prednisone', 3, '10 mg, once daily for 5 days'),
('Azithromycin', 4, '250 mg, once daily for 3 days'),
('Tylenol', 5, '500 mg, every 4-6 hours as needed'),
('Diazepam', 6, '5 mg, as needed for anxiety'),
('Diphenhydramine', 7, '25 mg, every 4-6 hours as needed'),
('Topiramate', 8, '25 mg, once daily'),
('Pantoprazole', 9, '40 mg, once daily before breakfast'),
('Citalopram', 10, '10 mg, once daily'),
('Atorvastatin', 1, '20 mg, once daily'),
('Insulin', 2, 'Humalog 10 units, before meals'),
('Mometasone', 3, '50 mcg, 1 spray in each nostril daily'),
('Naproxen', 4, '500 mg, twice daily with food'),
('Meloxicam', 5, '7.5 mg, once daily with food'),
('Hydroxychloroquine', 6, '200 mg, twice daily'),
('Cetirizine', 7, '10 mg, once daily'),
('Verapamil', 8, '80 mg, once daily'),
('Esomeprazole', 9, '20 mg, once daily before breakfast'),
('Trazodone', 10, '50 mg, at bedtime'),
('Furosemide', 1, '20 mg, once daily in morning'),
('Hydrochlorothiazide', 2, '25 mg, once daily in morning'),
('Guaifenesin', 3, '200 mg, every 4 hours as needed'),
('Ciprofloxacin', 4, '500 mg, twice daily for 7 days'),
('Oxycodone', 5, '5 mg, every 4-6 hours as needed'),
('Gabapentin', 6, '300 mg, three times daily'),
('Doxycycline', 7, '100 mg, twice daily for 7 days'),
('Tramadol', 8, '50 mg, every 4-6 hours as needed'),
('Captopril', 9, '25 mg, twice daily'),
('Bupropion', 10, '150 mg, once daily in morning'),
('Enalapril', 1, '5 mg, once daily'),
('Pantoprazole', 2, '40 mg, once daily before breakfast'),
('Carvedilol', 3, '12.5 mg, twice daily with food'),
('Clonazepam', 4, '1 mg, at bedtime for anxiety'),
('Varenicline', 5, '0.5 mg, once daily for 3 days, then twice daily'),
('Ranitidine', 6, '150 mg, twice daily before meals'),
('Methylprednisolone', 7, '4 mg, once daily for 6 days'),
('Amoxicillin', 8, '500 mg, every 8 hours for 7 days'),
('Lorazepam', 9, '1 mg, at bedtime for anxiety'),
('Sildenafil', 10, '25 mg, 1 hour before sexual activity'),
('Lisinopril', 1, '10 mg, once daily'),
('Metformin', 2, '500 mg, twice daily with meals'),
('Albuterol', 3, '90 mcg, inhale 2 puffs as needed');

INSERT INTO billing (patientID, appointmentID, billing_date, amount, status)
VALUES
(1, 1, '2024-12-01', 150.00, 'Paid'),
(2, 2, '2024-12-02', 200.00, 'Pending'),
(3, 3, '2024-12-03', 120.50, 'Unpaid'),
(4, 4, '2024-12-04', 300.00, 'Paid'),
(5, 5, '2024-12-05', 175.00, 'Paid'),
(6, 6, '2024-12-06', 250.00, 'Unpaid'),
(7, 7, '2024-12-07', 140.75, 'Pending'),
(8, 8, '2024-12-08', 180.00, 'Paid'),
(9, 9, '2024-12-09', 220.00, 'Pending'),
(10, 10, '2024-12-10', 160.25, 'Paid'),
(11, 11, '2024-12-11', 185.00, 'Unpaid'),
(12, 12, '2024-12-12', 190.00, 'Paid'),
(13, 13, '2024-12-13', 210.00, 'Pending'),
(14, 14, '2024-12-14', 160.50, 'Paid'),
(15, 15, '2024-12-15', 225.00, 'Unpaid'),
(16, 16, '2024-12-16', 250.00, 'Pending'),
(17, 17, '2024-12-17', 280.00, 'Paid'),
(18, 18, '2024-12-18', 145.00, 'Paid'),
(19, 19, '2024-12-19', 210.00, 'Unpaid'),
(20, 20, '2024-12-20', 300.00, 'Pending'),
(21, 21, '2024-12-21', 275.00, 'Paid'),
(22, 22, '2024-12-22', 225.00, 'Pending'),
(23, 23, '2024-12-23', 160.00, 'Unpaid'),
(24, 24, '2024-12-24', 240.00, 'Paid'),
(25, 25, '2024-12-25', 180.00, 'Pending'),
(26, 26, '2024-12-26', 190.00, 'Paid'),
(27, 27, '2024-12-27', 250.00, 'Unpaid'),
(28, 28, '2024-12-28', 175.00, 'Paid'),
(29, 29, '2024-12-29', 220.00, 'Pending'),
(30, 30, '2024-12-30', 210.00, 'Paid'),
(31, 31, '2024-12-31', 200.00, 'Unpaid'),
(32, 32, '2025-01-01', 190.00, 'Paid'),
(33, 33, '2025-01-02', 180.00, 'Pending'),
(34, 34, '2025-01-03', 230.00, 'Unpaid'),
(35, 35, '2025-01-04', 250.00, 'Paid'),
(36, 36, '2025-01-05', 220.00, 'Pending'),
(37, 37, '2025-01-06', 270.00, 'Paid'),
(38, 38, '2025-01-07', 240.00, 'Pending'),
(39, 39, '2025-01-08', 200.00, 'Unpaid'),
(40, 40, '2025-01-09', 160.00, 'Paid'),
(41, 41, '2025-01-10', 150.00, 'Unpaid'),
(42, 42, '2025-01-11', 180.00, 'Paid'),
(43, 43, '2025-01-12', 190.00, 'Pending'),
(44, 44, '2025-01-13', 250.00, 'Unpaid'),
(45, 45, '2025-01-14', 220.00, 'Paid');

INSERT INTO insurance (insuranace_name, patientID, policy_number, expiration_date)
VALUES
('HealthGuard', 1, 'HG123456', '2025-12-31'),
('MedicarePlus', 2, 'MP234567', '2026-06-30'),
('WellCare', 3, 'WC345678', '2025-11-30'),
('LifeSecure', 4, 'LS456789', '2027-02-28'),
('PrimeHealth', 5, 'PH567890', '2024-10-31'),
('BlueShield', 6, 'BS678901', '2026-05-15'),
('AetnaCare', 7, 'AC789012', '2025-09-30'),
('CignaPlus', 8, 'CP890123', '2026-08-31'),
('UnitedCare', 9, 'UC901234', '2024-12-31'),
('HealthNet', 10, 'HN012345', '2025-01-31'),
('WellPath', 11, 'WP123456', '2027-03-31'),
('CareFirst', 12, 'CF234567', '2025-07-15'),
('ChoiceHealth', 13, 'CH345678', '2026-11-30'),
('MediTrust', 14, 'MT456789', '2025-05-31'),
('SecureLife', 15, 'SL567890', '2027-12-31'),
('GuardianCare', 16, 'GC678901', '2024-06-30'),
('MedTrust', 17, 'MT789012', '2025-08-31'),
('OptimaHealth', 18, 'OH890123', '2026-02-28'),
('HealthPlus', 19, 'HP901234', '2025-04-30'),
('MedicareAdvantage', 20, 'MA012345', '2026-07-31'),
('GlobalHealth', 21, 'GH123456', '2025-03-31'),
('FlexCare', 22, 'FC234567', '2027-09-30'),
('EasyHealth', 23, 'EH345678', '2025-10-31'),
('TotalCare', 24, 'TC456789', '2026-12-31'),
('BlueCross', 25, 'BC567890', '2024-08-15'),
('HealthChoice', 26, 'HC678901', '2025-06-30'),
('FamilyCare', 27, 'FC789012', '2027-01-31'),
('OptimumCare', 28, 'OC890123', '2026-05-31'),
('MediCarePlus', 29, 'MCP901234', '2025-02-28'),
('LifeCare', 30, 'LC012345', '2024-11-30'),
('MedCare', 31, 'MC123456', '2026-04-30'),
('CareSecure', 32, 'CS234567', '2025-12-31'),
('GlobalMed', 33, 'GM345678', '2027-07-31'),
('SecurePlus', 34, 'SP456789', '2024-09-30'),
('VitalHealth', 35, 'VH567890', '2026-03-31'),
('TrustCare', 36, 'TC678901', '2025-07-31'),
('AllCare', 37, 'AC789012', '2024-10-31'),
('WellnessCare', 38, 'WC890123', '2027-06-30'),
('AdvantageHealth', 39, 'AH901234', '2025-11-30'),
('HealthSmart', 40, 'HS012345', '2026-06-30'),
('CareNet', 41, 'CN123456', '2025-02-28'),
('ProHealth', 42, 'PH234567', '2024-07-31'),
('MedLink', 43, 'ML345678', '2027-05-31'),
('LifeSecurePlus', 44, 'LSP456789', '2026-09-30'),
('SmartHealth', 45, 'SH567890', '2025-08-31'),
('WellCarePlus', 46, 'WCP678901', '2027-04-30'),
('ChoicePlus', 47, 'CP789012', '2024-12-31'),
('LifePath', 48, 'LP890123', '2025-01-31'),
('OptimaSecure', 49, 'OS901234', '2026-11-30'),
('PrimeSecure', 50, 'PS012345', '2027-03-31');

INSERT INTO lab_test (patientID, doctorID, test_name, order_date, test_result)
VALUES
(1, 1, 'Blood Pressure', '2024-11-01', 'Normal'),
(2, 2, 'Cholesterol', '2024-10-15', 'High'),
(3, 3, 'Blood Sugar', '2024-09-20', 'Normal'),
(4, 4, 'X-Ray', '2024-08-25', 'No issues detected'),
(5, 5, 'ECG', '2024-07-10', 'Normal'),
(6, 6, 'MRI', '2024-11-02', 'Clear'),
(7, 7, 'Urine Test', '2024-10-01', 'Normal'),
(8, 8, 'CT Scan', '2024-06-18', 'Normal'),
(9, 9, 'Liver Function', '2024-11-05', 'High enzymes'),
(10, 10, 'Blood Sugar', '2024-08-28', 'High'),
(11, 1, 'Cholesterol', '2024-09-05', 'Normal'),
(12, 2, 'Blood Pressure', '2024-07-22', 'High'),
(13, 3, 'X-Ray', '2024-06-14', 'Fracture detected'),
(14, 4, 'Urine Test', '2024-05-30', 'Normal'),
(15, 5, 'ECG', '2024-04-15', 'Abnormal'),
(16, 6, 'Blood Pressure', '2024-11-08', 'Normal'),
(17, 7, 'Blood Sugar', '2024-08-12', 'Normal'),
(18, 8, 'CT Scan', '2024-07-05', 'Clear'),
(19, 9, 'Cholesterol', '2024-06-29', 'Normal'),
(20, 10, 'Liver Function', '2024-11-11', 'Normal'),
(21, 1, 'MRI', '2024-05-01', 'No abnormalities'),
(22, 2, 'Blood Pressure', '2024-03-20', 'Elevated'),
(23, 3, 'Blood Sugar', '2024-02-15', 'Normal'),
(24, 4, 'X-Ray', '2024-01-28', 'Normal'),
(25, 5, 'ECG', '2024-12-02', 'Abnormal'),
(26, 6, 'Blood Sugar', '2024-09-12', 'Normal'),
(27, 7, 'Urine Test', '2024-10-19', 'Infected'),
(28, 8, 'Cholesterol', '2024-07-10', 'High'),
(29, 9, 'MRI', '2024-05-22', 'Normal'),
(30, 10, 'Blood Pressure', '2024-06-05', 'Normal'),
(31, 1, 'X-Ray', '2024-12-06', 'Clear'),
(32, 2, 'Cholesterol', '2024-08-30', 'Normal'),
(33, 3, 'Blood Sugar', '2024-09-09', 'Normal'),
(34, 4, 'CT Scan', '2024-06-12', 'Clear'),
(35, 5, 'Liver Function', '2024-05-10', 'Abnormal'),
(36, 6, 'Blood Pressure', '2024-07-19', 'Normal'),
(37, 7, 'Blood Sugar', '2024-08-01', 'High'),
(38, 8, 'ECG', '2024-09-24', 'Normal'),
(39, 9, 'Cholesterol', '2024-10-05', 'High'),
(40, 10, 'Liver Function', '2024-11-18', 'Normal'),
(41, 1, 'Blood Sugar', '2024-12-10', 'Normal'),
(42, 2, 'X-Ray', '2024-11-13', 'No issues detected'),
(43, 3, 'Urine Test', '2024-09-02', 'Normal'),
(44, 4, 'CT Scan', '2024-08-19', 'Clear'),
(45, 5, 'Blood Pressure', '2024-07-25', 'Elevated'),
(46, 6, 'Liver Function', '2024-06-03', 'Normal'),
(47, 7, 'Blood Sugar', '2024-05-15', 'Normal'),
(48, 8, 'Blood Pressure', '2024-04-11', 'Normal'),
(49, 9, 'MRI', '2024-03-01', 'Clear'),
(50, 10, 'X-Ray', '2024-12-04', 'Fracture detected');

--create views
DROP VIEW IF EXISTS appointment_detail;
CREATE VIEW appointment_detail AS
SELECT a.patientID AS patientID,
	p.first_name||' '||p.last_name AS Name,
	p.dob AS DateOfBirth,
	'Dr.'||' '|| d.last_name AS Doctor,
	a.appointment_date AS Appt_Date,
	a.appointment_time AS Appt_Time
FROM appointment AS a
JOIN patient AS p ON a.patientID = p.patientID
JOIN doctor AS d ON d.doctorID = a.doctorID;

DROP VIEW IF EXISTS patient_bill;
CREATE VIEW patient_bill AS
SELECT b.patientID AS patientID,
    p.first_name||' '||p.last_name AS Name,
    p.dob AS DateOfBirth,
    '$'|| ' '||SUM(b.amount) AS Bill,
	b.status AS status
FROM patient AS p 
JOIN billing AS b ON p.patientID = b.patientID
GROUP BY b.patientID,p.first_name||' '||p.last_name,DateOfBirth,b.status
ORDER BY SUM(b.amount) DESC;

-- create procedure
CREATE OR REPLACE PROCEDURE add_newPatient(
	IN p_first_name VARCHAR(20),
	IN p_last_name VARCHAR (20),
	IN p_dob DATE,
	IN p_gender VARCHAR (20),
	IN p_address VARCHAR (50),
	IN p_phone CHAR(10),
	IN p_email varchar(50))
LANGUAGE plpgsql
    AS $$
BEGIN 
	INSERT INTO patient(first_name,last_name,dob,gender,address,phone,email)
    VALUES(p_first_name,p_last_name,p_dob,p_gender,p_address,p_phone,p_email);
END;
$$;











	

