use mydb;
select * from emp;

create table test1( 
	id int primary key,
    field varchar(10) 
);

create table test2 as select * from test1;
 
select ifnull(max(id), 0)+1  from test1;

select * from test1;
select * from test2;

select '전체' grade , count(*) 
from tb_score 
union all 
select grade, count(*) 
from(
	select id, case  when (kor+eng+mat)/3>=90 then '수'
						 when (kor+eng+mat)/3>=80 then '우' 
						 when (kor+eng+mat)/3>=70 then '미'
						 when (kor+eng+mat)/3>=60 then '양'
						 else '가' 
			end as grade 
	from tb_score
) A
group by grade
order by field(grade, '전체', '수', '우', '미', '양', '가');
    
    
    
    
select 'all' grade , count(*) 
from tb_score
union all 
select A.grade, count(*) from
(
	select id, case  when (kor+eng+mat)/3>=90 then '수'
					 when (kor+eng+mat)/3>=80 then '우' 
					 when (kor+eng+mat)/3>=70 then '미'
					 when (kor+eng+mat)/3>=60 then '양'
					 else '가' 
					end as grade 
	from tb_score
) A
group by A.grade
order by field(grade, 'all', '수', '우', '미', '양', '가');

 
                 



