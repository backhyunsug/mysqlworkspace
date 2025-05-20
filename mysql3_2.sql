/*w3schools 테이블 구조 
orders - 주문 아이디, 고객아이디,    선적아이디, 판매자아이디 
          pri        (foreign key) for         for 
orderdetails - ordetailId,productid, quantity 수량, 
                orderid(foreign key)
customers - 고개정보, customerid (primary key)     
employees - employeeid(pri)
products  - productid(pri) 
shippers  - shippedid(pri)          |
suppliers - product에 묶임          
categories - product에 묶임

inner join - 교집합
left outer join - 왼쪽집합이 다 출력 
right outer join - 오른쪽집합이 다 출력 
cross join - 카테시안곱, 조인조건이 없을때 n by m 
self join - 자기 테이블 끼리 조인을 한다. 
*/
use w3schools;
select * from customers;

-- 고객이름이 Handel 이라는  사람이 있고 이분의 주문 내용을 확인 
select orderId, A.customerid, customername 
from customers A
join orders   B  on A.customerid=B.customerid
where customername like '%Handel%';
-- 제품명 -> orders, products , orderdetails 

-- 10258,10263,10351,10368,10382,10390,10402,10403,10430,10442
desc orderdetails;

-- 위에 Handle 이라는 분이 주문한 상품명을 확인하고 싶을때
select A.productId, quantity,  productName, A.orderId 
from orderdetails A 
join products B  on A.productid =B.productid
where orderid in (
	select orderId
	from customers A
	join orders   B  on A.customerid=B.customerid
	where customername like '%Handel%'
); 

-- inner join 의 경우에는 from 절 테이블과 join절 테이블 구분 필요
-- 없음 데이터 개수가 좀 작은테이블이 앞쪽에 오는것이 좋다. 권고 
-- 조인 - for문, nested loop join => hash join
-- where 조건절이 먼저 실행되서 우선 데이터를 거른다음에 조인을한다

-- left outer join : from절에 가까운 테이블 내용이 다 나오길 원할때
-- right outer join : from절에서 먼테이블 내용이 다 나오길 원할때 
-- full outer join :합집합, ansi 표준은 있는데 mysql없음 
-- cross join 
select A.customerId, B.orderId 
from customers A, orders B; 

-- selfjoin emp 테이블의 mgr 필드가 자기 상사의 사원번호임 
-- 동일테이블을 조인한다고 해서 self join - 코드테이블 만들때 
use mydb;

select * from emp;
-- emp A - mgr  , emp B - empno
select A.ename, A.mgr, B.ename 
from emp A 
left outer join emp B on A.mgr=B.empno;

use w3schools;

SELECT A.OrderID, B.CustomerName
FROM Orders A
INNER JOIN Customers B ON A.CustomerID = B.CustomerID;    

SELECT A.OrderID, B.CustomerName
FROM Orders A
INNER JOIN Customers B ON A.CustomerID = B.CustomerID
INNER JOIN Shippers C ON A.ShipperID = C.ShipperID;

select A.orderid, A.customername, c.shipperName 
from
(
	SELECT A.OrderID, B.CustomerName, A.shipperid 
	FROM Orders A
	INNER JOIN Customers B ON A.CustomerID = B.CustomerID
) A 
inner join shippers C on A.shipperid=C.shipperid;


SELECT A.OrderID, B.CustomerName, C.shippername
FROM Orders A , Customers B, Shippers C 
where A.CustomerID = B.CustomerID
      and  A.ShipperID = C.ShipperID;

-- join이 일반적으로 subquery 보다 빠르다 

-- Employees 테이블에 lastname 이 King 임 
-- 이사람이 팔은 내역을 확인하고 싶다 
-- 주문번호, 고객이름, 배달업자, 제품명   

select A.orderId, C.customername, F.shippername,
 E.productname
from orders A 
inner join employees B on A.employeeId = B.employeeId
inner join customers C on A.customerId=C.customerId
inner join orderdetails D on A.orderId=D.orderId
inner join products     E on D.productid=E.productid
inner join shippers     F on A.shipperid=F.shipperid
where B.lastname like 'King%'; 


