create table emp as select * from nikovits.emp; 
create table dept as select * from nikovits.dept;
create table sal_cat as select * from NIKOVITS.SAL_CAT;
/* SELECT ... INTO ...
Write a function which returns the average salary within a salary category (parameter).
*/

CREATE OR REPLACE FUNCTION cat_avg(p_category integer) RETURN number IS
av number :=0;
begin
    select avg(sal) into av from emp,sal_cat where sal between lowest_sal and highest_sal group by category having category = p_category;
    return av;
end;
/
SELECT cat_avg(2) FROM dual;
set serveroutput on;
execute check_plsql('cat_avg(2)'); 


/* SELECT ... INTO ...
Write a procedure which prints out the number of employees and average salary of the employees 
whose hiredate was the day which is the parameter of the procedure (e.g. 'Monday'). 
*/
CREATE OR REPLACE PROCEDURE day_avg(d varchar2) IS
noe  integer :=0;
avdsal  number :=0;
begin
     select avg(sal) ,count(empno) into avdsal,noe from ((select trim(to_char(hiredate,'Day')) day ,empno from emp) natural join emp) group by day having day = d;
     dbms_output.put_line('Number of emps: '||noe||', Average sal: '||avdsal); 
end;
/

call day_avg('Thursday'); -- output example: Number of emps: 4, Average sal: 2481.25
execute check_plsql('day_avg(''Thursday'')'); 


/* Cursor
Write a procedure which takes the employees working on the parameter department
in alphabetical order, and prints out the jobs of the employees in a concatenated string.
*/

CREATE TYPE varray_type AS VARRAY(20) OF VARCHAR2(50);


CREATE OR REPLACE PROCEDURE print_jobs(d_name varchar2) IS
cursor e_c is select * from ((select * from  (emp natural join dept) where dname = d_name order by ename ASC ));
c integer :=0;
n integer :=1;
s VARCHAR2(50) :='';
begin
    select count(*) into c from  (emp natural join dept) where dname = d_name order by ename ASC;
   -- open e_c;
    for c_row in e_c loop
        if(c <> n) then
            select concat(concat(s, c_row.job),'-') into s from dual ;
            n := n+1;
        elsif(c=n) then
             select concat(s, c_row.job) into s from dual ;
        end if;
    end loop;
    --close e_c;
     dbms_output.put_line(s); 
end;
/
set serveroutput on
call print_jobs('ACCOUNTING');  -- output example: MANAGER-PRESIDENT-CLERK
execute check_plsql('print_jobs(''ACCOUNTING'')'); 


/* Associative array (we call it also PLSQL TABLE)
Write a procedure which takes the first n (n is the parameter) prime numbers and puts them into 
an associative array. The procedure should print out the last prime and the total sum of the prime numbers.
*/
create or replace PROCEDURE primes(n integer) IS
TYPE numarray IS TABLE OF number INDEX BY binary_integer;
na numarray;
s integer :=0;
begin
    for i in 1..n loop
        na(i) := prime(i);
        s := s + na(i);
    end loop;
    dbms_output.put_line(to_char(na(n))||'-'||to_char(s));
end;
/
set serveroutput on
execute primes(100);
execute check_plsql('primes(100)'); 

create or replace function IsPrime(n integer) return integer is
begin
    if(n=1) then 
        return 0;
    end if;
    for i in 2..n-1 loop
        if(mod(i,2) = 0) then
            return 0;
        end if;
    end loop;
    return 1;
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
create or replace function prime(n integer) return integer is
m integer := 0;
i integer :=2;
begin
    while (m<n) loop
        if(prim(i)=1) then
            m := m + 1;
        end if;
        i := i+1;
    end loop;
    return i-1;
end;
/



/* Cursor and associative array
Write a plsql procedure which takes the employees in alphabetical order
and puts every second employee's name (1st, 3rd, 5th etc.) and salary into an associative array.
The program should print out the last but one (the one before the last) values from the array.
*/
drop table emp;
create table emp as select * from nikovits.emp;

