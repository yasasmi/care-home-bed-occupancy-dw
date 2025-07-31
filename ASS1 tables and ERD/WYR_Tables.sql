DROP TABLE WYR_Employee  CASCADE CONSTRAINTS;
DROP TABLE WYR_Doctor  CASCADE CONSTRAINTS;
DROP TABLE WYR_Nurse  CASCADE CONSTRAINTS;
DROP TABLE WYR_Patient  CASCADE CONSTRAINTS;
DROP TABLE WYR_Reservation  CASCADE CONSTRAINTS;
DROP TABLE WYR_BedOccupancy  CASCADE CONSTRAINTS;
DROP TABLE WYR_Bed  CASCADE CONSTRAINTS;
DROP TABLE WYR_CARE_CENTRE  CASCADE CONSTRAINTS;
DROP TABLE WYR_WARD  CASCADE CONSTRAINTS;
DROP TABLE WYR_BedAssigned  CASCADE CONSTRAINTS;
 
-- these are other staff working in hospital/care home
CREATE TABLE WYR_Employee (
    employee_id INT   PRIMARY KEY,
    employee_name VARCHAR(100)  NOT NULL,
    employee_type VARCHAR(20),
    employee_address VARCHAR(200)  NOT NULL,
    employee_contact VARCHAR(20)  UNIQUE,
    gender VARCHAR(10),
    dob TIMESTAMP  NOT NULL,
    doj TIMESTAMP
);

-- working at the care home
CREATE TABLE WYR_Doctor (
  employee_id INT PRIMARY KEY,
  years_of_exp INT  NOT NULL,
  speciality VARCHAR(50)  NOT NULL,
  consultation_fee NUMERIC(10,2),
  FOREIGN KEY (employee_id) REFERENCES WYR_Employee (employee_id)
);

CREATE TABLE WYR_Nurse (
  employee_id INT PRIMARY KEY,
  years_of_exp INT  NOT NULL,
  skill VARCHAR(100)  NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES WYR_Employee (employee_id)
);

CREATE TABLE WYR_Patient (
  patient_no VARCHAR(20) PRIMARY KEY,
  patient_image BLOB NULL,
  patient_name VARCHAR(50) NOT NULL,
  gender VARCHAR(10),
  patient_address VARCHAR(100) NOT NULL,
  patient_contact VARCHAR(20) NOT NULL  UNIQUE,
  patient_email_id VARCHAR(50) NOT NULL  UNIQUE,
  blood_group VARCHAR(10) NOT NULL,
  dob DATE 
);


CREATE TABLE WYR_Reservation (
    reservation_id INT   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    waiting_code VARCHAR(10)  NOT NULL,
    booking_date TIMESTAMP,
    notes VARCHAR(500) ,
    reservation_type VARCHAR(20)  NOT NULL,
    reservation_subtype  VARCHAR(20)  NOT NULL,
    reservation_status VARCHAR(20),
    employee_id INT NULL ,
    admission_date TIMESTAMP  NULL,
    FOREIGN KEY (employee_id) REFERENCES WYR_Employee (employee_id)
);

CREATE TABLE WYR_BedOccupancy (
    reservation_id INT PRIMARY KEY,
    patient_no VARCHAR(20)  NOT NULL,
    requested_bed_type VARCHAR(20),
    FOREIGN KEY (reservation_id) REFERENCES WYR_Reservation(reservation_id),
    FOREIGN KEY (patient_no) REFERENCES WYR_Patient(patient_no)
);

CREATE TABLE WYR_CARE_CENTRE (
    care_id NUMBER(2),
    care_centre_name VARCHAR2(20) UNIQUE,
    address VARCHAR2(60) NOT NULL,
    town VARCHAR2(35) NOT NULL,
    email VARCHAR2(30) NOT NULL,
    phone VARCHAR2(25) NOT NULL UNIQUE,
    postcode VARCHAR2(10) NOT NULL,
    CONSTRAINTS pk_centre_id2 PRIMARY KEY (care_id)
);

-- Care centre id FK here
CREATE TABLE WYR_WARD(
    ward_no NUMBER(5),
    ward_name VARCHAR2(20),
    ward_capacity NUMBER(2) NOT NULL,
    care_id NUMBER(2) NOT NULL,
	ward_status VARCHAR2(8),
    CONSTRAINTS pk_ward_id2 PRIMARY KEY(ward_no),
    FOREIGN KEY (care_id) REFERENCES WYR_CARE_CENTRE(care_id)
    );

CREATE TABLE WYR_Bed (
  ward_no NUMBER(5),
  bed_no INT PRIMARY KEY,
  bed_type VARCHAR(50),
  bed_status VARCHAR(50),
  FOREIGN KEY (ward_no) REFERENCES WYR_WARD (ward_no)
);

