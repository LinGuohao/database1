/*

exercise 1
----------
Write a function which returns the lowest common multiple of two integers.
CREATE OR REPLACE FUNCTION lcm(p1 integer, p2 integer) RETURN number IS
Test: 
SELECT lcm(33462, 18876) FROM dual;

*/

CREATE OR REPLACE FUNCTION lcm(p1 integer, p2 integer) RETURN number IS
startnum integer := greatest(p1,p2);
endnum integer := p1*p2;
begin
    for i in startnum .. endnum loop
        if mod(i,p2) = 0 and mod(i,p2)=0 then
            return i;
        end if;
    end loop;
end;
/
set serveroutput on
SELECT lcm(33462, 18876) FROM dual;

/*
Write a procedure which increases the salary of the employees who has salary category p (p is parameter).
The increment should be the minimal salary of the employee's own department.
After executing the update statement, the procedure should print out the average salary of all employees.
At the very end (after printing out the average) the procedure should give a ROLLBACK statement
to save the original content of the table, in order to be able to run it several times.
CREATE OR REPLACE PROCEDURE upd_cat(p integer) IS
*/

CREATE OR REPLACE PROCEDURE upd_cat(p integer) IS
newavg number :=0;
begin
    for c in (select * from emp ,sal_cat where sal between lowest_sal and highest_sal and category = p) loop
        update emp set sal = sal + (select min(sal) from emp where deptno = c.deptno ) where emp.ename = c.ename;
    end loop;
    select avg(sal) into newavg from emp;
    dbms_output.put_line(round(newavg,2));
    rollback;
        

end;
/
execute upd_cat(2);
execute check_plsql('upd_cat(2)'); 


/*
Exercise 3 
----------
Write a function which gets a date parameter in one of the following formats: 
'yyyy.mm.dd', 'dd.mm.yyyy' or 'mm.yyyy.dd'. The function should return the name of the 
day, e.g. 'Tuesday'. If the parameter doesn't match any of the formats, the function
should return 'wrong format'.
CREATE OR REPLACE FUNCTION day_name(d varchar2) RETURN varchar2 IS
...
SELECT day_name('2018.05.01'), day_name('02.05.2018'), day_name('02.1967.03'), day_name('2018.13.13') FROM dual;
*/
ALTER SESSION SET NLS_DATE_LANGUAGE='English';   
CREATE OR REPLACE FUNCTION day_name(d varchar2) RETURN varchar2 IS
da date;
ca varchar2(50);
begin
begin
begin
     select to_date(d,'yyyy.mm.dd')into da from dual;
     select to_char(da,'Day') into ca from dual;
     return ca;
Exception
      WHEN others THEN
           select to_date(d,'dd.mm.yyyy')into da from dual;
           select to_char(da,'Day') into ca from dual;
           return ca; 
end;
Exception
      WHEN others THEN
           select to_date(d,'mm.yyyy.dd')into da from dual;
           select to_char(da,'Day') into ca from dual;
           return ca; 
end;
EXCEPTION
    WHEN others THEN
           return 'wrong format'; 
end;
/

SELECT day_name('2018.05.01'), day_name('02.05.2018'), day_name('02.1967.03'), day_name('2018.13.13') FROM dual;


/*
Exercise 4 
----------
Write a procedure which takes the first n (n is the parameter) prime numbers and puts them into 
an associative array. The first prime is 2, the second is 3 ... etc. 
The procedure should print out the last prime and the total sum of the primes.
CREATE OR REPLACE PROCEDURE primes(n integer) IS
*/

CREATE OR REPLACE PROCEDURE primes(n integer) IS 
TYPE numarray IS TABLE OF number INDEX BY binary_integer;
na numarray;
nownum integer :=0;
testnum integer :=1;
sumofnum integer :=0;
begin
    while nownum < n loop 
        while (prim(testnum) = 0) loop
            testnum := testnum + 1;
        end loop;
            nownum := nownum + 1;
            na(nownum) := testnum;
            sumofnum := sumofnum + testnum;
            testnum := testnum + 1;
    end loop;
    dbms_output.put_line(na(nownum)||'-'||sumofnum);
end;
/

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
execute primes(1);
execute check_plsql('primes(1)'); 


/*

Exercise 5 
----------
Write a procedure which prints out (based on table NIKOVITS.PARENTOF) the name and city
of people who have at least two ancestors with the same city as the person's city.
CREATE OR REPLACE PROCEDURE ancestor2 IS
*/

CREATE OR REPLACE PROCEDURE ancestor2 IS
begin
    for c in  (select name,city,SYS_CONNECT_BY_PATH(city,'-') pa  from parentof
        start with parentof.name= 'ADAM'
        connect by NOCYCLE prior parentof.name =  parentof.parent) loop
        
        if REGEXP_COUNT(c.pa,c.city) >=3 then
             dbms_output.put_line(c.name||'-'||c.city);
        end if;
    end loop;

end;
/
set serveroutput on
execute ancestor2();

