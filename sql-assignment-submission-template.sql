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

-- 7) Names of all employees who do not have a car (”No car” must be printed in an extra column. Atleast three different solutions are required). *

-- ================================================
-- End of Assignment
-- ================================================
