use mydb2;
show tables;  -- mysql 용 
/*player -- 선수들 
schedule -- 스케줄 
stadium  -- 경기장 정보
team -- 팀정보 */
desc team;

select count(*) from team;  -- 팀이 15개 이다

select * from team;

-- 1. team_id=K01 인 선수들의 명단을 확인하고 싶다.
select * from player where team_id='K01';

-- 2. K01 팀의 정보 백번호로 정렬해서 입단연도 오름차순,
--    이름 오름차순  해서 보여주기(player_name, join_yyyy, posit 
select player_name, join_yyyy, posit 
from player 
where team_id='K01'
order by join_yyyy, player_name;  -- null값은 판단 불가라 맨처음에 나온다 

select * from 
(
	select player_name, ifnull(join_yyyy, 5000) join_yyyy, posit 
	from player 
	where team_id='K01'
) as AA
order by join_yyyy, player_name;  -- null값은 판단 불가라 맨처음에 나온다 

select player_name, join_yyyy, posit 
from player 
where team_id='K01'
order by join_yyyy desc, player_name;  

-- 고객이 3명을 따로 처리하기를 원해 

-- union all - 부분집합끼리 order by 안됨 
-- 행의 순서 보장하지 않는다.   
select player_name, join_yyyy, posit 
from player 
where team_id='K01' and join_yyyy is null 
union all 
select player_name, join_yyyy, posit 
from player 
where team_id='K01' and join_yyyy is not null
order join_yyyy, player_name; 
-- 의미없음 

-- 
select player_name, join_yyyy, posit 
from player 
where team_id='K01'
order by join_yyyy is null asc, join_yyyy asc, player_name;

-- 울산 지역에 있는 모든 팀과 각 팀에 속한 선수이름과 우편번호 주소를 출력하자
-- 조인으로   682-060 
-- 울산현대   곽기훈  울산  682-060  울산광역시 동구 서부동 산137-1 
--                    현대스포츠클럽하우스

select * from team limit 3;

select B.team_name, A.player_name, B.region_name, 
	concat(B.zip_code1,"-", B.zip_code2) zipcode,
    B.address
from player A 
inner join team B on A.team_id=B.team_id
where region_name='울산'; 


-- team_id 가 K01 이거나 K03 인 선수의 팀이름 팀주소, 선수이름 
select B.team_name, A.player_name, B.address
from player A 
inner join team B on A.team_id=B.team_id
where A.team_id in ('K01', 'K03'); 

-- 서브쿼리 
-- select 절에서 사용하는 서브쿼리는 스칼라 서브쿼리만 된다. 
-- 스칼라 -> 쿼리 실행결과가 달랑 값 하나 
-- select count(*) from team;
 
select A.player_name, 
	(select team_name from team where team_id=A.team_id) team_name,
    (select address from team where team_id=A.team_id) address,
    (select concat(zip_code1, "-", zip_code2)  
    from team where team_id=A.team_id) zipcode
from player A  
where A.team_id in ('K01', 'K03'); 

select team_name from team where team_id='K01';  

select team_id from team;  -- K01 ~ K15 



-- 그냥 조인 쓰자 
select A.player_name, 
	(select team_name from team where team_id=A.team_id) team_name,
    (select address from team where team_id=A.team_id) address,
    (select concat(zip_code1, "-", zip_code2)  
    from team where team_id=A.team_id) zipcode
from player A 
where team_id in (select team_id from team where region_name='울산'); 

create table test 
( 
	id bigint,
    title varchar(50)
);

insert into test(id, title) values(1, '제목1');
select * from test;

select max(id)+1 from test;
-- 오라클은 가능, mysql 은 불가능 - XXXX
insert into test(id, title) values((select max(id)+1 from test), 
'제목2');
-- 자동증가 , auto_increment 

-- player이름, 팀이름, 경기장 이름  K05, K07, K12 구단 
-- 팀이름으로 정렬, 백넘버로 정렬 
select A.player_name, B.team_name, C.stadium_name 
from player A 
left outer join team B on A.team_id=B.team_id 
left outer join stadium C on B.stadium_id=C.stadium_id
where A.team_id in ('K05', 'K07', 'K12')
order by B.team_name, A.back_no;

-- 조건문을 사용가능 case 문 
/*
	case 필드명 
          when '값1' then 반환값1
          when '값2' then 반환값2
          when '값3' then 반환값3
		  else 반환값4 
	  end; 
	   case 
          when 조건식1 then 반환값1
          when 조건식2 then 반환값2
          when 조건식3 then 반환값3
		  else 반환값4 
	  end; 
*/ 
-- position GK-골기퍼 , DF-수비수, FW-공격수 MF -미드필더, null 없음  
desc player;

select player_name,  case posit 
                           when 'GF' then '골키퍼' 
                           when 'DF' then '수비수'
                           when 'FW' then '공격수'
                           when 'MF' then '미드필더'
                           else '없음'
					end as posit 
from player where team_id='K01';

select player_name,  case  
                           when posit='GF' then '골키퍼' 
                           when posit='DF' then '수비수'
                           when posit='FW' then '공격수'
                           when posit='MF' then '미드필더'
                           else '없음'
					end as posit 
from player where team_id='K01';

-- 키가 190 넘으면 A 
-- 키가 180 넘으면 B 
--  나머지        C 
-- 선수이름, 키, 등급   team_id가 K03일때    

select player_name, height, case when height>190 then 'A'
                                 when height>180 then 'B' 
								 else 'C'
							end grade 
from player where team_id='K03';

use mydb;
-- 부서번호 10 -> 총무부 20 홍보부  30 개발1부  40 개발2부
-- 이름이랑 부서만 
select ename, case deptno when 10 then '총무부'
                          when 20 then '홍보부' 
                          when 30 then '개발1부'
                          when 40 then '개발2부' 
			 end dname 
from emp;

use mydb2;

-- 각 팀별로  키가 180 이상인 선수의 숫자를 출력하기 
-- team_name, 인원수 
select team_id, count(*) cnt 
from player 
where height>=180
group by team_id;

-- 서브쿼리로 해결 
select team_id, count(*) cnt, 
(select team_name from team where team_id =player.team_id) team_name
from player 
where height>=180
group by team_id;

select team_name, cnt
from (
	select team_id, count(*) cnt 
	from player 
	where height>=180
	group by team_id
) as A 
join team B on A.team_id=B.team_id;

select team_name, cnt
from team A
join (
	select team_id, count(*) cnt 
	from player 
	where height>=180
	group by team_id
) as B  on A.team_id=B.team_id;

-- 문제 : FC서울의 전체 일정을 출력하기 홈일정 away일정 까지  포함해서
-- schedule 
select * from schedule;

-- 1. FC서울의 stadium_id를 알아와야 한다 
-- HOMETEAM_ID , AWAYTEAm_id 로 찾아봐야 한다 
select team_id from team where team_name='FC서울';

select sche_date, B.team_id, B.team_name
from schedule A
join team  B
on A.hometeam_id =B.team_id or awayteam_id=B.team_id
where team_name='FC서울';

select sche_date, B.team_id, B.team_name, 'home' as home 
from schedule A
join team  B    on A.hometeam_id =B.team_id
where team_name='FC서울' 
union all 
select sche_date, B.team_id, B.team_name, 'away' as home 
from schedule A
join team  B    on A.awayteam_id =B.team_id
where team_name='FC서울';

-- 2012년 10월 19일날 C06스타디움과 C05스타디움에서 경기하는 선수들 이름과 
-- 팀명을 출력하시오.
-- player , team , stadium 
select A.player_name, team_name  
from player A
join team B  on A.team_id=B.team_id
join schedule C on C.hometeam_id =B.team_id or C.awayteam_id=B.team_id
where C.stadium_id in ('C05', 'C06') and C.sche_date='20121019'
order by A.team_id;  
 
-- DCL - 통제, 권한을 주고 받는등의 쿼리   
-- DML - insert, update, delete , select (조회) 
-- DDL - 데이터 구조 정의어, create , drop, alter 
/*create table 테이블명 
( 
   id int primary key auto_increment,
   title varchar(20)

);*/  
/*
CREATE TABLE `tb_member` (
  `member_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `member_name` varchar(45) NOT NULL,
  `member_phone` varchar(45) NOT NULL,
  `member_email` varchar(45) NOT NULL,
  `member_ip` varchar(45) DEFAULT NULL,
  `regdate` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 
COLLATE=utf8mb4_0900_ai_ci;
*/
/*INSERT INTO `mydb2`.`tb_member`
(`member_id`,
`user_id`,
`password`,
`member_name`,
`member_phone`,
`member_email`,
`member_ip`,
`regdate`)
VALUES
(<{member_id: }>,
<{user_id: }>,
<{password: }>,
<{member_name: }>,
<{member_phone: }>,
<{member_email: }>,
<{member_ip: }>,
<{regdate: }>);
' - 어포스트로피 
` - 틸트  
*/

-- insert 명령어를 통해서 데이터 추가시 
-- auto_increment 는 빼고 넣자
-- Not Null 조건 필드는 다 넣자  
insert into tb_member( user_id, password, member_name, 
   member_phone, member_email, regdate) 
   values('user01', '1234', '홍길동', '010-0000-0001', 
          'hong@gmail.com', now());
-- 등록시 디비 서버의 날짜와 시간 을 알려준다 
  
use mydb2;  

select * from schedule; 

-- 스타디움, 스케줄,  승부 
--                    홈팀이김 
-- 				   어웨이팀이김 
--                    무승부
                   
select stadium_id, sche_date, 
	case when home_score > away_score then '홈팀이김'
		 when home_score < away_score then '어웨이팀이김'
         else '무승부'
	end 승부,
    case when home_score > away_score then hometeam_id
		 when home_score < away_score then awayteam_id
         else 'None'
	end 이긴팀 
from schedule;


     