-- union, union all 단순 합하기, 데이터 덧붙이기 
-- union 의 경우 중복 배제, union all -중복을 배제하지 않는다 
/*
   select column1, column2  from table1
   union all 
   select column1, column2  from table2
   필드개수와 타입만 맞으면 된다. 
   행 => 열로 바꿔야 할때 
   1
   2
   3
   4
      1 2 3 4
   포털, 국가 기관 검색어로 검색하면 각테이블로부터 검색한 내용을 전부 
   union 해서 갖고 온다 
*/ 

use mydb;
select empno, ename from emp 
union all 
select deptno, dname from dept;

select count(*) from emp 
union all 
select count(*) from dept;

use w3schools;
SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION ALL
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;

-- 나라별로 몇명의 고객이 있는가
-- 그룹함수중에 null값 처리부분이 조금씩 다르다 
-- count(필드명) 에 null값이 존재하면 카운트 하지 않는다 count(*) 
select count(*) -- 전체 고객수  
from customers;

select country, count(*)  -- 나라별로 몇명의 고객이 있는가 
from customers 
group by country;  
-- group by 절에 있던 필드만 select절에 올수있다

select country, count(*)  -- 나라별로 몇명의 고객이 있는가 
from customers 
group by country
order by count(*) desc;

-- 배달업체별로 주문 개수 
select shippername, count(*)  
from orders A 
join shippers B  on A.shipperid=B.shipperid
group by shippername; 
-- limit 10; 

--  주문번호 , 배달업체 , 배달업체 카운트 
select shippername, count(*)  
from orders A 
join shippers B  on A.shipperid=B.shipperid
group by shippername; 

-- 1. 이 쿼리 자체를 테이블로 orders테이블이랑 조인이 가능하다 
select AA.*, B.orderid 
from 
(
	select count(*) cnt, A.shipperid
	from orders A 
	join shippers B  on A.shipperid=B.shipperid
	group by shipperid
) AA
inner join orders B on B.shipperid=AA.shipperid;

-- 카운터가 정렬해서 3개만 => 분석함수(윈도우 함수) - ORACLE 

select A.shipperid, count(*) cnt  
from orders A 
join shippers B  on A.shipperid=B.shipperid
group by shipperid
order by count(*) desc
limit 2; 

-- 주문번호 , 배송업체번호, 카운트 
select orderid, B.shipperid, cnt 
from orders A 
inner join (
	select A.shipperid, count(*) cnt  
	from orders A 
	join shippers B  on A.shipperid=B.shipperid
	group by shipperid
	order by count(*) desc
	limit 2
) B  on A.shipperid=B.shipperid;

select orderid, shipperid,
 (select count(*) from orders B 
   where A.shipperid=B.shipperid) as cnt
 from orders A;

-- 디비접속 
-- select * from orders; 쿼리실행 
-- 디비 연결 끊음 
-- for order in orders 
--       디비접속 
--       select count(*) from orders where shipperid=order
--       디비끊음 


SELECT A.SupplierName
FROM Suppliers  A
WHERE EXISTS (
	SELECT 1 FROM Products B
    WHERE B.SupplierID = A.supplierID AND B.Price < 20
);

-- Exists 의 장점 : 서브쿼리의 모든 수행을 기다리지 않고 
-- 뭔가 하나 찾으면 바로 끝남 
-- 서브쿼리의 수행 결과셋 존재유무만 파악 

-- Any : 서브쿼리에서 오는 조건보다 하나라도 만족하는 항목이 있을경우 
--       부등호 or 부등호 or 부등호 or 
-- all : 부등호 and 부등호 and 부등호 and 
-- in  : 등호 or 등호 or 등호 or 
-- 프로그래밍 언어 mysql script 가 있어서 함수도 프로시저도 
-- 만들수 있다. mysql 만들었던 언어가 함수와 프로시저 
-- 함수는 반드시 반환값이 있다. 프로시저는 반환값이 없다. 
-- mysql의 내장함수
-- 대부분의 dbms들은  select절은 from절 못빠짐 
-- 오라클 같은 경우에는 dummy table이 있다. 가짜 
-- select sysdate from dummy;
-- 함수도 표준이 없어서 dbms마다 다르다   
select now();

