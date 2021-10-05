/*
Name: MD. SHOHANUR RAHMAN
Student ID: 1262304
*/

--------------------------- [Q.No. 01]
USE master
IF DB_ID('FacultyManagementDB') IS NOT NULL
DROP DATABASE FacultyManagementDB
GO
CREATE DATABASE FacultyManagementDB
ON
(
	NAME = 'FacultyManagementDB_Data_1',
	FILENAME = 'E:\MEGA\Education\FacultyManagementDB_Data_1.mdf',
	SIZE = 25mb,
	MAXSIZE = 100mb,
	FILEGROWTH = 5%
)
LOG ON
(
	NAME = 'FacultyManagementDB_Log_1',
	FILENAME = 'E:\MEGA\Education\FacultyManagementDB_Log_1.ldf',
	SIZE = 2mb,
	MAXSIZE = 25mb,
	FILEGROWTH = 1%
)
GO
USE FacultyManagementDB
GO
CREATE TABLE Faculty
(
	FacultyID Varchar(4) PRIMARY KEY NOT NULL,
	FacultyFName Varchar(8),
	FacultyLName Varchar(8),
	FacultyPhone Varchar(6)
)
GO
CREATE TABLE Department
(
	DepartmentID Varchar(4) PRIMARY KEY NOT NULL,
	DepartmentName Varchar(10)
)
GO
CREATE TABLE Course
(
	CourseID Varchar(4) PRIMARY KEY NONCLUSTERED NOT NULL,
	CourseName Varchar(10)
)
GO
CREATE TABLE Hire
(
	FacultyID Varchar(4) REFERENCES Faculty(FacultyID),
	DepartmentID Varchar(4) REFERENCES Department(DepartmentID),
	CourseID Varchar(4) REFERENCES Course(CourseID),
	HireDate date
)
GO

--------------------------- [Q.No. 05 (Delete Table)]
DROP TABLE [Sample];
GO

--------------------------- [Q.No. 06 (Delete Column)]
ALTER TABLE [Sample]
DROP COLUMN Sample1;
GO

--------------------------- [Q.No. 07 (Join-Query)]
SELECT H.DepartmentID, DepartmentName, 
	FacultyFName +' '+ FacultyLName as FacultyName
FROM Hire AS H 
	JOIN Faculty AS F
		ON  H.FacultyID = F.FacultyID
			JOIN Department as D
				ON H.DepartmentID = D.DepartmentID
WHERE H.DepartmentID = 'L004'
GO

--------------------------- [Q.No. 08 (Sub-Query)]
SELECT H.DepartmentID, DepartmentName, 
	FacultyFName +' '+ FacultyLName as FacultyName, FacultyPhone 
FROM Hire AS H 
	JOIN Faculty AS F
		ON  H.FacultyID = F.FacultyID
			JOIN Department as D
				ON H.DepartmentID = D.DepartmentID
WHERE DepartmentName IN (SELECT DepartmentName FROM Department WHERE DepartmentName = 'CSC')
GO

--------------------------- [Q.No. 09 (Create View)]
CREATE View MyView AS
SELECT FacultyID, FacultyFName +' '+ FacultyLName AS FacultyName, 
	FacultyPhone FROM Faculty 
WHERE FacultyFName = 'Victor' AND FacultyLName = 'Gomez'
GO
--USE
SELECT * FROM MyView
GO
--------------------------- [Q.No. 10 (Stored Procedure)]
USE FacultyManagementDB
GO
CREATE PROCEDURE spReadInsertUpdateDeleteFaculty
@TaskType VARCHAR (20),
@FacultyID VARCHAR (20),
@FacultyFName VARCHAR (20),
@FacultyLName VARCHAR (20),
@FacultyPhone VARCHAR (20) OUTPUT

AS
BEGIN
	IF @TaskType = 'Select'
	BEGIN
		SELECT * FROM Faculty
	END

	IF @TaskType = 'Insert'
	BEGIN TRY 
		INSERT INTO Faculty VALUES (@FacultyID, @FacultyFName, @FacultyLName, @FacultyPhone)
	END TRY
	BEGIN CATCH 
		SELECT ERROR_MESSAGE() AS ErrorMessage,
		ERROR_Number() AS ErrorNumber, 
		ERROR_LINE() AS ErrorState,
		ERROR_SEVERITY() AS ErrorSeverity
	END CATCH 
	IF @TaskType='Update'
	BEGIN 
		UPDATE Faculty SET FacultyID = @FacultyID, FacultyFName = @FacultyFName, 
			FacultyLName = @FacultyLName, FacultyPhone = @FacultyPhone
		WHERE FacultyID = @FacultyID
	END
	IF @TaskType='Delete'
	BEGIN
		DELETE FROM Faculty
		WHERE FacultyID = @FacultyID
	END
END
GO
--USE
USE FacultyManagementDB
GO
Exec spReadInsertUpdateDeleteFaculty 'Select', '', '', '',''
EXEC spReadInsertUpdateDeleteFaculty 'DN01', '', '', '',''
Exec spReadInsertUpdateDeleteFaculty 'Update', 'DN01', 'DN01', '',''
Exec spReadInsertUpdateDeleteFaculty 'Delete', '', '', '',''
GO

