--Exercise 02 ---
DROP TABLE likes; 
CREATE TABLE LIKES (NAME varchar(14), FRUITS varchar(14));
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
SELECT FRUITS from likes where name = 'Winnie';
--2. List the fruits that Winnie doesn't like but someone else does.
-- subtract Winnie's fruits from all fruits---
SELECT FRUITS from likes minus (SELECT FRUITS from likes where name= 'Winnie');
--3. Who likes apple?--
SELECT name from likes where fruits = 'apple';
--4.List those names who doesn't like pear but like something else.
SELECT name from likes minus (select name from likes where fruits='pear');
SELECT name FROM likes
 MINUS
SELECT name FROM likes WHERE fruits = 'pear';
--5. Who likes raspberry or pear? --
SELECT DISTINCT NAME FROM likes where fruits = 'raspberry' or fruits = 'pear';
--相同的被合并了
SELECT name FROM likes WHERE fruits = 'raspberry'
 UNION
SELECT name FROM likes WHERE fruits = 'pear';
--6. Who likes both apple and pear?--
SELECT name FROM likes where fruits = 'apple';
Intersect 
SELECT name FROM likes where fruits = 'pear';

--7. Who likes apple but doesn't like pear? --
SELECT name FROM likes where fruits = 'apple'
minus
SELECT name FROM likes where fruits = 'pear'

SELECT name FROM likes WHERE fruits = 'apple'
 MINUS
SELECT name FROM likes WHERE fruits = 'pear';

--8.  List the names who like at least two different fruits.
SELECT NAME FROM (SELECT name,Count(*) from Likes Group by name HAVING Count(*) > 1);

-- Cartesian product
SELECT DISTINCT l1.name FROM likes l1, likes l2 
WHERE l1.name=l2.name AND l1.fruits <> l2.fruits;

--9.  List the names who like at least three different fruits.
SELECT NAME FROM (SELECT name,Count(*) from Likes Group by name HAVING Count(*) > 2);

-- one more Cartesian product
SELECT DISTINCT l1.name FROM likes l1, likes l2, likes l3 
WHERE l1.name=l2.name AND l2.name=l3.name AND l1.fruits <> l2.fruits
AND l2.fruits <> l3.fruits AND l1.fruits <> l3.fruits;

--10. List the names who like at most two different fruits.
SELECT NAME FROM (SELECT name,Count(*) from Likes Group by name HAVING Count(*) <= 2);

SELECT name FROM likes
 MINUS
SELECT DISTINCT l1.name FROM likes l1, likes l2, likes l3 
WHERE l1.name=l2.name AND l2.name=l3.name AND l1.fruits <> l2.fruits
AND l2.fruits <> l3.fruits AND l1.fruits <> l3.fruits;

--11. List the names who like exactly two different fruits.
SELECT NAME FROM (SELECT name,Count(*) from Likes Group by name HAVING Count(*) = 2);

SELECT DISTINCT l1.name FROM likes l1, likes l2 
WHERE l1.name=l2.name AND l1.fruits <> l2.fruits
 MINUS
SELECT DISTINCT l1.name FROM likes l1, likes l2, likes l3 
WHERE l1.name=l2.name AND l2.name=l3.name AND l1.fruits <> l2.fruits
AND l2.fruits <> l3.fruits AND l1.fruits <> l3.fruits;

-----------------------------------------------------------------------------------------------
--17. Give the names of employees who are managers of someone, but whose job is not 'MANAGER'.
SELECT DISTINCT E1.ENAME FROM nikovits.emp E1,nikovits.emp E2 
where  E1.EMPNO = E2.MGR and E1.Job <> 'MANAGER'

SELECT DISTINCT e1.ename, e1.job FROM nikovits.emp e1, nikovits.emp e2 
WHERE e1.empno = e2.mgr AND e1.job <> 'MANAGER';

--18. List the names of employees who has greater salary than his manager.--
SELECT e1.ename from nikovits.emp e1, nikovits.emp e2 
where e1.mgr = e2.empno and e1.sal > e2.sal


SELECT DISTINCT e2.ename, e2.sal, e1.sal mgr_sal FROM nikovits.emp e1, nikovits.emp e2 
WHERE e1.empno = e2.mgr AND e1.sal < e2.sal;

--19. List the employees whose manager's manager is KING.--
SELECT DISTINCT e1.ename from nikovits.emp e1, nikovits.emp e2 , nikovits.emp e3
where 
e1.mgr = e2.empno and e2.mgr = e3.empno AND e3.ename = 'KING'

SELECT e3.ename FROM nikovits.emp e1, nikovits.emp e2 , nikovits.emp e3
WHERE e1.empno = e2.mgr AND e2.empno = e3.mgr AND e1.ename='KING';

--20. List the employees whose department's location is DALLAS or CHICAGO?
--21. List the employees whose department's location is not DALLAS and not CHICAGO?
SELECT * from nikovits.dept
select * from nikovits.emp

select ename from nikovits.emp emp,nikovits.dept
where
emp.deptno = dept.deptno and dept.LOC not in ('DALLAS','CHICAGO')

SELECT ename, loc FROM nikovits.emp e, nikovits.dept d 
WHERE e.deptno = d.deptno AND loc NOT IN ('DALLAS', 'CHICAGO');

--22. List the employees whose salary is greater than 2000 or work on a department in CHICAGO.
select ename from nikovits.emp e, nikovits.dept d
where e.sal > 2000 or e.deptno = d.deptno and d.loc = 'CHICAGO'
--23. Which department has no employees?
select d.deptno from  nikovits.dept d
minus
select DISTINCT e.deptno from nikovits.emp e

SELECT deptno FROM nikovits.dept
 MINUS
SELECT deptno FROM nikovits.emp;

--24. List the employees who has a subordinate whose salary is greater than 2000.--
select DISTINCT e2.ename from nikovits.emp e1,nikovits.emp e2
where
e1.mgr = e2.empno and e1.sal > 2000

--25. List the employees who doesn't have a subordinate whose salary is greater than 2000.-
select DISTINCT e2.ename from nikovits.emp e1,nikovits.emp e2
where e1.mgr = e2.empno 
minus
select DISTINCT e2.ename from nikovits.emp e1,nikovits.emp e2
where
e1.mgr = e2.empno and e1.sal > 2000

--26. List the department names and locations where there is an employee with job ANALYST.--
select DISTINCT d.dname,d.loc from nikovits.emp e, nikovits.dept d
where 
e.deptno = d.deptno and e.job = 'ANALYST' 

--27. List the department names and locations where there is no employee with job ANALYST.
select DISTINCT d.dname,d.loc from  nikovits.dept d
minus
select DISTINCT d.dname,d.loc from nikovits.emp e, nikovits.dept d
where 
e.deptno = d.deptno and e.job = 'ANALYST' 

--28. Give the name(s) of employees who have the greatest salary. (rel. alg + SQL)--
select e.ename from nikovits.emp e where e.sal = (select sal from (select sal from nikovits.emp e order by sal desc) where rownum = 1);

SELECT ename FROM nikovits.emp
 MINUS
SELECT e1.ename FROM nikovits.emp e1, nikovits.emp e2 WHERE e1.sal < e2.sal;








