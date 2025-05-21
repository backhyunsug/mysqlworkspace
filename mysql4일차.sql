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

-- player이름, 팀이름, 경기장 이름  K05, K07, K12 구단 
-- 팀이름으로 정렬, 백넘버로 정렬 


-- 그냥 조인 쓰자 
select A.player_name, 
	(select team_name from team where team_id=A.team_id) team_name,
    (select address from team where team_id=A.team_id) address,
    (select concat(zip_code1, "-", zip_code2)  
    from team where team_id=A.team_id) zipcode
from player A 
where team_id in (select team_id from team where region_name='울산'); 






