/*
exercise 1
----------
Write a function which takes a positive integer as its parameter and returns the
prime factors of the parameter in a character string. The form of the string should be
the following: p1*p2*p3 ..., e.g. for 120 -> 2*2*2*3*5.

*/

CREATE OR REPLACE FUNCTION primefactor(p1 integer) RETURN varchar2 IS
n integer:= p1;
res varchar2(100):='';
begin
     while n>1 loop
        for i in 2..n loop
            if mod(n,i) = 0 then
                n := n/i;
                if n = 1 then 
                    res := res||'*'||to_char(i);
                else
                    res := res||'*'||to_char(i);
                end if;
                exit;
            end if;
        end loop;
    end loop;
    return to_char(p1)||'='||substr(res,2,length(res));
end;
/
set serveroutput on
select primefactor(86632) from dual;


/*
exercise 2 (Create your own table from NIKOVITS.EMP before running.)
----------
Write a procedure which increases the salary of the employees who has salary category p (p is parameter).
The increment should be the commission of the employee, or if it is NULL, then the increment is 100.
After executing the update statement, the procedure should print out the average salary of all employees.
At the very end (after printing out the average) the procedure should give a ROLLBACK statement
to save the original content of thetable, in order to be able to run it several times.
*/

CREATE OR REPLACE PROCEDURE add_commission(p integer) IS
avgsal number := 0;
begin
    for c in (select * from (select * from emp where emp.ename in
                    (select ename from emp,sal_cat where 
                        sal between lowest_sal and highest_sal and category = p))) loop
         update emp set sal = sal+ coalesce(comm,100) where emp.ename = c.ename;
    end loop;
    select avg(sal) into avgsal from emp;
    rollback;
    dbms_output.put_line('The avg is: '||avgsal);
end;
/
execute add_commission(4);

/*
exercise 3
----------
Write a procedure which prints out the names of the employees whose name has two identical
letters (e.g. TURNER has two 'R'-s). The procedure should print out the names of these 
employees and the sum of their salaries.
*/

CREATE OR REPLACE PROCEDURE letter2 is
allsal integer :=0;
begin   
    for c in (select * from emp) loop
        for i in 1..length(c.ename) loop
            if(REGEXP_COUNT(c.ename,substr(c.ename,i,1)) = 2) then
                dbms_output.put_line(substr(c.ename,i,1)||'-'||c.ename);
                allsal := allsal + c.sal;
                exit;
            end if;
        end loop;
    end loop;
    dbms_output.put_line('The sum of the sal is : '||allsal);


end;
/

execute letter2;

/*
exercise 4 (Create your own table from NIKOVITS.EMP before running.)
----------
Write a procedure which updates the salaries on a department (parameter: department number).
The update should increase the salary in the following way: if the name of the employee contains
a letter 'T' then the increment is 10000. If the name doesn't contain 'T' then the increment
is n*10000, where n is the salary category of the employee.
The procedure should print out the name and new salary of the modified employees.
At the very end (after printing out the output) the procedure should give a ROLLBACK statement
to save the original content of the table, in order to be able to run it several times.
*/
drop table emp;
create table emp as select * from NIKOVITS.EMP;

CREATE OR REPLACE PROCEDURE sal_increase(p_deptno INTEGER) IS
tmpsal integer :=0;

begin
    for c in (select * from emp where deptno = p_deptno) loop
        if(REGEXP_COUNT(c.ename,'T')>=1) then
           
            update emp set sal = sal + 10000  where emp.ename = c.ename;
           
        else
            update emp set sal = sal + 10000 * (select category from emp,sal_cat where sal between lowest_sal and highest_sal and emp.ename = c.ename) 
            where emp.ename = c.ename;
           
        end if;
        select sal into tmpsal from emp where emp.ename = c.ename;
        dbms_output.put_line(c.ename||':'||tmpsal);
    end loop;
    rollback;
end;
/




execute sal_increase(20);

select * from emp where deptno = 20;

/*
exercise 5
Write a procedure which prints out (based on table NIKOVITS.PARENTOF) the name,
money and average money of the descendants for whom it is true, that the average money
of the descendants is greater than the person's money.
The program should print out 3 pieces of data for every row: Name, Money, Avg_Money_of_Descendants 
*/
CREATE OR REPLACE PROCEDURE rich_avg_descendant IS
tmpavg integer :=0;
begin
    for c in (select * from PARENTOF) loop
        select avg(money) into tmpavg from (select * from parentof start with name = c.name connect by prior name = parent) tmp where c.name <> tmp.name;
        if(tmpavg > c.money) then
            dbms_output.put_line(c.name||'-'||c.money||'-' ||tmpavg);
        end if;
    end loop;

end;
/
select * from PARENTOF;
execute rich_avg_descendant;