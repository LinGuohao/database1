/*
exercise 1
----------
Write a function which takes a positive integer as its parameter and returns the
prime factors of the parameter in a character string. The form of the string should be
the following: p1*p2*p3 ..., e.g. for 120 -> 2*2*2*3*5.

*/

CREATE OR REPLACE FUNCTION primefactor(p1 integer) RETURN varchar2 IS
TYPE numarray IS TABLE OF number INDEX BY binary_integer;
na numarray;
tmp integer :=2;
k integer ;
cn integer := 0;
p2 integer := p1;
res varchar2(500):='';
begin
    if(p2 = tmp) then 
         return p2||'->'||p2;
    else
        while (p2>= tmp) loop
            k := mod(p2,tmp);
            if(k=0) then
                cn := cn+1;
                na(cn):= tmp;
                p2 := p2/tmp;
            else
                tmp:= tmp+1;
            end if;
        end loop;
    end if;
    --return(to_char(cn));
    for i in 1..cn loop
        if(i<>cn) then
            res := res||na(i)||'*';
            --return(res);
        else
            res := res||na(i);
        end if;
    end loop;
    return (p1||'->'||res);
                
end;
/
set serveroutput on
SELECT primefactor(120) FROM dual;
SELECT primefactor(86632) FROM dual;

/*
exercise 2 (Create your own table from NIKOVITS.EMP before running.)
----------
Write a procedure which increases the salary of the employees who has salary category p (p is parameter).
The increment should be the commission of the employee, or if it is NULL, then the increment is 100.
After executing the update statement, the procedure should print out the average salary of all employees.
At the very end (after printing out the average) the procedure should give a ROLLBACK statement
to save the original content of the table, in order to be able to run it several times.
*/
drop table emp;
create table emp as select * from NIKOVITS.EMP;
select * from emp;
CREATE OR REPLACE PROCEDURE add_commission(p integer) IS
res number;
begin
    update emp set sal = sal + coalesce(comm,100) where emp.empno  in 
    (select empno from emp,sal_cat tmp where emp.sal between lowest_sal and highest_sal and category = p);
     select avg(sal) into res from emp;
     dbms_output.put_line('The avg is:'||res);
end;
/
set serveroutput on
execute add_commission(4);

/*
exercise 3
----------
Write a procedure which prints out the names of the employees whose name has two identical
letters (e.g. TURNER has two 'R'-s). The procedure should print out the names of these 
employees and the sum of their salaries.
*/

CREATE OR REPLACE PROCEDURE letter2 IS 
cursor e_c is (select ename,sal from emp);
s integer :=0;
e integer :=0;
ressal integer :=0;
tmp emp.ename%type;
begin
    for c in e_c loop
        s:=0;
        for i in 1..LENGTH(c.ename) loop
            s:= s+1;
            tmp := substr(c.ename,s,1);
            --dbms_output.put_line(c.ename);
            if(regexp_count(c.ename,tmp) = 2) then
                 dbms_output.put_line(tmp||'-'||c.ename);
                 ressal := ressal + c.sal;
                 exit;
            end if;
        end loop;
    end loop;
    rollback;
    dbms_output.put_line('The sum of the sal is :'||ressal);
        

end;
/
set serveroutput on
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

CREATE OR REPLACE PROCEDURE sal_increase(p_deptno INTEGER) IS
CURSOR c_emp IS SELECT ename, sal,deptno,category FROM emp,sal_cat 
WHERE sal between lowest_sal and highest_sal FOR UPDATE OF sal;
newsal integer;
begin
    for c in c_emp loop
        if(c.deptno = p_deptno) then
            if(regexp_count(c.ename,'T') >= 1) then
                update emp set emp.sal = emp.sal+10000 where emp.ename = c.ename;
            else 
                update emp set emp.sal = emp.sal + 10000 * c.category where emp.ename = c.ename;
            end if;
            select emp.sal into newsal from emp where emp.ename = c.ename;
             dbms_output.put_line(c.ename||':'||newsal);
        end if;
    end loop;
    
    rollback;
end;
/
execute sal_increase(20);


/*exercise 5/*
Write a procedure which prints out (based on table NIKOVITS.PARENTOF) the name,
money and average money of the descendants for whom it is true, that the average money
of the descendants is greater than the person's money.
The program should print out 3 pieces of data for every row: Name, Money, Avg_Money_of_Descendants 
*/
drop table PARENTOF;
create table PARENTOF as select * from NIKOVITS.PARENTOF;
select * from PARENTOF;
CREATE OR REPLACE PROCEDURE rich_avg_descendant IS
avgmoney integer;
begin
    for c in (select name,money from PARENTOF) loop
        select avg(money) into avgmoney from 
        (select name,parent,money from PARENTOF start with name = c.name connect by prior name= parent ) tmp
        where tmp.name <> c.name ;
        if(c.money< avgmoney) then 
            dbms_output.put_line(c.name||'-'||c.money||'-'||avgmoney);
        end if;
    end loop;
end;
/
execute rich_avg_descendant;

