-- 1.1 普通表
CREATE TABLE TABLE1 (
    Column1 VARCHAR2(255) NOT NULL,
    Column2 VARCHAR2(1024),
    Column3 NUMBER(3)
);

-- 1.2 分区表
CREATE TABLE tableRange(pid NUMBER(10), pname VARCHAR2(30)) PARTITION BY RANGE(pid)(
    PARTITION p1
    VALUES
        less than(100) tablespace tetstbs1,
        PARTITION p2
    VALUES
        less than(200) tablespace tetstbs2,
        PARTITION p3
    VALUES
        less than(maxvalue) tablespace tetstbs3
) enable ROW movement;

-- 1.3 聚簇表
CREATE CLUSTER clusterX(id INT);

CREATE TABLE tab_cluster1(
    id INT primary key,
    NAME VARCHAR2(30)
) CLUSTER clusterX(id);

-- 1.4 虚拟列
CREATE TABLE inv(
    inv_id NUMBER,
    inv_count NUMBER,
    inv_status generated always AS(
        CASE
            WHEN inv_count <= 100 THEN 'GETTING LOW'
            WHEN inv_count > 100 THEN 'OKAY'
        END
    )
);

-- 2 (唯一)索引
CREATE UNIQUE INDEX index1 ON TABLE1(Column1, Column2);

-- 3 视图
--Create a new Relational View
CREATE VIEW VIEW1 AS
SELECT
    *
FROM
    TABLE1;

-- 4 触发器
CREATE OR REPLACE TRIGGER TABLE1TRIGGER1
  before INSERT or update ON TABLE1
  FOR EACH ROW
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Operation Done!');
  END;
/

INSERT INTO
    TABLE1(Column1, Column2, Column3)
VALUES
    ('1', '1', 1);

-- 5 存储过程
CREATE PROCEDURE PROCEDURE1 AS
CURSOR c1 IS SELECT * from table1;
BEGIN
    for item in c1 LOOP
    dbms_output.put_line(item.Column1);
    END LOOP;
END PROCEDURE1;
/

-- 6 函数
create or replace function printSum(
    startN in number,
    endN in number
) return number IS
BEGIN
return (startN+endN)/2;
END;
/

BEGIN
DBMS_OUTPUT.PUT_LINE(printSum(1,10));
END;
/

-- 7 建立用户并授权, 撤销
create user userDba identified by 1111;
create user uesrConnect identified by 1111;
grant dba to userDba;
grant connect to userConnect;
revoke dba from userDba;
revoke connect rom userConnect;

-- 清除
DROP TABLE TABLE1;

DROP TABLE tableRange;

DROP CLUSTER clusterX INCLUDING tables;

DROP TABLE inv;

DROP INDEX index1;

DROP VIEW view1;

DROP TRIGGER TABLE1TRIGGER1;

drop procedure procedure1;

drop function printSum;

drop user userDba;

drop user userConnect;