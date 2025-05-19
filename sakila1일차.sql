#mysql -u root -p 디비명 > ... sql 백업  
#mysql -u root -p < /경로/사킬라/sakila-schema.sql
#mysql -u root -p < /경로/사킬라/sakila-data.sql

use sakila;

desc actor;
select count(*) from actor;
select * from actor limit 0, 10; -- limit 옵셋, 개수 
select * from actor limit 10, 10; -- limit 옵셋, 개수 

select * 
from actor;

select * 
from actor
where last_name='DAVIS';

desc customer; -- 필드명 확인하려고 
select * 
from customer 
order by email; 

desc film; -- title, rental_rate 
select title, rental_rate 
from film;

select first_name, last_name, email
from customer;

desc category;
select category_id, name 
from category;

select * from film limit 5;

select * from film where length >= 180;

-- 9. 대여 요금이 4.99 이상인 영화 중에서 제목(title)과 요금(rental_rate)을 내림차순 정렬하시오.
select title, rental_rate 
from film 
where rental_rate >= 4.99 
order by rental_rate desc;

-- 10. 대여(rental) 중 2005년에 이루어진 기록만 조회하시오.
select * from rental 
where rental_date>='2005-01-01' 
and rental_date>='2005-12-31';

-- 문자열을 자르는 함수 substring 
-- python 이나 java 0부터 시작된다. 디비는 1부터 
-- substring (시작위치, 개수) 1번부터 
select rental_date, substring(rental_date, 1,4) 
from rental;

select * from rental
where substring(rental_date,1,4) = '2005';
 
-- 11. 고객 중 이름이 'S'로 시작하는 고객의 이름을 조회하시오.
select * from customer 
where last_name like 'S%';

select * from actor 
where length(last_name)=5;
-- 12. 배우(actor) 테이블에서 이름이 5글자인 배우만 찾으시오.

-- 최소한 두개이상의 테이블을 조인해야 한다 
-- select * from category where name='comedy';
-- select title from film where category_id=5;
/*
[기초 조회]
1. 모든 배우(Actor)의 이름과 성을 조회하시오.
2. 배우 테이블에서 성(last_name)이 ‘DAVIS’인 사람을 모두 찾으시오.
3. 고객(Customer)의 이메일 목록을 알파벳 순서로 조회하시오.
4. 영화(film)의 제목과 대여 요금(rental_rate)을 조회하시오.
5. 고객(Customer)의 이름, 성, 이메일을 각각 출력하시오.
6. 카테고리(category)별 이름과 ID를 출력하시오.

[조건과 정렬]
7. 길이가 180분 이상인 영화 제목을 조회하시오.
8. ‘Comedy’ 카테고리에 속한 영화 제목을 모두 조회하시오.
9. 대여 요금이 4.99 이상인 영화 중에서 제목(title)과 요금(rental_rate)을 내림차순 정렬하시오.
10. 대여(rental) 중 2005년에 이루어진 기록만 조회하시오.
11. 고객 중 이름이 'S'로 시작하는 고객의 이름을 조회하시오.
12. 배우(actor) 테이블에서 이름이 5글자인 배우만 찾으시오.

*/

/*
무결성 - 결함이 없는 성격 
중복성 배제 - 데이터의 중복 배제 
일관성 - 데이타가 중복도 없고 일관성이 있다 

primary key 개념을 제공한다. - primary key는 특정 필드 또는 
여러개의 필드를 묶어서 중복성을 배제하고 NULL값도 갖지 못하도록 
제약하는 특성을 갖는다. 
사번, 학번, 주민번호등(이미 중복된 사람 20000 있음) 사용못함 
필드의 성격에 auto_increment 자동증가, mssql에서는 일련번호,
오라클은 시퀀스라는 객체 mysql은 auto_increment 속성이 있는 필드가 
primary key여야 한다.   
*/
use mydb;
desc emp;
-- empno 필드가 primary key로 되어 있다. 
insert into emp (empno, ename) values (8000, '홍길동');
insert into emp (empno, ename) values (8000, '임꺽정'); 
--	Error Code: 1062. Duplicate entry '8000' for key 'emp.PRIMARY'	0.000 sec
-- 테이블을 만들때 primary key를 지정할 수도 있고 테이블 다 만들고
-- 지정할 수도 있다.
-- 일부 데이터를 먼저 테이블에 넣어놓고 primary key 지정할때 
-- 이미 들어가 있는 데이터가 중복이되거나 null값이 있으면 PRIMARY KEY
-- 지정 못함 
-- 필드 하나로 PRIMARY키를 지정할 수도 있고 필요하면 
-- 여러개의 필드를 묶어서 하나의 PRIMARY KEY를 지정할 수 있다
-- 단, 하나의 테이블에 한개만 지정가능하다 
-- 기본적으로 검색이 순차검색임, 한개씩 읽어서 검색한다. 
-- 오라클은 병행처리 , 한번에 여러개 읽는다. 
-- 색인순차검색, 색인표를 만들어서 검색한다. PRIMARY KEY 를 지정
-- 하면 자동으로 색인(INDEX)를 만들어준다.
-- 8000 번이 이미 있어서 에러발생 


