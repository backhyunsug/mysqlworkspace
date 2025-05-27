use mydb;
select * from emp;
delete from emp where empno=8005;
select * from emp;

start transaction;  -- 여기서부터 트랜잭션시작 
delete from emp;
select * from emp;
rollback; -- 원상복구 
select * from emp;
update emp set  ename='조승연' 
where empno=8004;
commit;
select * from emp;

-- 계정만들기`
-- locahost - 루프백주소(127.0.0.1)
-- 'user02'@'localhost' 로컬서만 접근가능한 
-- 계정이다  
drop user 'user02'@'localhost' ;
create user 'user02'@'localhost' identified by 'qwer1234';
grant all privileges on mydb.* to 'user02'@'localhost';
-- grant 권한목록 on 디비명.테이블명 
 
select empno, ename from emp; 

desc emp;

create table tb_score(
	id bigint primary key auto_increment,
    sname varchar(20) not null, 
    kor int not null,
    eng int not null,
    mat int not null,
    regdate datetime);

insert into tb_score(sname, kor,eng,mat,regdate)
values('홍길동', 90,90,90, now());    

select sname, kor, eng, mat, 
(kor+eng+mat) as total, 
date_format(regdate, '%Y-%m-%d %H:%i:%s') regdate  
from tb_score; 

-- 전체보기 
-- 추가 : 입력받아서  
-- 수정 
-- update 테이블명 set 필드1='값1' , 필드2='값2' where절
-- 삭제 
-- delete from 테이블명  where id=1 
-- 검색

DELIMITER //

CREATE PROCEDURE insert_scores()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 30 DO
        INSERT INTO tb_score (sname, kor, eng, mat, regdate)
        VALUES (
            CONCAT('A', i),         -- 이름: A1, A2, ..., A10
            80 + i,                 -- 국어 점수
            70 + i,                 -- 영어 점수
            60 + i,                 -- 수학 점수
            NOW()                   -- 등록일
        );
        SET i = i + 1;
    END WHILE;
END //


call insert_scores();

select count(*) from tb_score;













