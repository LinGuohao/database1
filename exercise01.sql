/* Exercise 01 */

CREATE TABLE "EMP"                     -- creates an empty table
   (	
    "EMPNO" NUMBER(4,0),           -- employee number, unique identifier of an employee  //NUMERIC(p,s)	精确数值，精度 p，小数点后位数 s。（与 DECIMAL 相同）
	"ENAME" VARCHAR2(30 BYTE),     -- employee name
	"JOB" VARCHAR2(27 BYTE),       -- job
	"MGR" NUMBER(4,0),             -- manager's employee number
	"HIREDATE" DATE,               -- start date, when emloyee entered to work
	"SAL" NUMBER(7,2),             -- salary
	"COMM" NUMBER(7,2),            -- commission
	"DEPTNO" NUMBER(2,0)           -- department number of employee's department
   );       

drop table Emp;

create table emp0 as select * from nikovits.emp;
--1.  List the employees whose salary is greater than 2800--
select ENAME from emp0 where SAL > 2800;
--2.  List the employees working on department 10 or 20.--
select ENAME from emp0 where DEPTNO = 10 or DEPTNO = 20;
--3.  List the employees whose commission is greater than 600.--
select ENAME from emp0 where COMM > 600;
--4.  List the employees whose commission is NOT greater than 600.--
select ENAME from emp0 where COMM <= 600;
--5.  List the employees whose commission is not known (that is NULL).--
select ENAME from emp0 where COMM is null;
--6.  List the jobs of the employees (with/without duplication)--
select JOB from emp0;
select distinct job from emp0;
--7.  Give the name and double salary of employees working on department 10. --
select ENAME,SAL*2 from emp0 where DEPTNO = 10; 
--8.  List the employees whose hiredate is greater than 1982.01.01.--
select ENAME from emp0 where HIREDATE > to_date('1982-01-01','yyyy.mm.dd');
--9.  List the employees who doesn't have a manager--
select ENAME from emp0 where MGR is null;
--10. List the employees whose name contains a letter 'A'.--
select ENAME from emp0 where ENAME like '%A%';
--11. List the employees whose name contains two letters 'L'.--
select ENAME from emp0 where ENAME like '%L%L%';
--12. List the employees whose salary is between 2000 and 3000.--
select ENAME from emp0 where SAL >=2000 and SAL <= 3000;
--13. List the name and salary of employees ordered by salary.--
select ENAME,SAL from emp0 order by sal;
--14. List the name and salary of employees ordered by salary in descending order and within that order, ordered by name in ascending order.--
select ENAME,SAL from emp0 order by sal desc , ENAME asc;
--15. List the employees whose manager is KING. (reading empno of KING from monitor)--
select ENAME from emp0 where MGR= 7839;
--16. List the employees whose manager is KING. (without reading from monitor)--
select ENAME from emp0 where MGR = (select EMPNO from emp0 where ENAME = 'KING');



---new---
CREATE TABLE LIKES (NAME varchar(14), FRUITS varchar(14));
-- Insert rows into the table.

   insert into LIKES values ('Piglet','apple');
   insert into LIKES values ('Piglet','pear');
   insert into LIKES values ('Piglet','raspberry');
   insert into LIKES values ('Winnie','apple');
   insert into LIKES values ('Winnie','pear');
   insert into LIKES values ('Kanga','apple');
   insert into LIKES values ('Tiger','apple');
   insert into LIKES values ('Tiger','pear');
grant select on LIKES to public;
SELECT * FROM likes; 
--1. List the fruits that Winnie likes.--
select fruits from likes where name = 'Winnie';
--2. List the fruits that Winnie doesn't like but someone else does.--
select fruits from likes minus (select fruits from likes where name = 'Winnie');
--3. Who likes apple?--
select name from likes where fruits = 'apple';
--4. List those names who doesn't like pear but like something else.--
SELECT name FROM likes MINUS SELECT name FROM likes WHERE fruits = 'pear';
--5. Who likes raspberry or pear? --
SELECT DISTINCT name from likes where fruits = 'raspberry' or fruits = 'pear';
SELECT name FROM likes WHERE fruits = 'raspberry'
 UNION
SELECT name FROM likes WHERE fruits = 'pear';
--6. Who likes both apple and pear? --
select name from likes where fruits = 'apple' INTERSECT select name from likes where fruits = 'pear';

SELECT name FROM likes WHERE fruits = 'apple'
 INTERSECT
SELECT name FROM likes WHERE fruits = 'pear';
--7. Who likes apple but doesn't like pear? --
select name from likes where fruits ='apple' minus select name from likes where fruits = 'pear';

SELECT name FROM likes WHERE fruits = 'apple'
 MINUS
SELECT name FROM likes WHERE fruits = 'pear';
