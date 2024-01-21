create database projects;
use projects;
select * from hr;

describe hr;

SELECT * FROM projects.hr;

alter table hr
change column ï»¿id employee_id varchar(20) null;

select birthdate from hr;
select hire_date from hr;


set sql_safe_updates = 0;

update hr
set birthdate = case
	when birthdate like "%/%" then date_format(str_to_date(birthdate,'%m/%d/%Y'), '%Y-%m-%d')
	when birthdate like "%-%" then date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
	else null
end;   

alter table hr
modify column birthdate date;      

update hr
set hire_date = case
	when hire_date like "%/%" then date_format(str_to_date(hire_date,'%m/%d/%Y'), '%Y-%m-%d')
	when hire_date like "%-%" then date_format(str_to_date(hire_date,'%m-%d-%Y'), '%Y-%m-%d')
	else null
end;   

alter table hr
modify column hire_date date;

select termdate from hr;  

update hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SET sql_mode = 'ALLOW_INVALID_DATES';

alter table hr
modify column termdate date;

alter table hr
add column age int;

update hr
set age = timestampdiff(year,birthdate,curdate());

select birthdate, age
from hr;

select min(age) as youngest, max(age) as oldest
from hr
where age>0;

select count(*)
from hr
where age <18;

select gender, count(*) from hr
where age > 18 and termdate = "0000-00-00"
group by gender;

select race, count(*) as count_of_race from hr
where age > 18 and termdate = "0000-00-00"
group by race
 ;

select 
case 
     when age between 18 and 24 then "18-24"
     when age between 25 and 34 then "25-34"
     when age between 35 and 44 then "25-44"
     when age between 45 and 54 then "45-54"
     when age between 55 and 64 then "55-64"
     else "65+"
     end as age_group, count(*) as count
from hr   
where age > 18 and termdate = "0000-00-00"
group by age_group
order by age_group asc;

select 
case 
     when age between 18 and 24 then "18-24"
     when age between 25 and 34 then "25-34"
     when age between 35 and 44 then "25-44"
     when age between 45 and 54 then "45-54"
     when age between 55 and 64 then "55-64"
     else "65+"
     end as age_group,gender, count(*) as count
from hr   
where age > 18 and termdate = "0000-00-00"
group by age_group, gender
order by age_group, gender;

select location , count(*)
from hr
where age > 18 and termdate = "0000-00-00"
group by location;

SELECT round(AVG((datediff(termdate,hire_date))/365),0) as avg_length_employment
from hr
where termdate<= curdate() and termdate <> "0000-00-00" and age>18;

select department,gender,count(*)
from hr
where age > 18 and termdate = "0000-00-00"
group by department,gender
order by department, gender;

select jobtitle,gender,count(*)
from hr
where age > 18 and termdate = "0000-00-00"
group by jobtitle,gender
order by jobtitle, gender;

select jobtitle,count(*)
from hr
where age > 18 and termdate = "0000-00-00"
group by jobtitle
order by jobtitle;

select department, round((total_count/termination_count)*0.01,3) as termination_rate 
from (
select department,count(*) as total_count, sum(case when termdate <> "0000-00-00" and termdate <= curdate() then 1
												    else 0 end) as termination_count
from hr
where age >18
group by department) as sq
order by termination_rate desc;             

select location_city ,location_state,count(*)
from hr
where age > 18 and termdate = "0000-00-00"
group by location_city , location_state 
order by count(*) ;      

select location_state , count(*)
from hr
where age > 18 and termdate = "0000-00-00"
group by location_state  
order by count(*);

select year, hires, terminations, hires-terminations as net_change, round((hires-terminations)/hires*100,2) as net_change_percent
from 
(select year(hire_date) as year, count(*) as hires, sum(case when termdate <> "0000-00-00" and termdate <= curdate() then 1
												    else 0 end) as terminations
from hr
where age>= 18
group by year) as sq
order by year;

select department, round(AVG((datediff(termdate,hire_date))/365),0) as avg_tenure
from hr
where age >=18
group by department
order by department;




     