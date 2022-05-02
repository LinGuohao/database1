/*
Give the employees who have at least two subordinates who started to work on dates that have the 
same name (e.g. Monday, so the name of the days should be the same for the 2 subordinates.) For 
these employees give the name of the employee (that is the name of the manager), the name of the 
day, and the number of subordinates starting to work on this day. 
(Ename, Day_name, Count_of_emp)

*/


alter session set nls_date_language='english';
select ename , day_name ,Count_of_emp from (select mgr,day_name,count(*) Count_of_emp from (select empno, to_char(hiredate,'Day') day_name from emp) natural join emp group by mgr,day_name having count(*)>=2)tmp ,emp where tmp.mgr = emp.empno;
with tmp as
    (select mgr,day_name,count(*) Count_of_emp from (select empno, to_char(hiredate,'Day') day_name from emp) natural join emp group by mgr,day_name having count(*)>=2)
select ename ,day_name,Count_of_emp from tmp ,emp where tmp.mgr = emp.empno;



/*
Create a table EMP2 which has the same tuples as nikovits.EMP, then write an UPDATE statement
on this table which increases the salaries of the employees falling into salary category 2. (see 
nikovits.SAL_CAT table) The increment is the average salary of the employee's own department.
After the update, select the new average salary of the employees and give it too. (Avg_Sal)
*/

drop table emp2;
create table emp2 as select * from emp;

update emp2 tmp set sal = sal + (select avg(sal) from emp2 where tmp.deptno = deptno) where ename in (select ename from emp2,sal_cat where sal between lowest_sal and highest_sal and category = 2);
select avg(sal) avg_sal from emp2;


/*
Write a PL/SQL program (procedure or anonymous block) which prints out the following data. The 
name, the salary, and the department number of the employees whose salary is the second largest 
within their own department. (Ename, Sal, Deptno)
If there are ties (equality) between salaries, then any name can be printed from them.
*/



CREATE OR REPLACE PROCEDURE printEmp IS
cont integer := 0;
highest integer :=0;
begin
    for i in (select distinct deptno from emp) loop
        cont :=0;
        for j in (select * from emp where deptno = i.deptno order by sal desc) loop
            cont := cont + 1;
            if(cont = 1) then
                select j.sal into highest from dual;
            end if;
            if(j.sal <>  highest) then
                dbms_output.put_line(j.ename||'-'||j.sal||'-'||j.deptno);
                exit;
            end if;
        end loop;
    end loop;
end;
/
set serveroutput on;
execute printEmp;
select * from emp where deptno = 30 order by sal desc;




                

