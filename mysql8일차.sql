
use sakila;
-- 없으면 만들고 있으면 수정해라 
-- mysql 5이상일 때 지원함 
create or replace view v_customer as 
select concat(a.last_name, " ",a.first_name) customer_name
, postal_code, district, phone, location, address
from customer a 
join address b on a.address_id=b.address_id;

-- 가상의 테이블 
select * from v_customer
where customer_name like '%smith%';

show index from customer;

use w3schools; 
select * from orderdetails;
select sum(quantity) from orderdetails;

select orderid, sum(quantity)  
from orderdetails
group by orderid;

select sum(quantity) over() from orderdetails;

select productid, orderid , 
 sum(quantity) over(
 partition by orderid
 order by orderid) total 
from orderdetails;

-- rows between 
-- unbounded preceding  처음부터 
-- current row  현재행 
-- N preceding  현재행에서 n행이전 
-- N following     현재행에서 n행이후 
-- unbounded following 맨 끝까지

-- 오라클 10버전부터 지원 -> mssql -> mysql 

-- 석차 rank() 
-- quantity 로  rank는 동일한 등수가 있으면 
-- 건너뜀, dense_rank - 안건너뜀
select orderid, quantity, 
	rank() over(order by quantity desc) as r
    ,dense_rank() over(order by quantity desc) 
    as r2
from orderdetails;

-- ntile 균등분할 
select orderid, ntile(4) over() grade 
from orderdetails; 

-- 게시판 , primary key로 auto_increment단점 
-- 중간에 데이터가 삭제되었을 때 번호가 구멍이 나요 
-- 번호를 일시적으로 다시 붙여서 다시보여준다 
select orderid, row_number() 
			over(order by orderid desc)
            rnum 
from orderdetails;

select orderid, row_number() 
			over(order by orderid desc)
            rnum 
from orderdetails
limit 10;

select orderid, row_number() 
			over(order by orderid desc)
            rnum 
from orderdetails
limit 11,10;

select quantity, sum(quantity) over
( rows between 1 preceding and 1 following) as q
,sum(quantity) over
( rows between 1 preceding and current row) as q2
from orderdetails; 






