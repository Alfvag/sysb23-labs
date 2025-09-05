-- SQL Assignment: Group X (Group Members: Name1, Name2, Name3)
-- Course: SYSB23, IS- and Business Development
-- Date: YYYY-MM-DD

-- ================================================
-- Task 1: Answer the following questions using SQL Queries
-- ================================================

-- 1) What patients are suffering from insomnia? *

SELECT dbo.Patient.PatientName, dbo.Illness.IllnessName
FROM dbo.Patient
JOIN dbo.Suffers ON dbo.Patient.PatientId = dbo.Suffers.PatientId
JOIN dbo.Illness ON dbo.Suffers.IllnessId = dbo.Illness.IllnessId
WHERE dbo.Suffers.IllnessId IN (SELECT 1 FROM dbo.Illness WHERE IllnessName = 'Insomnia');

-- -----------------------------------------------

-- 2) What patients have suffered from insomnia?

SELECT dbo.Patient.PatientName, dbo.Illness.IllnessName
FROM dbo.Patient
JOIN dbo.HasSuffered ON dbo.Patient.PatientId = dbo.HasSuffered.PatientId
JOIN dbo.Illness ON dbo.HasSuffered.IllnessId = dbo.Illness.IllnessId
WHERE dbo.HasSuffered.IllnessId IN (SELECT 1 FROM dbo.Illness WHERE IllnessName = 'Insomnia');

-- 3) Names of all patients who live in Malmö.

SELECT dbo.Patient.PatientName, dbo.Patient.PatientAddress
FROM dbo.Patient
WHERE dbo.Patient.PatientAddress = 'Malmö';

-- 4 ) All information on patients named Ann, Anne or Anna

SELECT dbo.Patient.PatientName
FROM dbo.Patient
WHERE dbo.Patient.PatientName LIKE 'Ann%';

-- 5) Names of patients suffering from insomnia and cough. *

SELECT dbo.Patient.PatientName
FROM dbo.Patient
JOIN dbo.Suffers ON dbo.Patient.PatientId = dbo.Suffers.PatientId
JOIN dbo.Illness ON dbo.Suffers.IllnessId = dbo.Illness.IllnessId
WHERE IllnessName = 'Insomnia'
AND dbo.Patient.PatientId IN (
    SELECT dbo.Suffers.PatientId
    FROM dbo.Suffers
    JOIN dbo.Illness ON dbo.Suffers.IllnessId = dbo.Illness.IllnessId
    WHERE IllnessName = 'Cough'
);

-- 6) Names of patients suffering from insomnia or cough (at least two different solutions are required). *

SELECT DISTINCT dbo.Patient.PatientName
FROM dbo.Patient
JOIN dbo.Suffers ON dbo.Patient.PatientId = dbo.Suffers.PatientId
JOIN dbo.Illness ON dbo.Suffers.IllnessId = dbo.Illness.IllnessId
WHERE IllnessName = 'Insomnia'
OR dbo.Patient.PatientId IN (
    SELECT dbo.Suffers.PatientId
    FROM dbo.Suffers
    JOIN dbo.Illness ON dbo.Suffers.IllnessId = dbo.Illness.IllnessId
    WHERE IllnessName = 'Cough'
);

SELECT DISTINCT dbo.Patient.PatientName
FROM dbo.Patient
JOIN dbo.Suffers ON dbo.Patient.PatientId = dbo.Suffers.PatientId
JOIN dbo.Illness ON dbo.Suffers.IllnessId = dbo.Illness.IllnessId
WHERE IllnessName = 'Insomnia' OR IllnessName = 'Cough';

-- 7) Names of all employees who do not have a car (”No car” must be printed in an extra column. At least three different solutions are required). *

SELECT Employee.EmpName, 'No Car' AS CarStatus
FROM Employee
LEFT JOIN Car ON Employee.EmployeeID = Car.EmployeeID
WHERE Car.EmployeeID IS NULL;

SELECT Employee.EmpName, 'No Car' AS CarStatus
FROM Employee
WHERE NOT EXISTS (
    SELECT 1
    FROM Car
    WHERE Car.EmployeeID = Employee.EmployeeID
);

SELECT Employee.EmpName, 'No Car' AS CarStatus
FROM Employee
WHERE Employee.EmployeeID NOT IN (SELECT Car.EmployeeID FROM Car WHERE Car.EmployeeID IS NOT NULL);

