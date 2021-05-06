/* CONNECT BY
https://juejin.cn/post/6844904175344713736
Write a procedure which prints out (based on table NIKOVITS.PARENTOF) the names 
of people who has a richer descendant than him/her. 
(That is, at least one descendant has more money than the person.)
*/

create table parentof as select * from  NIKOVITS.PARENTOF;
select * from parentof;

CREATE OR REPLACE PROCEDURE rich_descendant IS
cnt integer :=0;
begin
    for rec in (select name ,parent,money from parentof) loop
        select count(*) into cnt from 
        (select money from parentof
        start with parentof.name= rec.name
        connect by NOCYCLE prior parentof.name =  parentof.parent) tmp
        where tmp.money > rec.money; 
        if(cnt>0) then
            dbms_output.put_line(rec.name);
        end if;
    end loop;
end;
/
set serveroutput on
execute check_plsql('rich_descendant()'); 
execute rich_descendant(); 



/*
Write a procedure which prints out (based on table NIKOVITS.PARENTOF) the name,
money and average money of the descendants for whom it is true, that the average money
of the descendants is greater than the person's money.
The program should print out 3 pieces of data for every row: Name, Money, Avg_Money_of_Descendants 
*/
CREATE OR REPLACE PROCEDURE rich_avg_descendant IS
amoney integer :=0;
begin
    for rec in (select name ,parent,money from parentof) loop
        select avg(money) into amoney from 
        (select name,money from parentof
        start with parentof.name= rec.name
        connect by NOCYCLE prior parentof.name =  parentof.parent) tmp
        where tmp.name <> rec.name;
        if(amoney>rec.money) then
            dbms_output.put_line(rec.name||'-'||rec.money||'-'||amoney);
        end if;
    end loop;
end;
/


set serveroutput on
execute rich_avg_descendant;
execute check_plsql('rich_avg_descendant'); 


/*
Write a procedure which prints out (based on table NIKOVITS.FLIGHT) the nodes (cities)
of the directed cycles, which start and end with the parameter city.
Example output: Dallas-Chicago-Denver-Dallas
*/
drop table flight;
CREATE TABLE Flight(airline VARCHAR2(10), orig VARCHAR2(15), dest VARCHAR2(15), cost NUMBER);
INSERT INTO flight VALUES('Lufthansa', 'San Francisco', 'Denver', 1000);
INSERT INTO flight VALUES('Lufthansa', 'San Francisco', 'Dallas', 10000);
INSERT INTO flight VALUES('Lufthansa', 'Denver', 'Dallas', 500);
INSERT INTO flight VALUES('Lufthansa', 'Denver', 'Chicago', 2000);
INSERT INTO flight VALUES('Lufthansa', 'Dallas', 'Chicago', 600);
INSERT INTO flight VALUES('Lufthansa', 'Dallas', 'New York', 2000);
INSERT INTO flight VALUES('Lufthansa', 'Chicago', 'New York', 3000);
INSERT INTO flight VALUES('Lufthansa', 'Chicago', 'Denver', 2000);

--connect_by_iscycle 伪列一起使用查看行是否包含循环
--connect_by_isleaf  可以判断当前的记录是否是树的叶节点
CREATE OR REPLACE PROCEDURE find_cycle(p_node VARCHAR2) IS
CURSOR res IS  
    (select orig,dest,SYS_CONNECT_BY_PATH(orig,'-')||'-'||dest  pa,CONNECT_BY_ROOT(orig),connect_by_iscycle from flight 
    start with orig = p_node
    connect by NOCYCLE prior dest=orig);
begin
   for c_res in res loop
        if(c_res.dest = p_node) then
            dbms_output.put_line(c_res.pa);
        end if;
    end loop;
end;
/
set serveroutput on
execute find_cycle('Denver');
execute check_plsql('find_cycle(''Denver'')'); 




/*
Write a procedure which prints out (based on table NIKOVITS.PARENTOF) the name and city
of people who have at least two ancestors with the same city as the person's city.
*/
CREATE OR REPLACE PROCEDURE ancestor2 IS
CURSOR res IS 
(select name,city,SYS_CONNECT_BY_PATH(city,'-') pa  from parentof
        start with parentof.name= 'ADAM'
        connect by NOCYCLE prior parentof.name =  parentof.parent);
c integer :=0;
begin
    for r in res loop
        select  REGEXP_COUNT(r.pa,r.city) into c from  dual;
        
        if(c >=3) then
            dbms_output.put_line(r.name||' - '||r.city);
        end if;
    end loop;
end;
/

set serveroutput on
execute ancestor2();
execute check_plsql('ancestor2()'); 




