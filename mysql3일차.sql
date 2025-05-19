use sakila; 

-- actor_id, first_name, last_name 
select * from actor limit 10; 
select * from film limit 10;
-- 어떤 배우가 어떤 영화에 출연했는지 알고싶다 
select * from film_actor limit 10;

-- 영화 필름 기준으로 join 
select title, description, actor_id 
from  film A 
left outer join film_actor B  on A.film_id=B.film_id;

select title, description, B.actor_id, 
concat(c.last_name, " ", c.first_name) actor_name   
from  film A 
left outer join film_actor B  on A.film_id=B.film_id
left outer join actor C  on B.actor_id=C.actor_id;

--  category가 Comedy인 영화 목록만 
-- film, category, film_category 
select title 
from film A 
left outer join film_category B on A.film_id=B.film_id
left outer join category C on B.category_id=C.category_id
where C.name = 'Comedy';

-- 고객의 이름과 고객이 대여한 영화 제목을 모두 출력하자
-- customer, rental, inventory, film
-- inventory_id, store_id, film_id 

select * from inventory limit 10;  
select * from customer limit 10; 
select * from rental limit 10; 
select * from film limit 10; 

select concat(A.last_name, A.first_name) name, D.title
from customer A 
left outer join rental B on A.customer_id=B.customer_id 
left outer join inventory C on B.inventory_id=C.inventory_id
left outer join film D on D.film_id=C.film_id;

-- 문제2. NICK WAHLBERG 라는 배우가 출연한 영화의 제목 조회하기 
select title 
from actor  A 
inner join film_actor B on A.actor_id=B.actor_id 
inner join film C on B.film_id = C.film_id
where A.first_name='NICK' and A.last_name='WAHLBERG';

-- 문제3. "London' 도시의 고객이름만 출력 

select first_name 
from customer A 
join address B on A.address_id=B.address_id
join city C on B.city_id = C.city_id 
where c.city='London';

--  join속도를 빠르게 하려면, join필드에 인덱스를 만들어줘야 한다.

-- 서브쿼리 : 서브쿼리는 주 쿼리 옆에서 주쿼리 보다 먼저 실행되서 결과를 가져
--          온 다음에 주쿼리가 실행된다. 
-- 서브쿼리는 select 절, from 절, where, order by 절등 다 가능하다 
-- select 절 : 스칼라 서브 쿼리 , 결과값이 null 이거나 한개만 가져오는 쿼리 
-- join을 대체할 수 있다. 우리가 볼때 편해보임, 조인이 일반적으로 더 빠르다
-- 가급적 join으로 해결하고 join 이 안될때 서브쿼리를 사용하자 
use mydb;  -- mydb로 사용 이동하기 
-- 사원번호, 사원이름, 부서명을 가져오려고 한다 
select empno, ename, deptno -- 서브쿼리를 이용해 부서명을 가져오자  
from emp;

select dname from dept where deptno=10;

select empno, ename, deptno,
(select dname from dept where dept.deptno=emp.deptno) as dname
-- 서브쿼리를 이용해 부서명을 가져오자  
from emp;



select empno, ename, deptno,
(select dname from dept B where A.deptno=B.deptno) as dname
-- 서브쿼리를 이용해 부서명을 가져오자  
from emp A;

use sakila;

select first_name, last_name, B.film_id 
from actor A
left outer join film_actor B on A.actor_id=B.actor_id;
   
select first_name, last_name, 
(select title from film C where B.film_id=C.film_id) as title  
,(select length from film C where B.film_id=C.film_id) as length  
from actor A
left outer join film_actor B on A.actor_id=B.actor_id;

-- from 절에서 : 다중행을 반환한다. 다중행 서브쿼리, 인라인뷰 
use mydb;

-- select * from emp where deptno in(10, 20) 에서 사원이름, 부서명 

select A.ename, dname 
from ( 
	select * from emp where deptno in (10, 20)
) as A
join dept B on A.deptno=B.deptno; 

use sakila;

-- film_id : ambigous 
select A.film_id, title, length, actor_id 
from film A 
left outer join film_actor B on A.film_id=B.film_id;

select first_name, last_name, title 
from actor A 
left outer join(
	select A.film_id, title, length, actor_id 
	from film A 
	left outer join film_actor B on A.film_id=B.film_id
    -- inline view 
) B  on A.actor_id= B.actor_id;

-- where 절 
use mydb; 

-- emp 테이블에 smith 라는 사람의 부서와 같은 부서에 있는 사람들 정보 
select deptno from emp where ename='SMITH';
-- where 조건절에 오는 서브쿼리가 데이터가 여러개일때 
-- 단일행인경우와 다중행인 경우 처리방법이 다르다 
select * from emp where deptno=20;  

select * from emp 
where deptno=(select deptno from emp where ename='SMITH');

-- smith 가 근무하는 부서의 급여 평균보다 급여를 받는 사람들 정보를 확인하고자 한다 
select avg(sal) from emp 
where deptno=(select deptno from emp where ename='SMITH');

select ename, sal from emp 
where sal > ( select avg(sal) 
             from emp where deptno =
(select deptno from emp where ename='SMITH'));

-- 부서 평균 급여보다 급여가 많은 사원 조회 
select * from emp 
where sal > ( select avg(sal) from emp); 
 
-- 가장 높은 급여를 받는 사원 정보 조회하기 max 
select * from emp 
where sal >= ( select max(sal) from emp); 

-- 매니저가 존재하는 사원만 조회 