select now() from customers;  
-- customers 테이블 데이터 개수만큼 호출된다. 
 
 
select * from customers 
where customername like '%Around%';

select concat("Tom ", "is", " a student") as sentence;
select concat(address, " ", postalcode, " ", city) address
from customers;

select ltrim("     hello    ") a, "***";
select rtrim("     hello    ") a, "***";
select trim("     hello    ") a, "***";
-- 대부분의 dbms가 문자열인덱스를 1부터 시작한다.
select substr("Hello mysql", 7, 5);
select substr("2025-05-20", 1,4) year, 
       substr("2025-05-20", 6,2) month, 
       substr("2025-05-20", 9,2) day;

-- ceil : 올림함수   데이터개수가 231개 -> 23.1 
-- floor : 내림함수        
-- interval 간격 
SELECT ADDDATE("2017-07-27", INTERVAL 10 DAY);
SELECT ADDDATE("2025-12-27", INTERVAL 6 DAY);
SELECT ADDDATE("2017-06-15 09:34:21", INTERVAL 15 MINUTE);

SELECT DATEDIFF("2017-06-25", "2017-06-30");

use mydb;
desc dept;
select * from dept;

-- 테이블 구조가 간단할경우에는 필드명을 생략할 수 있다 
-- desc에 나온 필드 목록 하고 동일한 구조로 저장해야 한다 
insert into dept values(50, '개발1부', '서울');
select * from dept;

insert into dept(deptno, dname) values(60, '개발2부');
select * from dept;
 
desc emp;

insert into emp(empno) values(9000);

-- 규칙에 위배되는 데이터를 삭제하자 
delete from emp where sal is null;
-- delete명령어 안전장치가 되어 있는 dbms 가 있다. - 오라클 

desc emp;
-- 테이블을 수정했음 sal필드와 ename 필드를 not null로 하기로 
insert into emp(empno) values(9000); -- error 
insert into emp(empno, ename, sal) 
values(8000, '홍길동', 3300);

-- 한번에 여러명 넣기 
insert into emp(empno, ename, sal) 
values(8001,'둘리', 3200),
      (8002,'도우너', 3200),
      (8003,'또치', 3200);

-- 데이터에 ' 가 들어가야 할때  ==> '' 
-- 'Toms'family' ==> 'Tom''s family' 
-- 'Jane' ===> '''Jane'''
insert into emp(empno, ename, sal) 
values(8004,'Tom''s', 3200),
      (8005,'''jane''', 3200);
      
select * from emp;

-- 서버 : 서비스를 제공하는 측(하드웨어 또는 소프트웨어)
-- 클라언트 : 서비스를 제공받는 측(하드웨어 또는 소프트웨어)
-- 서비스(ms),리눅스(daemon)- 화면 ui 제공안하고 조용히 
-- 작동중   

 -- 테이블을 만들기 , 테이블 복사 명령어가 없음 
 -- create table 테이블명 (컬럼1 타입, 컬럼2 타입 ,,,);
 create table emp2 as select * from emp; 
 -- 서브쿼리를 써서 테이블을 복사할 수 있다. 
 -- 제약조건은 안데려감(primary, foreign key는 버리고옴 ) 
 desc emp2;  
 select * from emp2;
 -- 구조만 복사하기 
 create table emp3 as select * from emp where 1=0; 
 desc emp3;  
 select * from emp3;
 
create table emp4 as 
select empno, ename, sal 
from emp where deptno in (10,20); 
 
insert into emp3 (empno, ename, sal) 
select empno, ename, sal 
from emp;

select * from emp3;

use w3schools;
-- 문제1. customers 테이블의 구조를 복사한 후 customers2로 
-- 만들고 고객 아이디중에 3,23,21,45,67,89,54 복사하기 

-- 문제2. 고객아이디중에 4,5,11,33,42,43,56,57,58번을 이동하기 
--        customers -> customers2 로 옮기기 
-- 

















































































