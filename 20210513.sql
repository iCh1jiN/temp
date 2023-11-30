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

-- Question 1
-- Create a new view called 'V1_COMPUTER_MALE' in schema 'dbo'
-- Drop the view if it already exists
IF EXISTS (
SELECT *
FROM sys.views
    JOIN sys.schemas
    ON sys.views.schema_id = sys.schemas.schema_id
WHERE sys.schemas.name = N'dbo'
    AND sys.views.name = N'V1_COMPUTER_MALE'
)
DROP VIEW dbo.V1_COMPUTER_MALE
GO
-- Create the view in the specified schema
CREATE VIEW dbo.V1_COMPUTER_MALE
AS
    -- body of the view
    SELECT Student.Sno,
        Student.Sname,
        Student.Sage,
        Student.Sdept,
        SC.Cno,
        Course.Cname
    FROM dbo.student, dbo.SC, dbo.Course
    WHERE Student.Sno=SC.Sno AND Course.Cno=SC.Cno
GO
-- Select rows from a Table or View 'V1_COMPUTER_MALE' in schema 'dbo'
SELECT *
FROM dbo.V1_COMPUTER_MALE
GO

-- Question 2
SELECT DISTINCT Sname, Sno, Sage
FROM V1_COMPUTER_MALE
WHERE Sname LIKE '张%'

-- Question 3

-- display data before alter
SELECT Sname, Sage
FROM V1_COMPUTER_MALE
WHERE Sname LIKE '李%'

UPDATE V1_COMPUTER_MALE
SET Sage = Sage+
CASE WHEN Sname IN (SELECT DISTINCT Sname
FROM V1_COMPUTER_MALE
WHERE Sname LIKE '李%') THEN 1
ELSE 0
END

-- display result
SELECT Sname, Sage
FROM V1_COMPUTER_MALE
WHERE Sname LIKE '李%'

-- Question 4
-- Find an existing index named IDX_Cname and delete it if found.
IF EXISTS (SELECT name
FROM sys.indexes
WHERE name = N'IDX_CNAME')
    DROP INDEX IDX_CNAME ON dbo.Course;
GO
-- Create a nonclustered index called IDX_CNAME
-- on the dbo.Sourse table using the Cname column.
CREATE NONCLUSTERED INDEX IDX_CNAME
    ON dbo.Course (Cname);
GO

-- Question 5
IF OBJECT_ID('TRIGGER_UPDATE_SC_GRADE_PLUS10') IS NOT NULL
DROP TRIGGER TRIGGER_UPDATE_SC_GRADE_PLUS10
GO
CREATE TRIGGER TRIGGER_UPDATE_SC_GRADE_PLUS10
ON dbo.SC
AFTER UPDATE
AS IF EXISTS (SELECT *
FROM INSERTED i JOIN deleted d ON i.Sno=d.Sno AND i.Cno=d.Cno
WHERE i.Grade - d.Cno >= 10 )
ROLLBACK
GO

-- clean Database
ALTER TABLE SC
DROP CONSTRAINT FK_Sno
ALTER TABLE SC DROP CONSTRAINT FK_Cno
DROP INDEX IDX_CNAME ON dbo.Course
DROP TABLE SC,Student,Course
DROP VIEW V1_COMPUTER_MALE