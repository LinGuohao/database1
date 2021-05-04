CREATE TABLE emp2 AS SELECT * FROM nikovits.emp;
CREATE TABLE dept2 AS SELECT * FROM nikovits.dept;
CREATE TABLE sal_cat2 AS SELECT * FROM nikovits.sal_cat;

--1. Delete the employees whose commission is null.--
delete from emp where comm is null;
select * from emp;
--2. Delete the employees whose hiredate was before 1982.01.01.--
delete from emp where hiredate < to_date('1982.01.01','yyyy.mm.dd');
select * from emp;
--3. Delete the employees whose department's location is DALLAS.
delete from emp where deptno = (select deptno from dept where loc = 'DALLAS');
--4. Delete the employees whose salary is less than the average salary.
delete from emp where sal<(select avg(sal) from emp);
--5 Delete the employees whose salary is less than the average salary on his department.
drop table emp2;
CREATE TABLE emp2 AS SELECT * FROM nikovits.emp;
delete from emp2 e1 where e1.sal < (select avg(e2.sal) from emp e2 where e2.deptno = e1.deptno);  
DELETE FROM emp2 e1 WHERE sal < (SELECT AVG(sal) FROM emp WHERE deptno=e1.deptno);
--6. Delete the employee (employees) whose salary is the greatest.
delete from emp2 where sal =( select max(sal) from emp);
--7. Delete the departments which have an employee with salary category 2.
drop table emp2;
CREATE TABLE emp2 AS SELECT * FROM nikovits.emp;
delete from dept2 where deptno in (select DISTINCT deptno from (select * from (select * from emp2 natural join dept2),sal_cat2 where sal between lowest_sal and highest_sal)where category = 2);
--8.Delete the departments which have at least two employees with salary category 2.
drop table dept2;
CREATE TABLE dept2 AS SELECT * FROM nikovits.dept;
delete from dept2 where deptno = (select deptno from (select * from (select * from emp2 natural join dept2),sal_cat2 where sal between lowest_sal and highest_sal) where category =2 group by deptno having count(deptno)>=2);

--9. Insert a new employee with the following values:
--   empno=1, ename='Smith', deptno=10, hiredate=sysdate, salary=average salary in department 10.
--   All the other columns should be NULL.
--a) Insert the row with the 'VALUES' keyword
drop table emp2;
CREATE TABLE emp2 AS SELECT * FROM nikovits.emp;
INSERT INTO emp2(empno, ename, hiredate, sal, deptno) 
VALUES(1,'Smith', SYSDATE, (SELECT AVG(sal) FROM emp2 WHERE deptno=10),10);
select * from emp2;
--b) Insert the row with a SELECT query without 'VALUES' keyword.
INSERT INTO emp2(empno, ename, hiredate, sal, deptno) 
SELECT 1,'Smith', SYSDATE, AVG(sal), 10 FROM emp2 WHERE deptno=10;
select * from emp2;
--10. Increase the salary of the employees in department 20 with 20%.
update emp2 set sal = sal * 1.2 where deptno = 20;
--11. Increase the salary with 500 for the employees whose commission is NULL or whose 
    --salary is less than the average.
update emp2 set sal = sal + 500 where comm is null or sal < (select avg(sal) from emp2);

UPDATE emp SET sal = sal + 500 
WHERE comm IS NULL OR sal < ( SELECT AVG(sal) FROM emp);

--12. Increase the commission of all employees with the maximal commission.
    --If an employee has NULL commission, treat it as 0.
update emp2 set comm = nvl(comm,0) + (select max(comm) from emp2) ;
select * from emp2;

--13. Modify the name of the employee with the lowest salary to 'Poor'.
update emp2 set ENAME = 'Poor' where sal = (select min(sal) from emp2);
select * from emp2;
--14. Increase the commission of the employees with 3000, who has at least 2 direct subordinates.
    --If an employee has NULL commission, treat it as 0.
update emp2 set comm= nvl(comm,0) + 3000 where empno in( select mgr from emp2 group by mgr having count(mgr) >=2);

UPDATE emp SET comm=coalesce(comm,0)+3000 WHERE empno IN
  (SELECT mgr FROM emp GROUP BY mgr HAVING count(*) = 2);
--15. Increase the salary of those employees who has a subordinate. The increment is the minimal salary.
update emp2 set sal = sal+ (select min(sal) from emp2) where empno in (select DISTINCT mgr from emp2);

UPDATE emp SET sal = sal + (SELECT min(sal) from emp) 
WHERE empno IN (SELECT mgr FROM emp);

--16. Increase the salary of the employees who don't have a subordinate. The increment is
--    the average salary of their own department.

drop table emp2;
CREATE TABLE emp2 AS SELECT * FROM nikovits.emp;
update emp2 set sal =sal + (select avg(sal) from emp2)where empno in (select empno from emp2 where empno not in (select nvl(mgr,0) from emp2));

drop table emp;
CREATE TABLE emp AS SELECT * FROM nikovits.emp;
UPDATE emp e1 SET sal = sal + (SELECT avg(sal) FROM emp e2 WHERE e2.deptno = e1.deptno)
WHERE empno NOT IN (SELECT coalesce(mgr,0) FROM emp);









-------------------------------

create or replace PROCEDURE fib(n integer) IS
 v1  integer := 0;
 v2  integer := 1;
 v_next integer := 0;
BEGIN
  IF n <= 1 THEN v_next:=v1; ELSIF n=2 THEN v_next:=v2; END IF; 
  FOR i IN 3 .. n LOOP
    v_next := v1+v2;
    v1 := v2; v2 := v_next; 
  END LOOP;
  DBMS_OUTPUT. PUT_LINE(TO_CHAR(v_next));
END;
/

set serveroutput on
execute check_plsql('fib(50)');



create or replace FUNCTION prim(n integer) RETURN number IS
 ret_val NUMBER(1) := 1;
 v_limit NUMBER(38);
BEGIN
 IF n < 0 OR trunc(n) <> n THEN RETURN -1; END IF;
  v_limit := trunc(sqrt(n));
  FOR i IN 2..v_limit loop
  IF mod(n, i) = 0 THEN ret_val := 0; exit; END IF;
 END loop;
 RETURN ret_val;
END;
/