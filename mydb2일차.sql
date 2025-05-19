제약조건 
/*1. primary key - 중복안되고 null값을 갖지 않아야 한다 
    이 조건을 만족해야만 primary key를 줄 수 있다
    예)회원아이디 - 예전에는 회원아이디를 primary key로 한다 
                  수정불가 
      아이디 변경 가능 사이트들은 별도의 일련번호를 부여해서 
      이 번호를 primary key로 하고 회원아이디 unique-key 
      unique 제약조건은 중복은 허용 안하지만 null값 허용 가능
  테이블의 primary key는 하나만 줄 수 있다. 여러개의 필드를 
  묶어서 하나의 primary key를 지정하는 경우도 있다 

2. foreign key (외부키) - 테이블과 테이블의 관계성에 입각해서 
상호 제약을 가하고자 할때 
테이블을 나누는 구조(정규화 1,2, bnf정규화)
실무에서 바라볼때  1 : N의 관계일때 테이블을 나눈다 
고용인 , 부서테이블 - 각 직원마다 부서명을 따로 저장한다. 메모리가 많이 든다
                 - 부서명 바꿀때마다 직원마다 부서명 바꾸러 다닌다.
                   (오버헤드-쓸데없는일), 실수로 한명 빼고 바꾸면 
                   한분만 홍보부 나머지 -> 마케팅부 
                   일관성이 없다. 
                   테이블을 나누자 -메모리부족해결, 부서코드
                   history테이블을 만든다.
                   일관성을 유지하기 위해서 foreign key를 설정한다 
    
emp 테이블의 deptno            dept 테이블의 deptno(primary 또는 unique) 

emp 테이블에서 foreign key를 dep 테이블에 걸어준다
emp 테이블의 deptno 필드에는 dept테이블의 deptno 필드내에 있는 값만 넣을 
수 있다  (부서번호가 10,20,30,40 )
emp 테이블의 부서번호 50 넣으면 그런 부서번호 없음 
dept 테이블 입장에선  부서번호 삭제 불가능 - 이미 사용중인 부서번호 삭제 불가 

-- primary key 추가 삭제 - mysql 
-- alter 수정할때 
-- primary key 삭제명령어 - mysql만 
alter table 테이블명 drop primary key;
--- primary key 추가명령어 - mysql만
alter table 테이블명 add constraint 키이름 primary key(필드명);
*/



use mydb;

-- emp 테이블의 정보를 확인하고 primary key가 존재하면 삭제하려고 한다 
select * from emp limit 10;
desc emp;  -- empno가 primary 임 
insert into emp(empno, ename) values(8000, '장길산');
alter table emp drop primary key; -- primary key를 삭제한다 
desc emp; 
insert into emp(empno, ename) values(8000, '장길산');

select * from emp; 
-- primary key 지정은 불가능하다. 이유: empno 필드값이 이미 중복상태 
alter table emp add constraint pk_emp primary key(empno);
-- edit - preference - sql editor - 하단에 safe updates 체크해제하고 재시작 
-- 기본적으로 update delete 명령을 막아놓음 
delete from emp where empno=8000 and ename='장길산';
alter table emp add constraint pk_emp primary key(empno);

-- 외부키(foreign key) 
desc dept;

/*
alter table 테이블명 
add constraint 외부키이름 
foreign key(필드명) 
references 참조테이블명(참조필드명)
on delete cascade  -- 부모 레코드 삭제시 자식도 삭제 
on update cascade -- 부모키값 변경시 자식도 자동으로 변경 
*/
-- 1. 참조하는 테이블(dept)의 deptno가 반드시 primary 거나 unique조건을 만족해야 한다 
-- 2. 데이터 타입이 동일 해야 한다  
alter table emp add constraint fk_emp_dept 
foreign key(deptno) 
references dept(deptno);
-- 테이블 상호간에 제약조건이 발생한다
select * from dept; 
delete from dept where deptno=10;  -- 외부키 때문에 삭제 불가능하다 
select * from emp;
-- 홍길동 한테 부서번호가 없다. 
update emp set deptno=50 where empno=8000;

-- join 은 inner, outer, full - ansi 표준 
-- emp  테이블에는 부서번호 
-- dept 테이블에는 부서번호와 부서명 
-- 두개 이상의 테이블을 하나로 묶어서 새로운 정보를 창출한다 
-- 표준아님, 다른 DBMS에서는 에러가 날 수 있다.(oracle, mysql)
select A.empno, A.ename, A.deptno, B.dname
from emp A, dept B  
where A.deptno=B.deptno;  -- join조건이 동등조건(equl 조건)

-- 표준조인 
select A.empno, A.ename, A.deptno, B.dname
from emp A 
inner join dept B  on A.deptno = B.deptno;  
 
 -- 회원번호가 7369, 7892, 8000, 7900, 7902 
select A.empno, A.ename, A.deptno, B.dname
from emp A, dept B  
where A.deptno=B.deptno and 
A.empno in (7369, 7892, 8000, 7900, 7902 )
-- 단점 : 조인 조건과 검색조건이 구분이 안간다. 그래서 조인이 여러번 
-- 이뤄질경우에 보기 안좋다

select A.empno, A.ename, A.deptno, B.dname
from emp A 
inner join dept B  on A.deptno = B.deptno
where A.empno in (7369, 7892, 8000, 7900, 7902 );

-- inner join 은 양쪽 테이블에 값이 존재할때 된다. 
select A.empno, A.ename, A.deptno, B.dname
from emp A 
inner join dept B  on A.deptno = B.deptno;
--  outer join : left, right 
-- from 절에 가까운 테이블 left (left테이블의 데이터 다출력)
-- from 절로부터 먼 테이블이 right (right테이블의 데이터 다 출력)
select A.empno, A.ename, A.deptno, B.dname
from emp A 
left outer join dept B  on A.deptno = B.deptno;

-- 중복성 배제
select distinct deptno from emp;

select A.empno, A.ename, A.deptno, B.dname
from emp A
right outer join dept B  on A.deptno = B.deptno;










