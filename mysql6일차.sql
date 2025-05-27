-- 데이터베이스 생성 
create database project1; 
create user 'user03'@'localhost' identified by '1234';
grant all privileges on project1.* to 'user03'@'localhost';


use project1;
-- 회원테이블 
create table tb_member(
	-- mysql은 auto_increment 속성있는 필드가 무조건 primary key가
    -- 되어야한다. 
    member_id bigint auto_increment primary key,
	user_id varchar(40),
	password varchar(300), -- md5 암호화 알고리즘을 써서 암호화 해서 
                           -- 저장
	user_name varchar(40),
    email varchar(40),
    phone varchar(40),
    regdate datetime
); 
-- 게시판테이블 

insert into tb_member(user_id, password, user_name, 
email, phone, regdate) values('test1', '1234', '홍길동', 
'hong@daum.net', '010-0000-0001', now());

select count(*)  from tb_member where user_id='test1';


