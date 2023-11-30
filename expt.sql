-- Create a new database called 'DbQuestionnaire'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
FROM sys.databases
WHERE name = N'DbQuestionnaire'
)
CREATE DATABASE DbQuestionnaire
GO

USE DbQuestionnaire
GO

-- Create a new table called 'UserInfo' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.UserInfo', 'U') IS NOT NULL
DROP TABLE dbo.UserInfo
GO
-- Create the table in the specified schema
CREATE TABLE dbo.UserInfo
(
    UserId   INT         NOT NULL PRIMARY KEY,
    -- primary key column
    UserName VARCHAR(20) NOT NULL,
    UserSex  CHAR(6)     CHECK (UserSex = 'Female' OR UserSex = 'Male'),
    UserAge  INT         CHECK (UserAge >= 0 AND UserAge<=150)
    -- specify more columns here
);
GO

-- Create a new table called 'Questionnaire' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Questionnaire', 'U') IS NOT NULL
DROP TABLE dbo.Questionnaire
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Questionnaire
(
    QuestionnaireId   INT          NOT NULL PRIMARY KEY,
    -- primary key column
    Tilte             VARCHAR(200) NOT NULL,
    DesignerID        INT          NOT NULL,
    StartTime         VARCHAR(50)  NOT NULL,
    EndTime           VARCHAR(50)  NOT NULL,
    QuestionnaireLink VARCHAR(500) NOT NULL
    -- specify more columns here
);
GO

-- Create a new table called 'Question' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Question', 'U') IS NOT NULL
DROP TABLE dbo.Question
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Question
(
    QuestionId     INT          NOT NULL PRIMARY KEY,
    -- primary key column
    QuesionnaireID INT          NOT NULL,
    Stem           VARCHAR(200) NOT NULL,
    QuestionType   CHAR(6)      CHECK (QuestionType = 'Multi' OR QuestionType = 'Single') NOT NULL,
    Options        VARCHAR(200) NOT NULL,
    Result         VARCHAR(10) ,
    isDone         CHAR(1)      CHECK(isDone = '1' OR isDone = '0')
    -- specify more columns here
);
GO

-- Insert rows into table 'dbo.UserInfo'
INSERT INTO dbo.UserInfo
    ( -- columns to insert data into
    [UserId], [UserName], [UserAge],[UserSex]
    )
VALUES
    (2019011166, 'Primimy', 21, 'Male'),
    (2019011160, 'ZiBaociGuai', 21, 'Male'),
    (2019011176, 'ShiQi', 21, 'Male')
-- add more rows here
GO

-- Insert rows into table 'dbo.Questionnaire'
INSERT INTO dbo.Questionnaire
    ( -- columns to insert data into
    [QuestionnaireId], [Tilte], [DesignerID], [StartTime], [EndTime], [QuestionnaireLink]
    )
VALUES
    (0000001, 'Final Examination Scores', 2019011166, '2021-06-11', '2021-06-12', 'https://primimy.noip.cn/dbQuestionnaire/0000001.html')
-- add more rows here
GO


-- Insert rows into table 'dbo.Question'
INSERT INTO dbo.Question
    ( -- columns to insert data into
    [QuestionId], [QuesionnaireID], [Stem], [QuestionType], [Options], [Result], [isDone]
    )
VALUES
    (770001, 0000001, 'Lesson:database score > 90?', 'Single', 'A. True;; B.False', 'A', '1')
-- add more rows here
GO
-- clean Databases
-- DROP TABLE Questionnaire,Question,UserInfo