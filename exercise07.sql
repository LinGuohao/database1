/* Write a procedure which prints out the n-th Fibonacchi number. 
   fib1 = 0, fib2 = 1, fib3 = 1, fib4 = 2 ... etc.
*/
CREATE OR REPLACE Function fibhelper(n integer) return integer IS
begin
    if(n=0) then
        return 0;
    end if;
    if(n=1) then
        return 1;
    end if;
    return fibhelper(n-1) + fibhelper(n-2);

end;
/


CREATE OR REPLACE PROCEDURE fib(n integer) IS
output integer :=0;
begin
    output := Fibhelper(n-1);
    DBMS_OUTPUT. PUT_LINE(TO_CHAR(output));
end;
/
execute fib(10);

set serveroutput on   -- IT IS REQUIRED TO SEE THE OUTPUT !!!
execute check_plsql('fib(10)'); 
-- you can call the procedure with -> call fib(10);


/* Write a function which returns the greatest common divisor of two integers */
CREATE OR REPLACE FUNCTION gcd(p1 integer, p2 integer) RETURN number IS
begin
    if(mod(p1,p2)=0) then
        return p2;
    else
        return gcd(p2,mod(p1,p2));
    end if;
end;
/
SELECT gcd(3570,7293) FROM dual;
execute check_plsql('gcd(3570,7293)'); 


/* Write a function which returns n factorial. */
CREATE OR REPLACE FUNCTION factor(n integer) RETURN integer IS
s integer :=1;
begin
    for i in 1..n loop
        s := s * i;
    end loop;
    return s;
end;
/
SELECT factor(10) FROM dual;
execute check_plsql('factor(10)'); 



/* Write a function which returns the number of times the first string parameter contains 
   the second string parameter. 
*/

CREATE OR REPLACE FUNCTION num_times(p1 VARCHAR2, p2 VARCHAR2) RETURN integer IS
n integer :=0;
begin
    select REGEXP_COUNT('GEORGE','GE') into n from DUAL;
    return n;
end;
/
SELECT num_times ('ab c ab ab de ab fg', 'ab') FROM dual;
set serveroutput on
execute check_plsql('num_times (''ab c ab ab de ab fg'', ''ab'')'); 



/* Write a function which returns the sum of the numbers in its string parameter.
   The numbers are separated with a '+'.
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
    select sum(to_number(COLUMN_VALUE)) into n from ( select * from table (strsplit('1 + 4 + 13 + 0','+')));
    return n;
end;
/
SELECT sum_of('1 + 4 + 13 + 0') FROM dual;
set serveroutput on
execute check_plsql('sum_of(''1 + 4 + 13 + 0'')'); 




