-- Create a new database called 'WorkspaceDB1'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
FROM sys.databases
WHERE name = N'WorkspaceDB1'
)
CREATE DATABASE WorkspaceDB1
GO

USE WorkspaceDB1
GO

-- Create a new table called 'Student' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Student', 'U') IS NOT NULL
DROP TABLE dbo.Student
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Student
(
    Sno   CHAR(10)    PRIMARY KEY,
    Sname VARCHAR(30) NOT NULL,
    Ssex  CHAR(2)     CHECK(Ssex = '男' OR Ssex = '女'),
    Sage  INT         CHECK (Sage >=10 AND Sage <=60),
    Sdept VARCHAR(20)
);
GO

-- Create a new table called 'Course' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Course', 'U') IS NOT NULL
DROP TABLE dbo.Course
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Course
(
    Cno      CHAR(4)     PRIMARY KEY,
    Cname    VARCHAR(20) NOT NULL,
    Credit   INT         NOT NULL,
    Semester INT         NOT NULL,
    Ctype    VARCHAR(10) NOT NULL
);
GO

-- Create a new table called 'SC' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.SC', 'U') IS NOT NULL
DROP TABLE dbo.SC
GO
-- Create the table in the specified schema
CREATE TABLE dbo.SC
(
    Sno   CHAR(10) NOT NULL,
    Cno   CHAR(4)  NOT NULL,
    Grade TINYINT  CHECK(Grade >=0 AND Grade <=100),
    PRIMARY KEY(Sno,Cno),
    CONSTRAINT FK_Sno FOREIGN KEY (Sno)
    REFERENCES dbo.Student(Sno),
    CONSTRAINT FK_Cno FOREIGN KEY (Cno)
    REFERENCES dbo.Course(Cno)
);
GO

-- Insert rows into table 'Student'
INSERT INTO Student
    ( -- columns to insert data into
    [Sno], [Sname], [Ssex],[Sage],[Sdept]
    )
VALUES
    ('2018111001', '李勇', '男', 21, '计算机系'),
    ('2018111002', '刘晨', '男', 20, '计算机系'),
    ('2018211003', '王敏', '女', 20, '计算机系'),
    ('2018211004', '张小红', '女', 19, '计算机系'),
    ('2018211001', '张立', '男', 20, '信息管理系'),
    ('2018211002', '吴宾', '女', 19, '信息管理系'),
    ('2018311004', '张海', '男', 20, '通信工程系'),
    ('2018311001', '钱小平', '女', 21, '通信工程系'),
    ('2018311002', '王大力', '男', 20, '通信工程系'),
    ('2018311003', '张姗姗', '女', 19, '通信工程系')
GO

-- Insert rows into table 'Course'
INSERT INTO Course
    ( -- columns to insert data into
    [Cno],[Cname],[Credit],[Semester],[Ctype]
    )
VALUES
    ('C001', '高等数学', 4, 1, '必修'),
    ('C002', '大学英语', 3, 1, '必修'),
    ('C003', '大学英语', 3, 2, '必修'),
    ('C004', '计算机文化学', 2, 2, '选修'),
    ('C005', 'VB', 2, 3, '选修'),
    ('C006', '数据库系统原理与应用', 4, 5, '必修'),
    ('C007', '数据结构', 4, 4, '必修'),
    ('C008', '计算机网络', 4, 4, '必修')
-- add more rows here
GO

-- Insert rows into table 'SC'
INSERT INTO SC
    ( -- columns to insert data into
    [Sno],[Cno],[Grade]
    )
VALUES
    ('2018111001', 'C001', 96),
    ('2018111001', 'C002', 80),
    ('2018111001', 'C003', 84),
    ('2018111001', 'C005', 62),
    ('2018111002', 'C001', 92),
    ('2018111002', 'C002', 90),
    ('2018111002', 'C004', 84),
    ('2018211002', 'C001', 76),
    ('2018211002', 'C004', 85),
    ('2018211002', 'C005', 73),
    ('2018211002', 'C007', NULL),
    ('2018211003', 'C001', 50),
    ('2018211003', 'C004', 80),
    ('2018311001', 'C001', 55),
    ('2018311001', 'C004', 80),
    ('2018311002', 'C007', NULL),
    ('2018311003', 'C004', 78),
    ('2018311003', 'C005', 65),
    ('2018311003', 'C007', NULL)
-- add more rows here
GO


SELECT DISTINCT Student.Sno
FROM Student JOIN Sc ON Student.Sno=SC.Sno
WHERE Student.Sno  LIKE '201%'
GROUP BY Student.Sno
HAVING Student.Sno IS NOT NULL
GO

UPDATE Student
SET Ssex =
CASE WHEN Sname IN
(SELECT Sname
FROM student
WHERE Ssex='男')
THEN '女'
ELSE '男'
END
GO

SELECT *
FROM student
GO



CREATE PROCEDURE Qxx
    @i CHAR
AS
SELECT Sname
FROM Student
WHERE Sno LIKE @i
RETURN 1
GO

DECLARE @resE INT
EXECUTE  @resE=Qxx '2018%'
PRINT @resE
GO

CREATE VIEW myView
AS
    SELECT *
    FROM student
GO

SELECT *
FROM myView
GO
-- clean Database
ALTER TABLE SC
DROP CONSTRAINT FK_Sno
ALTER TABLE SC DROP CONSTRAINT FK_Cno
DROP TABLE SC,Student,Course
DROP PROCEDURE Qxx
DROP VIEW myView