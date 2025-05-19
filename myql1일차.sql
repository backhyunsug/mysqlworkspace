-- emp테이블의 내용을 다 보여줌 - 14건 
select * from emp;

-- 데이터 전체 몇건인가 ?
select count(*) from emp;

-- * :아스테리스크 모든 필드
select empno, ename, job from emp;

-- ailasing - 별명 테이블명을 수정해서 부를 수 있다
select empno, ename, job 
from emp as e;

-- information_schema 디비에 사용자가 만드는 테이블 
-- 정보가 저장된다. ailasing  안쓰면 저 디비 다 검색해서 '
-- 정보를 읽어오고 ailasing을 하면 캐시를 해서 
-- 디비정보를 메모리에 불러놓고 작업 속도가 유리하다
select e.empno, e.ename, e.job 
from emp as e;

-- as 생략가능  count(필드명) dbms는 null값 이
-- 있으을경우 카운트 안함 
-- count(*) - 필드중에 null값이 아예 없는 필드를 기준으로 
--            제일 많은 데이터 카운트를 가져와라  
select count(e.comm) from emp e;
/*
  null 값? 알수없는, 파이썬의 None , 수학적으로 무한대의 의미를 갖는다 
  null + 1 => null (무한대) 
  null - 1 => null (무한대)

  수학연산 다 가능 (+, -0 , *, /, sin, cosin, tan , round .......)
  null값에 연산을 하면 결과는 null 
  파이썬의 if 문, 함수를 써서 처리가능 
  DBMS 의 쿼리는 ANSI 표준이 있어서 비슷한데 함수는 각자 다르다 
  NVL-오라클, ISNULL, IFNULL
  
  IFNULL(필드명, 기본값) 만일 필드명에서 값이 NULL이 아닌값이 오면 그 값을 주고 
  NULL이면 기본값을 부여한다. 
*/

-- 연산을 통해서 새로운 컬럼을 만들었음 , 수식이 필드명으로 나옴 
-- 필드명도 ailasing 을 통해서 다시 부여할 수 있다.
SELECT EMPNO, SAL, COMM, SAL+IFNULL(COMM, 0) as total_sal 
FROM EMP; 
 
-- 홍길동의 급여는 얼마입니다. 
select concat(ename, "님의 급여는", sal, "입니다" ) as title
from emp;
 
-- 조건절 
/*
select 필드들
from 테이블명 
where 조건절   해당조건에 만족하는 데이터 
			 =  !=  >  <  >=  <=
             논리연산자 and, or not 
*/
select * from emp;
-- 이름이 smith인 사람만 보려고 한다. 
select * from emp where ename='SMITH';
select * from emp where ename='smith';
select * from emp where ename='Smith';

-- 이름이 smith 이거나 ford 인 사람 
select * from emp where ename='SMITH' or ename='FORD';

-- 급여가 3000 이상인 사원의 이름과 급여를 조회하시오.
select ename, sal from emp where sal>=3000;

-- 직무가 'MANAGER' 인 사람의 정보를 조회하시오.
select * from emp where job='MANAGER';

-- 급여가 2000 이상 5000 이하인 사원을 조회하시오.
select * from emp where sal>= and sal<=5000;

-- between - oracle, mysql 지원 
select * from emp where sal between 2000 and 5000;

-- 커미션이 NULL이 아닌 사원을 조회하시오.
-- null은 관계연산자가 아니라 is, is not 
select * from emp where comm = null; -- 결과안나옴 
select * from emp where comm is null;
select * from emp where comm is not null;

-- 'A'로 시작하는 이름을 가진 사원을 조회하시오.
-- 로 시작하는 와일드카드와 like 연산자 _(한글자) %(여러글자) 
select * from emp where ename like 'A%'; 

select * from emp where ename like '%A'; -- A로 끝나는 
-- 이름중간에 O 가 들어가는 이름 
select * from emp where ename like '%O%'; -- O가 들어가는
-- 두번째 글자에 O가 들어가는 경우 
select * from emp where ename like '_O%'; -- 두번째 O가 들어가는

-- 부서번호가 10, 20, 30에 해당하는 사원을 조회하시오.
select * from emp where deptno=10 or deptno=20 or deptno=30; 
-- 나열해서 찾아야 할 경우 -> in 연산자
select * from emp where deptno in(10,20) or depno in(30); 

SELECT empno FROM emp;
-- 7521, 7565, 7903, 7934 
SELECT empno 
FROM emp 
where empno in (7521, 7565, 7903, 7934);

-- () oracle의 경우 500 개가능
-- 급여가 1000 미만이거나 커미션이 500 초과인 사원을 조회하시오.
select * from emp where sal<1000 or comm > 500;
-- 관리자가 없는 사원 (mgr이 NULL)을 조회하시오.
select * from emp where mgr is null; 
-- 직무가 'CLERK'이면서 부서번호가 20인 사원을 조회하시오.
select * from emp where job='clerk' and deptno=20;
-- 입사일이 1981년 이전인 사원을 조회하시오.
select * from emp where hiredate<'1981-01-01';

select * 
from emp
-- where ;
order by ename; --  이름으로 오름차순 
-- order by 필드명 asc 또는 desc 


select * 
from emp
order by ename desc;  -- 내림차순 정렬 





 