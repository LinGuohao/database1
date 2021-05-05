/* Update with cursor
--https://www.oracletutorial.com/plsql-tutorial/oracle-cursor-for-update/#:~:text=Introduction%20to%20Oracle%20Cursor%20FOR%20UPDATE&text=Once%20you%20open%20the%20cursor,with%20either%20COMMIT%20or%20ROLLBACK%20.
Write a procedure which updates the salaries on a department (parameter: department number).
The update should increase the salary with n*10000, where n is the number of vowels (A,E,I,O,U)
in the name of the employee. (For ALLEN it is 2, for KING it is 1.)
The procedure should print out the name and new salary of the modified employees.
*/
CREATE OR REPLACE PROCEDURE curs_upd(p_deptno INTEGER) IS 
CURSOR c_emp IS SELECT ename, sal FROM emp WHERE (select getnumofvowels(ename)from dual) > 0 FOR UPDATE OF sal;
tmpsal number;
tmpname varchar2(50);
originsal varchar2(50);
begin
     FOR r_emp IN c_emp loop 
        select r_emp.ename, r_emp.sal into tmpname,tmpsal from emp where emp.ename = r_emp.ename;
        select getnumofvowels(r_emp.ename) into originsal from dual;
        tmpsal := tmpsal + originsal * 10000;
        update emp set sal = sal + tmpsal where emp.ename = r_emp.ename;
        dbms_output.put_line(tmpname||'-'||tmpsal);
    end loop;
    rollback;

end;
/

set serveroutput on
execute curs_upd(10);


create or replace function getnumofvowels(na varchar2) return integer is
TYPE chaarray IS TABLE OF varchar2(50) INDEX BY binary_integer;
ca  chaarray;
nu  integer:=0 ;
tmp varchar2(50);
begin
    ca(1):= 'A';
    ca(2):='E';
    ca(3):='I';
    ca(4):='O';
    ca(5):= 'U';
    for i in 1..length(na) loop
        SELECT SUBSTR(na, i, 1) into tmp FROM dual;
        if(  tmp = 'A' or tmp = 'E' or tmp = 'I' or tmp = 'O' or tmp = 'U') then
            nu:=nu+1;
        end if;
    end loop;
    return nu;
            
end;
/

execute check_plsql('curs_upd(10)'); 
--SELECT SUBSTR('tmp', 1, 1)  FROM dual;
-----------------------------------------------------------------
/* (exception)
Write a function which gets a date parameter in one of the following formats: 
'yyyy.mm.dd' or 'dd.mm.yyyy'. The function should return the name of the 
day, e.g. 'Tuesday'. If the parameter doesn't match any format, the function
should return 'wrong format'.
*/
 ALTER SESSION SET NLS_DATE_LANGUAGE='English';   
CREATE OR REPLACE FUNCTION day_name(d varchar2) RETURN varchar2 IS
da date;
ca varchar2(50);
begin
begin
    select to_date(d,'yyyy-mm-dd')into da from dual;
    select to_char(da,'Day') into ca from dual;
    return ca;
EXCEPTION
        WHEN others THEN
           select to_date(d,'dd.mm.yyyy')into da from dual;
           select to_char(da,'Day') into ca from dual;
           return ca; 
end;
EXCEPTION
    WHEN others THEN
           return 'wrong format'; 
end;
/
SELECT day_name('2017.05.01'), day_name('02.05.2017'), day_name('abc') FROM dual;

----------------------------------------------------------------------------------------
/* (exception, SQLCODE)
Write a procedure which gets a number parameter and prints out the reciprocal,
the sqare root and the factorial of the parameter in different lines. 
If any of these outputs is not defined or causes an overflow, the procedure should 
print out 'not defined' or the error code (SQLCODE) for this part.
(The factorial is defined only for nonnegative integers.)
*/
CREATE OR REPLACE PROCEDURE numbers(n number) IS
reciprocal number :=0;
sqareroot number:=0;
factorial number:=1;
er varchar(50):='not defined';
begin
begin
begin
    select 1/n into reciprocal from dual;
    dbms_output.put_line(reciprocal);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('not defined');
end;
    select sqrt(n) into sqareroot from dual;
    dbms_output.put_line(sqareroot);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('not defined');
end;
    if(n<0) then
        dbms_output.put_line('not defined');
    elsif(n = 0) then
        factorial:= 0;
        dbms_output.put_line('0');
    else
        for i in 1..n loop
            factorial:= factorial * i;
        end loop;
         dbms_output.put_line(factorial);
    end if;
end;
/

set serveroutput on
execute numbers(0);
execute numbers(-2);
execute numbers(40);

---------------------------------------------------------------------
/* (exception)
Write a function which returns the sum of the numbers in its string parameter.
The numbers are separated with a '+'. If any expression between the '+' characters
is not a number, the function should consider this expression as 0.
*/

create or replace type strsplit_type as table of varchar2(4000) ;

create or replace function strsplit(p_value varchar2,
                                    p_split varchar2 := ',')
--usage: select * from table(strsplit('1,2,3,4,5'))
 return strsplit_type
  pipelined is
  v_idx       integer;
  v_str       varchar2(500);
  v_strs_last varchar2(4000) := p_value;

begin
  loop
    v_idx := instr(v_strs_last, p_split);
    exit when v_idx = 0;
    v_str       := substr(v_strs_last, 1, v_idx - 1);
    v_strs_last := substr(v_strs_last, v_idx + 1);
    pipe row(v_str);
  end loop;
  pipe row(v_strs_last);
  return;

end strsplit;
/

CREATE OR REPLACE FUNCTION sum_of(p_char VARCHAR2) RETURN number IS
n integer := 0;
begin
    select sum(to_number(COLUMN_VALUE)) into n from ( select * from table (strsplit(p_char,'+')));
    return n;
end;
/




CREATE OR REPLACE FUNCTION sum_of2(p_char VARCHAR2) RETURN number IS
begin
    return sum_of(p_char);
EXCEPTION 
    WHEN OTHERS THEN
        return 0;
end;
/
SELECT sum_of2('1+21 + bubu + + 2 ++') FROM dual;
SELECT sum_of2('1 + 2 + 3 + 4 + 5') FROM dual;