--------------------------- [Q.No. 11 (Create Clustered Index)]
CREATE CLUSTERED INDEX IX_Course_CourseName
ON Course (CourseName)
GO

--------------------------- [Q.No. 12 (Scalar Valued Function)]
CREATE Function fnCourseNameVarchar (@CourseID VARCHAR(20))
RETURNS VARCHAR(10)
BEGIN
RETURN (SELECT CourseName FROM Course WHERE CourseID = @CourseID)
END
GO
--USE
Select *,dbo.fnCourseNameVarchar(CourseID) from Course
Select dbo.fnCourseNameVarchar ('C002')
GO

--------------------------- [Q.No. 13 (Table Valued Function)]
CREATE Function fnCourseName (@CourseID Varchar(10))
RETURNS TABLE
RETURN
(SELECT CourseName FROM Course WHERE CourseID = @CourseID)
GO
--USE
Select * from dbo.fnCourseName('C006')
GO

--------------------------- [Q.No. 14 (Trigger)]
CREATE TRIGGER trCourseNameUpperCaseWhenInsert
ON Course
After INSERT, UPDATE
AS
UPDATE Course
SET CourseName = UPPER(CourseName)
WHERE CourseName IN (SELECT CourseName FROM inserted)
GO

--------------------------- [Q.No. 15 (Transaction)]
SELECT * FROM Course
BEGIN TRAN
	INSERT INTO Course VALUES ('C007','PHP')
COMMIT TRAN
GO

--------------------------- [Q.No. 17 (CTE)]
WITH Course_CTE (CourseID, CourseName)  
AS    
(  
    SELECT CourseID, COUNT(CourseName) AS TotalCourse
		FROM Course 
    WHERE CourseID IS NOT NULL 
	GROUP BY CourseID 
)    
SELECT CourseID, COUNT(CourseName) AS TotalCourse  
	FROM Course  
GROUP BY CourseID  
ORDER BY CourseID;  
GO

--------------------------- [Q.No. 18 (CASE)]
--Simple Case
USE FacultyManagementDB
GO
SELECT CourseID, CourseName,
CASE CourseName 
	WHEN 'CSharp' THEN 'Microsoft Programmer'
	WHEN 'JAVA' THEN 'Java Programmer'
	WHEN 'ZOO' THEN 'Zoologist'
	ELSE 'Others'
	END AS SubjenctType
FROM Course;
GO
--Search Case
USE FacultyManagementDB
GO
SELECT CourseID, CourseName,
CASE  
	WHEN CourseName = 'CSharp' THEN 'Microsoft Programmer'
	WHEN CourseName = 'JAVA' THEN 'Java Programmer'
	WHEN CourseName = 'ZOO' THEN 'Zoologist'
	ELSE 'Others'
	END AS SubjenctType
FROM Course;
GO

--------------------------- [Q.No. 19 (Cursor)]
USE FacultyManagementDB
GO
CREATE TABLE #Subject
(
	ID VARCHAR(5),
	SubjectLName VARCHAR(15)
)
GO
INSERT INTO #Subject VALUES ('C010', 'WDF')
INSERT INTO #Subject VALUES ('C011', 'ENG')
INSERT INTO #Subject VALUES ('C012', 'BAN')

DECLARE @SubjectName VARCHAR(15), @ID VARCHAR(5)
DECLARE SubjectCursor CURSOR FOR 
SELECT * FROM #Subject
OPEN SubjectCursor
	FETCH NEXT FROM SubjectCursor INTO @ID, @SubjectName
		WHILE (@@FETCH_STATUS=0)
	BEGIN 
		INSERT INTO Course VALUES (@ID, @SubjectName)
		FETCH NEXT FROM SubjectCursor INTO @ID, @SubjectName
	END
CLOSE SubjectCursor
DEALLOCATE SubjectCursor
GO

--------------------------- [Q.No. 20 (NTile)] 
USE FacultyManagementDB
GO
SELECT CourseName,
	NTILE(6) OVER(ORDER BY CourseID) AS WithTiled
FROM Course
GO

--------------------------- [Q.No. 21 (Merge)] 
USE FacultyManagementDB
GO
CREATE TABLE Subject1
(
CourseID INT,
CourseName VARCHAR(10)
)
GO
INSERT INTO Subject1 VALUES
(101, 'Java'), (102, 'WDF')
GO


CREATE TABLE Subject2
(
CourseID INT,
CourseName VARCHAR(10)
)
GO
INSERT INTO Subject2 VALUES
(101, 'Java'), (103, 'CSharp')
GO

MERGE Subject1 AS T
USING Subject2 AS S
ON (T.CourseID = S.CourseID) 
WHEN MATCHED THEN
Update SET T.CourseName = S.CourseName
WHEN NOT MATCHED BY TARGET THEN
INSERT (CourseID, CourseName)  VALUES (S.CourseID, S.CourseName)
WHEN not matched BY Source THEN DELETE;