CREATE TABLE WYR_BedAssigned (
    reservation_id INT NOT NULL,
    bed_no INT  NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES WYR_Reservation(reservation_id),
    FOREIGN KEY (bed_no) REFERENCES WYR_Bed(bed_no)
);



ALTER TABLE WYR_Employee
ADD CONSTRAINT CHK_Employee_Contact2 CHECK (REGEXP_LIKE(employee_contact, '^[0-9]{10}$'));

ALTER TABLE WYR_Patient
ADD CONSTRAINT CHK_Patient_Contact2 CHECK (REGEXP_LIKE(patient_contact, '^[0-9]{10}$'));

--VALUES CARE CENTRE
INSERT INTO WYR_Care_Centre VALUES (1,'LBU CareHome','80 Foxcroft Drive','Leeds','BEWAN321@GMAIL.COM','(0113)224-34125','LS4 0BN');
INSERT INTO WYR_Care_Centre VALUES (2,'OSCAR CareHome','59 Wales Road', 'Leeds','ALTORN212@GMAIL.COM','(0113)326-31838','LS1 1EE');
INSERT INTO WYR_Care_Centre VALUES (3,'JUNO CareHome','108 Otley Cottage', 'Harrogate','WELLBEING2023@GMAIL.COM','(0112)224-341897','HG1 4DG');

--VALUES WARD (care centre fk)

INSERT INTO WYR_WARD VALUES (1, 'GENERAL care', 20, 1,'ACTIVE');
INSERT INTO WYR_WARD VALUES (2, 'GENERAL care', 20, 2,'ACTIVE');
INSERT INTO WYR_WARD VALUES (3, 'GENERAL care',20, 3,'ACTIVE');

INSERT INTO WYR_Employee ( employee_id, employee_name, employee_type, employee_address, employee_contact, gender, dob, doj)
VALUES ('1', 'Dr. Elizabeth P. Ervin', 'Doctor', '51 Stone St, CRAW KA27 4XU', '7124543490', 'Male', to_date('1980-03-11','yyyy-mm-dd'), to_date('2022-01-15','yyyy-mm-dd'));
INSERT INTO WYR_Employee (  employee_id, employee_name, employee_type, employee_address, employee_contact, gender, dob, doj)
VALUES ('2', 'Dr. Douglas B. Jones', 'Doctor', '78 Way, Kent Street, RHIWDERIN NP1 6DQ', '7124543491', 'Male', to_date('1970-08-12','yyyy-mm-dd'), to_date('2021-04-09','yyyy-mm-dd'));
INSERT INTO WYR_Employee (  employee_id, employee_name, employee_type, employee_address, employee_contact, gender, dob, doj)
VALUES ('3', 'Christine J. Sanchez', 'Nurse', '23 Kent Street, CROSSAIG PA29 5JL', '7124543492', 'Female', to_date('1956-01-01','yyyy-mm-dd'), to_date('2022-12-12','yyyy-mm-dd'));
INSERT INTO WYR_Employee (  employee_id, employee_name, employee_type, employee_address, employee_contact, gender, dob, doj)
VALUES ('4', 'Kristine J. Taylor', '', '58 Lammas Street, GREAT BUSBY TS9 1WW', '7124543493', '', to_date('1968-03-02','yyyy-mm-dd'), to_date('2023-07-05','yyyy-mm-dd'));

SELECT * FROM WYR_Employee;


INSERT INTO WYR_Doctor (employee_id, years_of_exp, speciality, consultation_fee) VALUES (1, 10, 'General Care', 200.00);
INSERT INTO WYR_Doctor (employee_id, years_of_exp, speciality, consultation_fee) VALUES (2, 15, 'General Care', 250.00);


SELECT * FROM WYR_Doctor;

INSERT INTO WYR_Nurse (employee_id, years_of_exp, skill) VALUES (3, 3, 'General Care');
INSERT INTO WYR_Nurse (employee_id, years_of_exp, skill) VALUES (4, 8, 'General Care');

SELECT * FROM WYR_Nurse;


INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('1', 'Paula M. Condit', 'Female', '15 Quay Street, Leeds, LS14 1JQ', '7710223091', 'PaulaMCondit@rhyta.com', 'O-', '');
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('2', 'Clint S. Martin', 'Male', '94 Cambridge Road, Leeds, LS5 9QH', '7710223020', 'ClintSMartin@rhyta.com', 'A-',  to_date('1948-11-22','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('3', 'Melody L. Harmon', 'Female', '40 Winchester Rd, Leeds, LS41 8JU', '7710223021', 'MelodyLHarmon@armyspy.com', 'B+',  to_date('1937-02-18','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('4', 'Donna N. Ray', 'Female', '97 Union Terrace, Leeds, LS4 7XU', '7710223022', 'DonnaNRay@teleworm.us', 'AB-',  to_date('1935-08-05','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('5', 'Pearl J. Lau', 'Female', '39 Consett Rd, Leeds, LS3 9DA', '7710223023', 'PearlJLau@jourrapide.com', 'O+',  to_date('1935-03-31','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('6', 'Laura A. Zoll', 'Female', '77 Caerfai Bay Road, Leeds, LS6 4GA', '7710223024', 'LauraAZoll@teleworm.us', 'B-',  to_date('1933-06-29','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('7', 'Charles M. Smith', 'Male', '63 Winchester Rd, Leeds, LS4 3GS', '7710223025', 'CharlesMSmith@dayrep.com', 'A+',  to_date('1930-09-15','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('8', 'Tom B. Anthony', 'Male', '70 Warner Close, Leeds, LS65 8ZW', '7710223026', 'TomBAnthony@jourrapide.com', 'AB+',  to_date('1930-04-08','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('9', 'Rachel J. Elmore', 'Female', '5 Kent Street, Leeds, LS12 1ZL', '7710223027', 'RachelJElmore@dayrep.com', 'O-',  to_date('1946-07-23','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('10', 'Andy R. Flores', '', '53 Rhosddu Rd, Leeds, LS30 0ZG', '7710223028', 'AndyRFlores@gmail.com', 'B+',  to_date('1939-01-29','yyyy-mm-dd'));

INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('11', 'Jodie J. Chadwick', '', '59 Wartnaby Road, Leeds, LS13 3RT', '7710693191', 'JodieChadwick@armyspy.com', 'O-', to_date('1922-07-12','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('12', 'Joshua Lowe', 'Mal e', '99 Neville Street, Leeds, LS7 8HP', '7710223333', 'JoshuaLowe@armyspy.com', 'A-',  to_date('1948-11-20','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('13', 'Ella Hughes', 'F emale', '78 Thompsons Lane, Leeds, LS16 1UL', '7098223021', 'EllaHughes@teleworm.us', 'B+',  to_date('1942-02-18','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('14', 'Spencer Reid', 'Male', '95 Essex Rd, Leeds', '7709281775', 'SpencerReid@teleworm.us', 'AB-',  to_date('1945-09-05','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('15', 'Joe Allenu', 'Male', '57 Lincoln Green Lane, Harrogate, HG1 9BU', '7967403580', 'JoeAllen@jourrapide.com', 'O+',  to_date('1945-03-21','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('16', 'Ava Davis', 'Female', '80 Davids Lane, Harrogate, HG1 3AE', '7710000024', 'AvaDavis@teleworm.us', 'B-',  to_date('1943-01-29','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('17', 'Summer Bell', 'Female', '3 Bridge Street, Harrogate, HG1 5ES', '7718883025', 'SummerBell@teleworm.us', 'A+',  to_date('1940-09-15','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('18', 'Chloe George', 'Female', '50 Hull Road, Harrogate', '7110223026', 'ChloeGeorge@armyspy.com', 'AB+',  to_date('1930-02-08','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('19', 'Amelia Lynch', 'Female', '67 South Crescent, LYMPSHAM, BS24 9ZB', '7710225557', 'AmeliaLynch@jourrapide.com', 'O-',  to_date('1936-01-23','yyyy-mm-dd'));
INSERT INTO WYR_Patient (patient_no, patient_name, gender, patient_address, patient_contact, patient_email_id, blood_group, dob)
VALUES ('20', 'Evie Butler', 'Female', '17 Kent Street, Harrogate, HG1 2HZ', '7710222028', 'EvieButler@armyspy.com', 'B+',  to_date('1948-01-29','yyyy-mm-dd'));

I
SELECT * FROM WYR_Patient;


INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('01', to_date('2023-04-01','yyyy-mm-dd'), 'Patient needs wheelchair access','Bed','Single', 'Confirmed', to_date('2023-04-08','yyyy-mm-dd'),4);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('02', '', 'Patient has allergies to penicillin','Bed','Double', 'Confirmed', to_date('2023-04-08','yyyy-mm-dd'),3);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('03', to_date('2023-04-04','yyyy-mm-dd'), 'Patient requires interpreter','Bed','Single', 'Confirmed', to_date('2023-04-08','yyyy-mm-dd'),2);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('04', to_date('2023-04-05','yyyy-mm-dd'), 'Patient is diabetic','Bed','Single', 'Confirmed', to_date('2023-04-08','yyyy-mm-dd'),1);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('05', to_date('2023-04-06','yyyy-mm-dd'), 'Patient has high blood pressure','Bed','Double', 'Confirmed', to_date('2023-04-09','yyyy-mm-dd'),1);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('06', to_date('2023-04-07','yyyy-mm-dd'), 'Patient needs surgery','Room','Deluxe Kings Basic', 'Confirmed', to_date('2023-04-08','yyyy-mm-dd'),2);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('07', to_date('2023-04-08','yyyy-mm-dd'), 'Patient has history of heart disease','Bed','Single', 'Confirmed', to_date('2023-04-08','yyyy-mm-dd'),1);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('08', to_date('2023-04-09','yyyy-mm-dd'), 'Patient requires wheelchair access','Bed','Single', ' ', to_date('2023-04-12','yyyy-mm-dd'),4);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('09', to_date('2023-04-10','yyyy-mm-dd'), 'Patient has a broken leg','Room','Deluxe', 'Cancelled', NULL,NULL);

INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('10', to_date('2023-01-04','yyyy-mm-dd'), 'Patient requires interpreter','Room','Standard', '', to_date('2023-02-01','yyyy-mm-dd'),3);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('11', to_date('2023-02-01','yyyy-mm-dd'), 'Patient requires interpreter','Room','Deluxe', 'Confirmed', to_date('2023-02-19','yyyy-mm-dd'),2);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('12', to_date('2022-12-03','yyyy-mm-dd'), 'Patient has allergies to penicillin','Bed','Double', 'Confirmed', to_date('2023-01-11','yyyy-mm-dd'),3);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('13', to_date('2023-01-04','yyyy-mm-dd'), 'Patient requires interpreter','Bed','Single', '', to_date('2023-02-18','yyyy-mm-dd'),2);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('14', to_date('2022-10-13','yyyy-mm-dd'), 'Patient is diabetic','Bed','Single', 'Confirmed', to_date('2022-11-01','yyyy-mm-dd'),4);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('15', to_date('2023-03-02','yyyy-mm-dd'), 'Patient has high blood pressure','Bed','Double', 'Confirmed', to_date('2023-03-05','yyyy-mm-dd'),1);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('16', to_date('2021-09-01','yyyy-mm-dd'), 'Patient needs surgery','Room','Deluxe', 'Confirmed', to_date('2021-11-11','yyyy-mm-dd'),2);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('17', to_date('2023-03-12','yyyy-mm-dd'), 'Patient has history of heart disease','Bed','Single', 'Confirmed', to_date('2023-03-19','yyyy-mm-dd'),1);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('18', to_date('2022-01-19','yyyy-mm-dd'), 'Patient requires wheelchair access','Bed','Single', 'Confirmed', to_date('2022-02-22','yyyy-mm-dd'),4);
INSERT INTO WYR_Reservation ( waiting_code, booking_date, notes, reservation_type, reservation_subtype, reservation_status, admission_date,employee_id)
VALUES ('19', to_date('2022-11-04','yyyy-mm-dd'), 'Patient has a broken leg','Room','Deluxe', 'Cancelled',  NULL,NULL);

SELECT * FROM WYR_Reservation;

INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (3, 5, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (1, 11, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (2, 1, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (19, 5, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (4, 12, 'Single');

INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (10, 15, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (11, 2, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (8, 4, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (6, 10, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (7, 3, 'Single');

INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (12, 8, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (14, 4, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (13, 5, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (16, 7, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (15, 6, 'Single');

INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (17, 19, 'Single');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (18, 18, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (5, 9, 'Double');
INSERT INTO WYR_BedOccupancy (reservation_id, patient_no, requested_bed_type) VALUES (9, 14, '');



SELECT * FROM WYR_BedOccupancy;


INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1102, 'Single', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1201, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1202, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1301, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1401, 'Single', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1402, 'Double', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1501, 'Double', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1502, 'Double', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (1,1601, 'Double', 'Available');

INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2102, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2201, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2202, 'Single', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2301, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2401, 'Single', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2402, 'Double', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2501, 'Double', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2502, 'Double', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (2,2601, 'Double', 'Occupied');

INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3102, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3201, 'Single', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3202, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3301, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3401, 'Single', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3402, 'Double', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3501, 'Double', 'Occupied');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3502, 'Double', 'Available');
INSERT INTO WYR_Bed (ward_no,bed_no, bed_type, bed_status) VALUES (3,3601, 'Double', 'Occupied');


SELECT * FROM WYR_Bed;



INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (1, 1102);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (2, 1201);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (3, 1202);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (4, 1301);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (5, 1401);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (6, 1501);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (7, 1502);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (8, 3102);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (10, 3202);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (11, 3502);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (12, 2601);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (13, 2601);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (14, 3501);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (15, 3601);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (16, 2401);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (17, 2402);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (18, 2601);
INSERT INTO WYR_BedAssigned (reservation_id, bed_no) VALUES (19, 2202);


SELECT * FROM WYR_BedAssigned;