CREATE OR REPLACE PROCEDURE curs_array IS
cn integer:=1;
ind integer :=1;
type tmprecord is record (na emp.ename%TYPE default '', sal emp.sal%TYPE default 0);
tr tmprecord;
cursor c is select ename,sal from emp order by ename asc;
type tabletype  is table of tmprecord index by binary_Integer;
tm tabletype;
begin

     for c_tmp in c loop
        if(mod(cn,2) = 1) then
            tm(ind).na := c_tmp.ename;
            tm(ind).sal := c_tmp.sal;
            ind := ind + 1;
        end if;
        cn:=cn+1;
    end loop;
    dbms_output.put_line(to_char(tm(ind-1).na)||'-'||to_char(tm(ind-1).sal));
end;
/

set serveroutput on
execute curs_array();

create or replace PROCEDURE curs_array1 IS
cn integer:=0;
type tmprecord is record (na emp.ename%TYPE default '', sal emp.sal%TYPE default 0);
tr tmprecord;
cursor c is select ename,sal from emp order by ename asc;
type tabletype  is table of tmprecord index by binary_Integer;
tm tabletype;
begin
    for c_tmp in c loop
        if mod(c%rowcount,2) = 1 then
          cn:=cn+1;
          tm(cn).na := c_tmp.ename;
          tm(cn).sal := c_tmp.sal;  
        end if;  
    end loop;
    dbms_output.put_line(tm(cn).na||'-'||tm(cn).sal);
end;
/
/* Insert, Delete, Update
Write a procedure which increases the salary of the employees who has salary category p (p is parameter).
The increment should be the minimal salary of the employee's own department.
After executing the update statement, the procedure should print out the average salary of the employees.
*/
CREATE OR REPLACE PROCEDURE upd_cat(p integer) IS
dp integer;
cat integer;
res number;
begin

update emp set sal = sal + getMoney(deptno) where emp.ename  in (
with 
empwithcat as 
(select * from emp,sal_cat where emp.sal between lowest_sal and highest_sal)
select ename from empwithcat where category = p);
select avg(sal) into res from emp;
rollback;
dbms_output.put_line(to_char(res));
    
end;
/

set serveroutput on
execute upd_cat(2);
drop table emp;
create table emp as select * from nikovits.emp; 
commit;
execute check_plsql('upd_cat(2)'); 

select  getMoney(20) from dual;





create or replace function getMoney(d integer) return number is
res number;
begin
 select min(sal) into res from emp where deptno = d;
 return res;
end;
/





---------------------------------------------------
CREATE OR REPLACE PROCEDURE upd_cat(p integer) IS
v integer;
begin
UPDATE emp SET sal = sal + (SELECT minSal(deptno) FROM dual)
WHERE ename IN (select ename from emp, sal_cat where sal between lowest_sal and highest_sal and category = p);



select avg(sal) into v from emp
WHERE ename IN (select ename from emp, sal_cat where sal between lowest_sal and highest_sal and category = p);
dbms_output.put_line(v);
ROLLBACK;
end;
/



create or replace function minSal(deptNum integer) return number is
s number;
begin
SELECT min(sal) into s from emp group by deptno having deptno = deptNum;
return s;
end;
/



set serveroutput on
execute upd_cat(2);


----------------------------------------------------------
/* Insert, Delete, Update
Write a procedure which increases the salary of the employees who has salary category p (p is parameter).
The increment should be the minimal salary of the employee's own department.
After executing the update statement, the procedure should print out the average salary of the employees.
*/
drop table emp;
create table emp as select * from nikovits.emp; 
CREATE OR REPLACE PROCEDURE upd_cat(p integer) IS
v number :=0;
begin
    --dbms_utility.exec_dll_statement('create table emp2 as select* from emp');
    update emp set sal = sal + (select min(sal) from emp e2 where e2.deptno = deptno ) where ename in
(select ename from (select ename,category  from emp,sal_cat where sal between lowest_sal and highest_sal ) where category = p);
    select avg(sal) into v from emp;
    rollback;
    dbms_output.put_line(v);
end;
/

set serveroutput on
execute  upd_cat(2);
execute check_plsql('upd_cat(2)'); 
--select min(sal) from emp where deptno =20;