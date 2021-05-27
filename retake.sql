/* 3  */
alter session set nls_date_language='english';


select ename, day_name ,num_of_emps from (select mgr,day_name,count(*) num_of_emps from (select empno, to_char(hiredate,'Day') day_name from emp) natural join emp group by mgr,day_name having count(*)>=2)tmp ,emp where tmp.mgr = emp.empno;

select * from emp;

with tmp as
    (select mgr,day_name,count(*) num_of_emps from (select empno, to_char(hiredate,'Day') day_name from emp) natural join emp group by mgr,day_name having count(*)>=2)
select ename ,day_name,num_of_emps from tmp ,emp where tmp.mgr = emp.empno;

/* 3_2 */



/* 4  */

select avg(sal) avg_sal from (select * from emp  where mgr = (select empno from emp where ename ='BLAKE') ORDER BY sal asc  ) where rownum < 4;

/* 4_2 */
with blaketable as 
    (select * from emp  where mgr = (select empno from emp where ename ='BLAKE') ORDER BY sal) 
select avg(sal) avg_sal from blaketable where rownum<=3;


/* 5 */

select ename,sal,rpad('#',sal/200,'#') str from (select * from emp natural join dept where loc ='CHICAGO' order by hiredate) where rownum = 1;

/* 6 */
with
    avg_sal as (select category, avg(sal) av_sal from emp,sal_cat where sal between lowest_sal and highest_sal group by category),
    emptable as (select * from emp,sal_cat where sal between lowest_sal and highest_sal ),
    tablewithavg as (select * from emptable natural join avg_sal)
    select ename,sal, av_sal cat_avg from tablewithavg where sal<av_sal;


drop table R;
create table R as (select * from  NIKOVITS.R);

drop table S;
create table S as (select * from  NIKOVITS.S);

select A ,sum(B) from (select distinct A,B from  R) group by A;


select E from (select A,SUM(E) E  from (select A,(B+C)E from R) group by A) union (select distinct  c from S);

(select  A ,C from R)
minus
(select A,R.C  from R,(select distinct C from   S ) S where R.B = S.C );


