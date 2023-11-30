CREATE DATABASE lianxi;
USE lianxi;
CREATE TABLE book
(
    bookId   INT          NOT NULL PRIMARY KEY,
    bookName VARCHAR(30)  NOT NULL DEFAULT'',
    author   VARCHAR(30)  NOT NULL DEFAULT'' ,
    price    FLOAT(8,2)   NOT NULL DEFAULT 0,
    notes    VARCHAR(100)
);
