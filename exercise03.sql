create table emp as select * from nikovits.emp;
create table dept as select * from nikovits.dept;
--1. List the employees whose salary is divisible by 15.
select ename,sal from emp where mod(sal,15) = 0;
--2. List the employees, whose hiredate is greater than 1982.01.01.
select ename,hiredate from emp where hiredate > to_date('1982.01.01','yyyy-mm-dd');
--3. List the employees where the second character of his name is 'A'.
select ename from emp where substr(ename,2,1) = 'A';
--4. List the employees whose name contains two 'L'-s. (use some built-in function)
select ename from emp where instr(ename,'L',1,2) != 0 ;
SELECT ename FROM emp WHERE instr(ename,'L', 1, 2) > 0;
--5. List the last 3 characters of the employees' names.
select ename,substr(trim(ename),-3) from emp;
--6. List the emloyees whose name has a 'T' in the last but one position. (position before the last)
select ename from emp where  substr(ename,-2,1) = 'T';
--7. List the square root of the salaries rounded to 2 decimals and the integer part of it.
select sal, round(sqrt(sal),2), round(sqrt(sal),0) from emp;
select sal, round(sqrt(sal),2), trunc(round(sqrt(sal),2)) from emp;
SELECT round(sqrt(sal), 2), trunc(round(sqrt(sal), 2), 0)  FROM emp;
--8. In which month was the hiredate of ADAMS? (give the name of the month)
select extract(month from hiredate) month from emp where ename = 'ADAMS';
--9. Give the number of days since ADAMS's hiredate. 
select trunc (SYSDATE - hiredate) from emp where ename= 'ADAMS';
SELECT hiredate, trunc(sysdate - hiredate), to_char(hiredate, 'Month')  
FROM emp WHERE ename = 'ADAMS';
--10. List the employees whose hiredate was Tuesday. (Take care of the length of name_day string!)
Select  ename ,hiredate from emp where trim(to_char(hiredate,'day','NLS_DATE_LANGUAGE=AMERICAN')) ='tuesday';
Select  trim(to_char(hiredate,'day','NLS_DATE_LANGUAGE=AMERICAN')) from emp;
alter session set nls_date_language='english';
SELECT ename, hiredate FROM emp WHERE to_char(hiredate, 'day') LIKE 'tuesday%';
--11. Give the manager-employee name pairs where the length of the two names are equal.
select e1.ename,e2.ename mgr_name  from emp e1, emp e2 where e1.mgr = e2.empno and length(e1.ename) = length(e2.ename);

SELECT e1.ename mgr_name, e2.ename
FROM emp e1, emp e2 
WHERE e1.empno = e2.mgr and length(e1.ename) = length(e2.ename);

--12. List the employees whose salary is in category 1. (see Sal_cat table)
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

select ename,sal from emp where sal >= (select lowest_sal from sal_cat where category = 1) and sal <= (select highest_sal from sal_cat where category = 1);

SELECT ename, category FROM emp, sal_cat
WHERE sal BETWEEN lowest_sal AND highest_sal AND category=1;

--13. List the employees whose salary category is an even number.
select ename , category from emp , sal_cat 
where sal between lowest_sal and highest_sal and  mod(category,2) =0

SELECT ename, category FROM emp, sal_cat
WHERE sal BETWEEN lowest_sal AND highest_sal AND mod(category,2)=0;

--14. Give the number of days between the hiredate of KING and the hiredate of JONES.
select (select hiredate from emp where ename = 'KING') - (select hiredate from emp where ename = 'JONES') days from dual;

SELECT k.hiredate - j.hiredate FROM emp k, emp j 
WHERE k.ename='KING' AND j.ename='JONES';

--15. Give the name of the day (e.g. Monday) which was the last day of the month in which KING's hiredate was.
alter session set nls_date_language='english';
select to_char(last_day(hiredate),'day') from emp where ename = 'KING';

--16. Give the name of the day (e.g. Monday) which was the first day of the month in which KING's hiredate was.
alter session set nls_date_language='english';
select to_char(trunc((hiredate),'mm'),'day') from emp where ename = 'KING';
--17. Give the names of employees whose department name contains a letter 'C' and whose salary category is >= 4.
select ename,dname,sal,category from emp,dept,sal_cat where emp.deptno = dept.deptno and INSTR(DNAME,'C',1,1)>0 and sal between lowest_sal and highest_sal and category >=4;

SELECT ename, dname, category FROM emp e, dept d, sal_cat sc
WHERE sal BETWEEN lowest_sal AND highest_sal AND e.deptno = d.deptno
AND dname LIKE '%C%' AND category >= 4;

--18. List the name and salary of the employees, and a charater string where one '#' denotes 1000 (rounded)
select rpad('#',round(sal,-3)/1000,'#'),sal from emp;
SELECT ename, sal, rpad('#', round(sal, -3)/1000, '#') FROM emp;