select * from emp; -- mgr필드에 자기 상관 정보가 있다. 
-- 나의 mgr 필드가 emp 테이블에 존재하는냐 
select * from emp where mgr in( select empno from emp);

-- 상관쿼리 : 외부 쿼리의 값을 내부쿼리에서 참조하는 서브쿼리를 말한다 
-- 외부쿼리의 각 행마다 내부쿼리가 실행되는 구조 
-- exists, any , all, in 등이 있다 
-- exists - 서브쿼리의 실행결과가 하나라도 있으면 True 한개없으면 False 반환
--          서브쿼리의 실행 결과가 한건이라도 있으면 실행된다.             

-- Any - 조건을 맞족하는 게 하나라도 있으면 수행 
--       부등호 or 부등호 or 부등호 or 부등호 or 부등호
-- All - 모든 조건을 만족하는 
--       부등호 and 부등호 and 부등호 and 
-- in  - 등호 or 등호 or 등호 or        
 
-- 부서별 평균 급여보다 높은 사원조회 
-- 부서별 평균값이 필요 
select avg(sal) from emp where deptno=10;
select avg(sal) from emp where deptno=20;
select avg(sal) from emp where deptno=30;
select avg(sal) from emp where deptno=40; 


select empno, sal, deptno from emp;

-- 부서번호 10이 서브쿼리의 외부 쿼리에서 가져와야 한다 
select empno, sal, deptno from emp A
where sal > (select avg(sal) from emp B where B.deptno=10);

-- 외부의 A의 deptno 와 서브쿼리(내부쿼리)의 deptno가 서로 관계가 잇있다
-- 상관쿼리 
select empno, sal, deptno from emp A
where sal > (select avg(sal) from emp B where B.deptno=A.deptno);

-- exists - 매니저가 존재 하는 사원만 조회 
select empno, ename, mgr from emp;  
select ename from emp where mgr=7902;
-- 서브쿼리의 실행결과가 하나라도 있으면 외부쿼리를 실행한다 
-- 서브쿼리의 결과 유무만 따진다. 
-- select * from emp where exists (서브쿼리)

select empno, ename, mgr from emp A
where exists ( 
	select 1 from emp B where A.mgr=B.empno
);
use sakila;
-- 서브쿼리를 활용해서 title가져오기 
select concat(A.last_name, A.first_name) name, 
(select title from film D where C.film_id=D.film_id) as title 
from customer A 
left outer join rental B on A.customer_id=B.customer_id 
left outer join inventory C on B.inventory_id=C.inventory_id;

-- left outer join film D on D.film_id=C.film_id;

-- 문제2. NICK WAHLBERG 라는 배우가 출연한 영화의 제목 조회하기 
select (select title from film C where B.film_id=C.film_id) title 
from actor  A 
inner join film_actor B on A.actor_id=B.actor_id 
where A.first_name='NICK' and A.last_name='WAHLBERG';

use w3schools;

select * from customers limit 10;

-- 주문번호, 고객이름, 판매자이름  
desc orders;
desc customers;
desc employees;

select A.*, B.customerName, 
concat(C.lastName," ", C.FirstName) as EmployeeName 
from orders A 
join customers B on A.customerId=B.customerId
join employees C on A.employeeId=C.employeeId;

-- join 안쓰고 subquery로 바꾸기 
select OrderId  ,
 (select customerName from customers B 
 where A.customerId=B.customerId) as customerName  
 ,
(select concat(C.lastName, " ", C.firstName) 
 from employees C 
where A.employeeId=C.employeeId) as employeeName  
from orders A;

-- 주의사항, linux mysql은 필드명이나 테이블명의 대소문자
-- 를 따진다.  

-- 그룹함수, avg, max, min, count, sum ....
use mydb;

-- ename, sal필드는 데기터 개수만큼 , avg(sal)-한개 
-- select ename, sal, avg(sal) from emp; -- 에러 

select ename, sal, (select avg(sal) from emp) avg_sal
from emp;

-- 부분합, 그룹별로 묶는게 가능하다. 
-- 각 부서별로 급여 평균을 확인하고 싶다
-- 그룹함수는 group by 절에 온 필드는 사용가능   
select deptno, avg(sal)
from emp 
group by deptno;

-- 이름과 부서번호 급여 부서별 평균을 확인하고 싶다 
select ename, deptno, 
	(select avg(sal) from emp B where A.deptno=B.deptno)
    dept_sal
from emp A;

-- 서브쿼리와 join합치기 
select ename, A.deptno, dept_sal, sum_sal, max_sal, min_sal 
from emp A 
left outer join( 
	select deptno, avg(sal) dept_sal, sum(sal) sum_sal,
    max(sal) max_sal, min(sal) min_sal
	from emp 
	group by deptno) B
on A.deptno=B.deptno;

use w3schools;

-- orders 테이블에서 고객별 주문 개수구하고  정렬 주문수가 많은 고객부터 내림차순
-- 고객이름, 주문카운트 
select customerId, count(customerId) 
from orders 
group by customerId
order by count(customerId) desc; 
-- where 절에는 group 함수 사용못함 
-- 구매개수 5개 이상만 출력
select customerId, count(customerId) 
from orders 
group by customerId 
having count(customerId)  >=5   -- where절은 그룹함수사용못함 
order by count(customerId) desc;

-- 오늘의 과제 
-- 1) 주문이 한번도 없는 고객의 이름을 조회하기 
-- 2) 가장 주문건수가 많은 판매자 이름 구하기 
-- 3) 판매건수가 5건  이상인 판매자 인원수 


 



 







