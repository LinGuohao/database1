drop table emp;
create table emp as select * from NIKOVITS.EMP;
drop table dept;
create table dept as select * from NIKOVITS.DEPT;
drop table sal_cat;
CREATE TABLE Sal_cat
 (category NUMERIC, 
  lowest_sal NUMERIC, 
  highest_sal NUMERIC
);
insert into Sal_cat values(1,700,1200);
insert into Sal_cat values(2,1201,1400);
insert into Sal_cat values(3,1401,2000);
insert into Sal_cat values(4,2001,3000);
insert into Sal_cat values(5,3001,9999);

drop table likes;
create table likes as select * from NIKOVITS.Likes;
--1
-- List the department number, department name and location for the departments having an 
-- employee with salary category 1. (deptno, dname, loc)
select deptno,dname,loc from emp natural join dept join sal_cat on (sal between lowest_sal and highest_sal) where category = 1 group by deptno,dname,loc having count(category) = 1;

--2
--2.List the department number, department name and location for the departments havingnoemployee with salary category 1. (deptno, dname, loc)
select deptno,dname,loc from dept
minus
select deptno,dname,loc from emp natural join dept join sal_cat on (sal between lowest_sal and highest_sal) where category = 1 group by deptno,dname,loc;

--3.List the department number, department name and location for the departments having at least two employeeswith salary category 1. (deptno, dname, loc)
select deptno,dname,loc from emp natural join dept join sal_cat on (sal between lowest_sal and highest_sal) where category = 1 group by deptno,dname,loc having count(category)>=2;

--4.List the employees who have maximal salary within their own department. Give the department number, employee name and salary for them. (deptno, ename, sal) 
select e1.deptno,e1.ename,e1.sal from emp e1 join emp e2 on (e1.deptno = e2.deptno) 
minus
select e1.deptno,e1.ename,e1.sal from emp e1 join emp e2 on (e1.deptno = e2.deptno) where e1.sal < e2.sal;

--5.List the jobs where this job occurs only on one department and give the name of this department too. (job, dname)
select DISTINCT job, deptno from (select job from (select job,dname from emp natural join dept group by job,dname) group by job having count(job)=1) natural join  emp;

--6 Give the names who like every fruit.(name)(see Likes(name, fruits)relation)
select name from likes
minus
(select name from 
(select DISTINCT name , fruits from (select name from likes) , (select  DISTINCT fruits from likes )
minus
select name,fruits from likes));

--7.Give the salary and salary category of the employees who have the lowest salary among the employees having a subordinate. (sal, category)
select sal ,category from (select MIN(sal) sal from ((select DISTINCT mgr empno from emp) NATURAL join emp)),sal_cat where sal between LOWEST_SAL AND HIGHEST_SAL;

SELECT minsal, category FROM sal_cat,
(SELECT MIN(sal) AS minsal 
FROM emp NATURAL JOIN (SELECT mgr AS empno FROM emp)) tmp
WHERE tmp.minsal BETWEEN lowest_sal AND highest_sal;

(SELECT MIN(sal) AS minsal 
FROM emp NATURAL JOIN (SELECT mgr AS empno FROM emp));

--8.(only SQLbecause relational algebra doesn¡¯t have built in functions)Give the month names (January, February etc.) in which at least two employees started to work (hiredate shows the start of work)and give the number of such employees by month. (Month_name, Num_emps)
alter session set nls_date_language='english';
select to_char(hiredate,'Month') Month_name, count(ename) from emp group by (to_char(hiredate,'Month')) having count(ename)>=2;

SELECT to_char(hiredate, 'Month') Month_name, 
 COUNT(distinct empno) Num_emps
FROM emp 
GROUP BY to_char(hiredate, 'Month')
HAVING COUNT(empno) >=2;