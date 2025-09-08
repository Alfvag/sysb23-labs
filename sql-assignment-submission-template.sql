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

SELECT Employee.EmpName FROM Employee
JOIN Examines ON Employee.EmployeeID = Examines.EmployeeID
JOIN Patient ON Examines.PatientID = Patient.PatientID
WHERE Patient.PatientName= 'Peter';

-- 20) Names of all employees who live in the same city as the employee named Hans.

SELECT Employee.EmpName FROM Employee
WHERE Employee.EmpAddress = (SELECT Employee.EmpAddress FROM Employee WHERE Employee.EmpName = 'Hans');

-- 21) Names of all illnesses that more than one patient is suffering from. *

SELECT Illness.IllnessName FROM Illness
JOIN Suffers ON Illness.IllnessID = Suffers.IllnessID
GROUP BY IllnessName HAVING COUNT(*) > 1;


-- 22) Names of units with more than two patients. *

SELECT Unit.UnitName FROM Unit
JOIN Patient ON Unit.UnitID = Patient.UnitID
GROUP BY Unit.UnitName HAVING COUNT(*) > 2;

-- 23) Names of patients being treated in unit U3 or suffering from cough.

SELECT Patient.PatientName FROM Patient
JOIN Unit ON Patient.UnitID = Unit.UnitID
WHERE Unit.UnitName = 'U3' OR Patient.PatientID IN (
    SELECT Suffers.PatientID FROM Suffers
    JOIN Illness ON Suffers.IllnessID = Illness.IllnessID
    WHERE Illness.IllnessName = 'cough'
);


-- 24) PatientID for all patients who are suffering from exactly two illnesses.

SELECT Patient.PatientID FROM Patient
LEFT OUTER JOIN Suffers ON Patient.PatientID = Suffers.PatientID
GROUP BY Patient.PatientID HAVING COUNT(Suffers.IllnessID) = 2;

-- 25) Copy PatientID, phone number and name for all patients suffering from love sickness into a separate table and name that table ”LoveTable”. *

SELECT Patient.PatientID, Patient.PatientPhoneNumber, Patient.PatientName INTO LoveTable
FROM Patient
JOIN Suffers ON Patient.PatientID = Suffers.PatientID
JOIN Illness ON Suffers.IllnessID = Illness.IllnessID
WHERE Illness.IllnessName = 'love sickness';

-- 26) Set all employees’ salaries to 90% of the salary of employee E1.

UPDATE Employee
SET EmpSalary = (SELECT EmpSalary * 0.9 FROM Employee WHERE EmployeeID IN (SELECT EmployeeID FROM Employee WHERE EmpNo = 'E1'));

-- 27) License number, brand and price for any cars belonging to employees examining patient PP1.

SELECT Car.LicenseNo, Car.Brand, Car.Price FROM Car
JOIN Employee ON Car.EmployeeID = Employee.EmployeeID
JOIN Examines ON Employee.EmployeeID = Examines.EmployeeID
JOIN Patient ON Examines.PatientID = Patient.PatientID
WHERE Examines.PatientID IN (SELECT PatientID FROM Patient WHERE PatientNo = 'PP1');

-- 28) Increase salary for all employees who are examining more than two patients by 10%. *

UPDATE Employee
SET EmpSalary = EmpSalary * 1.1
 WHERE Employee.EmployeeID IN (
    SELECT Employee.EmployeeID FROM Employee
    JOIN Examines ON Employee.EmployeeID = Examines.EmployeeID
    GROUP BY Employee.EmployeeID HAVING COUNT(Examines.PatientID) > 2);

-- 29) Names of all employees whose salaries are above average.

SELECT Employee.EmpName FROM Employee
WHERE EmpSalary > (SELECT AVG(EmpSalary) FROM Employee);

-- 30) Names of units that don’t have any employees. *

SELECT Unit.UnitName FROM Unit
WHERE Unit.UnitID NOT IN (SELECT DISTINCT UnitID FROM Employee);

-- 31) Names of all patients who have not suffered from any illnesses previously.

SELECT Patient.PatientName FROM Patient
WHERE Patient.PatientID NOT IN (SELECT DISTINCT PatientID FROM HasSuffered);

-- 32) Which patients have had love sickness for more than two months?

SELECT Patient.PatientID FROM Patient
WHERE Patient.PatientID IN (
    SELECT Suffers.PatientID FROM Suffers
    JOIN Illness ON Suffers.IllnessID = Illness.IllnessID
    WHERE Illness.IllnessName = 'Love Sickness'
    AND Suffers.StartDate < DATEADD(MONTH, -2, GETDATE())
);

-- 33) Names of all employees who are not examining patients (at least two solutions required). *

SELECT Employee.EmpName FROM Employee
WHERE Employee.EmployeeID NOT IN (SELECT DISTINCT EmployeeID FROM Examines);

SELECT Employee.EmpName FROM Employee
LEFT JOIN Examines ON Employee.EmployeeID = Examines.EmployeeID
WHERE Examines.EmployeeID IS NULL;

-- 34) Names and addresses of all employees and patients. *

SELECT Employee.EmpName AS Name, Employee.EmpAddress AS Address FROM Employee
UNION ALL
SELECT Patient.PatientName, Patient.PatientAddress FROM Patient;

-- 35) Names of all employees who are also patients. *

SELECT Employee.EmpName FROM Employee
JOIN Patient ON Employee.EmpPhoneNumber = Patient.PatientPhoneNumber;

-- 36) Names of employees who are not also patients.

SELECT Employee.EmpName FROM Employee
WHERE Employee.EmpPhoneNumber NOT IN (SELECT Patient.PatientPhoneNumber FROM Patient);

-- 37) Name of the patient that has suffered from any disease for the longest duration of time. *

SELECT TOP 1 Patient.PatientName FROM Patient
JOIN Suffers ON Patient.PatientID = Suffers.PatientID
ORDER BY Suffers.StartDate ASC;

-- 38) Names of patients who have all illnesses. *

SELECT Patient.PatientName FROM Patient
WHERE ((SELECT DISTINCT COUNT(Illness.IllnessID) FROM Illness) = 
        (SELECT COUNT(Suffers.IllnessID) FROM Suffers WHERE Suffers.PatientID = Patient.PatientID));

-- 39) Remove all patients in unit U2. *

DELETE FROM Examines WHERE PatientID =
(SELECT Patient.PatientID FROM Patient
JOIN Unit ON Patient.UnitID = Unit.UnitID
WHERE Unit.UnitNo = 'U2')

DELETE FROM Patient WHERE PatientID =
(SELECT Patient.PatientID FROM Patient
JOIN Unit ON Patient.UnitID = Unit.UnitID
WHERE Unit.UnitNo = 'U2');

-- 40) Remove unit U2: svettigt!!

UPDATE Employee SET UnitID = NULL WHERE UnitID = (SELECT UnitID FROM Unit WHERE UnitNo = 'U2');
DELETE FROM Unit WHERE UnitNo = 'U2';

-- ================================================
-- End of Assignment
-- ================================================