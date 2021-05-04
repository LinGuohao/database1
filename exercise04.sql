--1.  Give the maximal salary. [max_sal]
select ename,sal max_sal from (select * from emp order by sal desc)  where rownum = 1;

--2.  Give the sum of all salaries. [sum_sal]
select sum(sal) sum_sal from emp;
--3.  Give the summarized salary and average salary on department 20. [sum_sal, avg_sal]
select sum(sal) sum_sal, avg(sal) avg_sal from emp,dept where emp.deptno = dept.deptno and dept.deptno = 20;
--4.  How many different jobs do we have in the emp table? [num_jobs]
select Count(DISTINCT job) num_jobs from emp;
--5.  Give the number of employees whose salary is greater than 2000. [num_emps]
select count(ename) num_emps from emp where sal > 2000;
--6.  Give the average salary by departments. [deptno, avg_sal]
select deptno, avg(sal) from emp group by deptno;
--7.  Give the location and average salary by departments. [deptno, loc, avg_sal]
select ans.deptno deptno,loc,avg_sal from (select deptno, avg(sal) avg_sal from emp group by deptno) ans , dept where ans.deptno = dept.deptno ;

select * from emp join dept on emp.deptno = dept.deptno ;
(select * from emp,dept where emp.deptno = dept.deptno);

--8.  Give the number of employees by departments. (deptno, num_emp)
select deptno,count(ename) num_emp from EMP group by deptno;
SELECT deptno, count(empno) FROM emp GROUP BY deptno;

--9.Give the average salary by departments where this average is greater than 2000. (deptno, avg_sal)
select deptno ,avg(sal)from emp group by deptno having avg(sal) > 2000;
SELECT deptno, avg(sal) FROM emp GROUP BY deptno HAVING avg(sal) > 2000;

--10.  Give the average salary by departments where the department has at least 4 employees. (deptno, avg_sal)
select deptno,avg(sal) avg_sal from emp group by deptno having count(ename) >= 4;
SELECT deptno, avg(sal) FROM emp GROUP BY deptno HAVING count(empno) >= 4;

--11.  Give the average salary and location by departments where the department has at least 4 employees.
select avg(sal),loc  from dept natural join emp group by deptno,loc having count(ename) >=4;

SELECT d.deptno, loc, avg(sal) FROM emp e, dept d
WHERE d.deptno=e.deptno 
GROUP BY d.deptno, loc HAVING count(empno) >= 4;

--12. Give the name and location of departments where the average salary is greater than 2000. (dname, loc)
select dname,loc,avg(sal) from dept natural join emp group by dname,loc having avg(sal) > 2000;

SELECT dname, loc FROM emp d, dept o
WHERE d.deptno=o.deptno 
GROUP BY dname, loc HAVING avg(sal) >= 2000;

--13. Give the salary categories where we can find exactly 3 employees.
select CATEGORY from emp , sal_cat where sal between LOWEST_SAL AND HIGHEST_SAL GROUP BY CATEGORY HAVING COUNT(ENAME)=3 ;

SELECT category FROM emp, sal_cat
WHERE sal BETWEEN lowest_sal AND highest_sal
GROUP BY category HAVING count(*) = 3;

SELECT category FROM emp JOIN sal_cat ON (sal BETWEEN lowest_sal AND highest_sal)
GROUP BY category HAVING count(*) = 3;

--14.  Give the salary categories where the employees in this category work on the same department.
SELECT category FROM emp JOIN sal_cat ON (sal BETWEEN lowest_sal AND highest_sal) group by category having count(DISTINCT deptno)=1;

SELECT category FROM emp, sal_cat
WHERE sal BETWEEN lowest_sal AND highest_sal
GROUP BY category HAVING count(distinct deptno) = 1;



