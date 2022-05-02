/*  2  */
drop table emp2;
create table emp2 as select * from  nikovits.EMP;

update emp2 tmp set sal = sal + (select avg(sal) from emp2 where emp2.job = tmp.job) 
where tmp.empno in (select empno from emp2,sal_cat where sal between lowest_sal and highest_sal and category = 2) 
and (( select count(*) cn from (select empno from emp2 group by job,empno having job = tmp.job))>=5);

SELECT avg(sal) FROM emp2; 

select emp2.ename from emp2 group by job having count(distinct emp2.ename)>=5;

select * from edge;

select * from emp2;


/* 3 */
create table edge as select * from nikovits.edge;
select * from edge;

WITH  reaches(orig, dest,weight) AS
(
    select orig , dest , weight from edge where orig = 'A'
    union all
    select reaches.orig, edge.dest, edge.weight + reaches.weight from edge ,reaches 
    where reaches.orig <> edge.dest and reaches.dest = edge.orig
)
cycle orig,dest SET cycle_yes TO 'Y' DEFAULT 'N'
select orig,dest,min(weight) Min_Cost from reaches group by orig,dest;


/* 6 */
CREATE TABLE Stars(
name varchar(25),
address varchar(30),
PRIMARY KEY (name)
);

CREATE TABLE Studios(
name varchar(25),
address varchar(30),
PRIMARY KEY (name)
);

CREATE TABLE Movies(
title varchar(20),
year varchar(4),
length number(3),
genre varchar(10),
studioname varchar(25),
PRIMARY KEY (title, year),
FOREIGN KEY (studioname) references Studios(name)
);


CREATE Table MoviewithStar (
moviename varchar(20),
starname varchar(25),
PRIMARY KEY (moviename,starname),
FOREIGN KEY (moviename,starname) references Movies(title),Stars(name)
);




WITH  reaches(orig, dest,weight) AS
(
    select orig , dest , weight from edge 
    union all
    select reaches.orig, edge.dest, edge.weight + reaches.weight from edge ,reaches 
    where reaches.orig <> edge.dest and reaches.dest = edge.orig
)
cycle orig,dest SET cycle_yes TO '1' DEFAULT '2'
select orig,dest F,min(weight) Min_Cost from reaches group by orig,dest having dest = 'E';


alter session set nls_date_language='english';
drop table emp2;

delete emp2 where ename in
(select ename from (select mgr,day_name,count(*) Count_of_emp from (select empno, to_char(hiredate,'Day') day_name from emp) natural join emp group by mgr,day_name having count(*)>=2)tmp ,emp where tmp.mgr = emp.empno);
SELECT avg(sal) FROM emp2;


