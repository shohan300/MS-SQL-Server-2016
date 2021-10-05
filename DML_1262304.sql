/*
Name: MD. SHOHANUR RAHMAN
Student ID: 1262304
*/

--------------------------- [Q.No. 02]
USE FacultyManagementDB
GO
INSERT INTO Faculty VALUES 
('DN01', 'Peter', 'Mark', '123456'), 
('DN02', 'Victor', 'Gomez', '123467'), 
('DN03', 'Young', 'Lee', '123468')

GO
INSERT INTO Department VALUES 
('L004', 'EEE'), ('L023', 'CSC')

GO
INSERT INTO Course VALUES 
('C001', 'PPT'), ('C002', 'UML'), ('C003', 'SQL'), ('C004', 'C#'), ('C005', 'XML')

GO
INSERT INTO Hire VALUES 
('DN01', 'L004', 'C001', '2019-08-1'), 
('DN02', 'L023', 'C002','2019-07-01')
GO

--------------------------- [Q.No. 03 (Dlete Query)]
DELETE FROM Course WHERE CourseID = 'C006'
GO

--------------------------- [Q.No. 04 (Update Query)]
UPDATE Course SET CourseName = 'CSharp' WHERE CourseID = 'C004';
GO