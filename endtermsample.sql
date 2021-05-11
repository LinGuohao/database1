/*
Write the following program. Take the first n (n>=1) non-prime numbers (num>=4). 
Put the number and its greatest non-trivial divisor into a record object, 
and collect these records into an associative array (table). 
Example: n=5 -> [{4, 2}, {6, 3}, {8, 4}, {9, 3}, {10, 5}]). Print out the last element of the array.
*/
CREATE OR REPLACE PROCEDURE num_highdiv(n integer) IS
type tmprecord is record (num integer default 0, div integer default  0);
tr tmprecord;
type tabletype  is table of tmprecord index by binary_Integer;
tm tabletype;
now integer :=1;
div integer:=0;
cn integer:=0;
begin
    while  cn<n loop
        if(prim(now) = 0) then
            div := findiv(now);
            cn := cn+1;
            tm(cn).num := now;
            tm(cn).div := div;
            now := now + 1;
        else
            now:=now + 1;
        end if;
    end loop;
    dbms_output.put_line(tm(cn).num||','||tm(cn).div);

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
create or replace function findiv(n integer) return number is
s integer;
nu integer :=n ;
h integer ;
begin
    nu := nu/2;
    for i in 2..nu loop
        if(mod(n,i) = 0) then
            h:=i;
        end if;
    end loop;
    return h;
end;
/

set serveroutput on
execute num_highdiv(5);


/*
2.	Cursors/Select Into

Write a PL/SQL function which returns the sum of salaries of an employee¡¯s direct subordinates. 
Return 0 if there are no subordinates.
*/
CREATE OR REPLACE FUNCTION subord_sum(p_empno integer) RETURN INTEGER IS
allsal integer :=0;
cou integer :=0;
begin
        select count(*) into cou from emp where p_empno = emp.mgr;
        if(cou>0) then
            select sum(sal) into allsal from emp where p_empno = emp.mgr;
            return allsal;
        else
            return 0;
        end if;
end;
/
select (subord_sum(7839)) from dual;
execute check_plsql('subord_sum(7839)'); 


/*
3.	DML in PL/SQL (when current of):

Write a PL/SQL program that updates the salaries of each employee. 
The increment is n*100, 
where n is equal to the sum of digits in the salary of the employee. Ex: 1550 -> n = 11. 
Print out the new salary for each row.
*/

CREATE OR REPLACE PROCEDURE upd_sal IS 
nowsal integer:=0;
begin
    for i in (select * from emp) loop
        update emp set sal = sal + getsum(sal)*100  where emp.empno = i.empno;
        
        select sal  into  nowsal from emp where emp.empno = i.empno;
        dbms_output.put_line(i.ename||'-'||nowsal);
    end loop;
    rollback;
end;
/

drop function getsum;

create or replace function getsum(n number) return number is
res number:=0;
tmp varchar2(50):= to_char(n);
now integer :=0;
begin
    --return(to_number(tmp));
    for i in 1..length(tmp) loop
        now := now + 1;
        res:= res + to_number(substr(tmp,now,1));
    end loop;
    return res;
end;
/
execute upd_sal;  
select * from emp;

/*
4.	Cursor/Select Into + Exception Handling:

Write a PL/SQL function that queries the name and salary of an employee with the specified empno. Use exception handling for the case when the empno is invalid. 
Return ¡¯wrong empno¡¯ in such cases.
    
*/ 
CREATE OR REPLACE FUNCTION get_emp_info(p_empno integer) RETURN VARCHAR IS 
resname emp.ename%type;
ressal emp.sal%type;
co integer :=0;
ex1 exception;
begin
    select count(*) into co from emp where emp.empno = p_empno;
    if(co = 0) then
        raise ex1;
    else
    select ename,sal into resname, ressal from emp where emp.empno = p_empno;
    end if;
    return to_char(resname)||'-'||to_char(ressal);
    Exception
    when ex1 then
        return 'wrong empno';
end;
/

select get_emp_info(7839) from dual;

/*
5.	SQL recursion

Using the table nikovits.par, write an SQL query which finds all the cousins of child ?k¡±.
Create the Cousins relation using recursion rules. 
*/
drop table par;
create table par as select * from nikovits.PARENTOF;

select * from par;
            