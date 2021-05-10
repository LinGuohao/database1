CREATE TABLE Flight(airline VARCHAR2(10), orig VARCHAR2(15), dest VARCHAR2(15), cost NUMBER);

INSERT INTO flight VALUES('Lufthansa', 'San Francisco', 'Denver', 1000);
INSERT INTO flight VALUES('Lufthansa', 'San Francisco', 'Dallas', 10000);
INSERT INTO flight VALUES('Lufthansa', 'Denver', 'Dallas', 500);
INSERT INTO flight VALUES('Lufthansa', 'Denver', 'Chicago', 2000);
INSERT INTO flight VALUES('Lufthansa', 'Dallas', 'Chicago', 600);
INSERT INTO flight VALUES('Lufthansa', 'Dallas', 'New York', 2000);
INSERT INTO flight VALUES('Lufthansa', 'Chicago', 'New York', 3000);
INSERT INTO flight VALUES('Lufthansa', 'Chicago', 'Denver', 2000);

--Reaches(X,Y)  <--  Flight(X,Y)
--Reaches(X,Y)  <--  Flight(X,Z) AND Reaches(Z,Y) AND X <> Y

WITH  reaches(orig, dest,rout) AS 
 (
  SELECT orig, dest,orig||dest FROM flight
   UNION ALL
  SELECT flight.orig, reaches.dest ,flight.orig || Reaches.rout FROM flight, reaches
  WHERE flight.dest = reaches.orig AND flight.orig <> reaches.dest
  )
CYCLE orig SET cycle_yes TO 'Y' DEFAULT 'N' 
SELECT * from reaches;


----------------------------------------------------------------------
-- 1. Give all the possible routes from San Francisco to New York with the total cost of the route.
select  * from flight;
--Reaches(X,Y,C,R)  <--  Flight(X,Y,C) AND R=X||Y
--Reaches(X,Y,C,R)  <--  Reaches(X,Z,C1,R1) AND Flight(Z,Y,C2) AND C=C1+C2 AND R=R1||Y AND X <> Y

with Reaches(orig,dest,cost,rout) as
(   
    select orig,dest,cost, orig||dest from flight
    UNION ALL
    select Reaches.orig, flight.dest, flight.cost + Reaches.cost , Reaches.rout || flight.dest from flight,Reaches
    where Reaches.orig <> flight.dest and Reaches.dest = Flight.orig
)
CYCLE orig,dest SET cycle_yes TO 'Y' DEFAULT 'N'
select * from Reaches;