-- 8) License plate numbers of all cars for which there is no owner (”No owner!” must be printed in an extra column)

SELECT Car.LicenseNo, 'No Owner!' AS CarStatus
FROM Car
WHERE Car.EmployeeID IS NULL;

-- 9) Total salary cost for all employees.

SELECT SUM(Employee.EmpSalary) AS 'Total Salary' FROM Employee;

-- 10) Total salary cost for each employee if they would have had a 10 % increase in salary. *

SELECT Employee.EmpName AS 'Name', Employee.EmpSalary AS 'CurrentSalar', Employee.EmpSalary * 1.1 AS SalaryWith10PercentIncrease
FROM Employee;

-- 11) Print the first letter of the names of all patients.

SELECT SUBSTRING(Patient.PatientName, 1, 1) FROM Patient;

-- 12) Names and current illnesses for every patient. If a patient is suffering from love sickness, “critical condition” must be printed in an extra column. *

SELECT Patient.PatientName, Illness.IllnessName,
CASE
    WHEN Illness.IllnessName = 'Love Sickness' THEN 'Critical Condition'
    ELSE ''
END AS ConditionStatus
FROM Patient
JOIN Suffers ON Patient.PatientID = Suffers.PatientID
JOIN Illness ON Suffers.IllnessID = Illness.IllnessID;

-- 13) Who has the most expensive car? *

SELECT Car.EmployeeID FROM Car
WHERE Car.Price = (SELECT MAX(Car.Price) FROM Car);

-- 14) Decrease the prices of all cars by 5 % (use UPDATE operation).

UPDATE Car SET Car.Price = Car.Price * 0.95;

-- 15) Remove the cheapest car.

DELETE FROM Car WHERE (SELECT MIN(Car.Price) FROM Car) = Car.Price; 
-- Detta tog bort tre, alla var lika billiga

-- 16) Names of all employees working at the General Surgery unit.

SELECT Employee.EmpName
FROM Employee
JOIN Unit ON Employee.UnitID = Unit.UnitID
WHERE Unit.UnitName = 'General Surgery';

-- 17) Names of all patients suffering from the same illness as PP4. *

SELECT Patient.PatientName FROM Patient
JOIN Suffers ON Patient.PatientID = Suffers.PatientID
JOIN Illness ON Suffers.IllnessID = Illness.IllnessID
WHERE Illness.IllnessID IN (SELECT Suffers.IllnessID FROM Suffers WHERE PatientID = (SELECT PatientID FROM Patient WHERE PatientNo = 'PP4'));

-- 18) Number of patients that have suffered from love sickness.

SELECT COUNT(*) FROM HasSuffered
WHERE IllnessID = (SELECT IllnessID FROM Illness WHERE IllnessName = 'love sickness');

-- 19) Names of all doctors examining the patient named Peter.



-- 20) Names of all employees who live in the same city as the employee named Hans.



-- 21) Names of all illnesses that more than one patient is suffering from. *



-- 22) Names of units with more than two patients. *



-- 23) Names of patients being treated in unit U3 or suffering from cough.



-- 24) PatientID for all patients who are suffering from exactly two illnesses.



-- 25) Copy PatientID, phone number and name for all patients suffering from love sickness into a separate table and name that table ”LoveTable”. *



-- 26) Set all employees’ salaries to 90% of the salary of employee E1.



-- 27) License number, brand and price for any cars belonging to employees examining patient PP1.



-- 28) Increase salary for all employees who are examining more than two patients by 10%. *



-- 29) Names of all employees whose salaries are above average.



-- 30) Names of units that don’t have any employees. *



-- 31) Names of all patients who have not suffered from any illnesses previously.



-- 32) Which patients have had love sickness for more than two months?



-- 33) Names of all employees who are not examining patients (at least two solutions required). *



-- 34) Names and addresses of all employees and patients. *



-- 35) Names of all employees who are also patients. *



-- 36) Names of employees who are not also patients.



-- 37) Name of the patient that has suffered from any disease for the longest duration of time. *



-- 38) Names of patients who have all illnesses. *



-- 39) Remove all patients in unit U2. *



-- 40) Remove unit U2: svettigt!!



-- ================================================
-- End of Assignment
-- ================================================