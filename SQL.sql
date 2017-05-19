/*1.  Show all data of the clerks who have been hired after the year 1997 */
SELECT * FROM employees WHERE hire_date >= TO_DATE(1997,'yyyy');
/*2.  Show the last name,  job, salary, and commission of those employees who earn commission. Sort the data by the salary in descending order. */
SELECT last_name,job_id,salary,commission_pct 
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC
/*3.  Show the employees that have no commission with a 10% raise in their salary (round off thesalaries). */
SELECT 'The salary of '||last_name||' after a 10% raies is '||salary*1.1 AS "New salary"
FROM employees
WHERE commission_pct IS NULL;
/*4.  Show the last names of all employees together with the number of years and the number ofcompleted months that they have been employed.
把所有员工的姓和年数以及他们已经完成的几个月的数量一起显示出来。 */
/*SELECT last_name,2001-TO_CHAR(hire_date,'yyyy') AS "YEARS",9-TO_CHAR(hire_date,'MM') AS MONTHS FROM employees;*/
SELECT last_name,TRUNC(months_between(SYSDATE,hire_date)/12) AS "YEARS",
(TRUNC(months_between(SYSDATE,hire_date))- TRUNC(months_between(SYSDATE,hire_date)/12)*12) AS "MONTHS" 
from employees;
/*5.  Show those employees that have a name starting with J, K, L, or M.*/
SELECT last_name FROM employees 
WHERE last_name LIKE 'J%' OR last_name LIKE 'K%' OR last_name LIKE 'L%' OR last_name LIKE 'M%';
/*6.  Show all employees, and indicate with “Yes” or “No” whether they receive a commission.*/
SELECT last_name,salary,NVL2(commission_pct,'Yes','No') AS "COM" FROM employees;
/*7.   Show the department names, locations, names, job titles, and salaries of employees who workin location 1800.*/
SELECT department_name,location_id,last_name,job_id,salary 
FROM employees,departments
WHERE employees.department_id=departments.department_id AND location_id = 1800;
/*8.   How many employees have a name that ends with an n? Create two possible solutions.*/
SELECT COUNT(*) 
FROM employees 
WHERE last_name LIKE '%n';
SELECT COUNT(*)
FROM employees
WHERE SUBSTR(last_name,LENGTH(last_name)) = 'n';
/*9.   Show the names and locations for all departments, and the number of employees working in each department. Make sure that departments without employees are included as well.
*/
SELECT d.department_id,d.department_name,d.location_id,COUNT(e.employee_id)
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_id,d.department_name,d.location_id;
/*10.  Which jobs are found in departments 10 and 20?
*/
SELECT job_id 
FROM employees
WHERE department_id between 10 and 20;
/*11.  Which jobs are found in the Administration and Executive departments, and how manyemployees do these jobs? Show the job with the highest frequency first.
*/
SELECT job_id,COUNT(employee_id)
FROM employees
WHERE job_id LIKE 'AD%'
GROUP BY job_id
ORDER BY COUNT(employee_id) DESC;
/*12.Show all employees who were hired in the first half of the month (before the 16th of the month).
*/
SELECT last_name,hire_date
FROM employees
WHERE TO_CHAR(hire_date,'dd')<16;
/*13.Show the names, salaries, and the number of dollars (in thousands) that all employees earn.
*/
SELECT last_name,salary,TRUNC(salary/1000)
FROM employees;
/*14.  Show all employees who have managers with a salary higher than $15,000. Show thefollowing data: employee name, manager name, manager salary, and salary grade of the manager.
*/
SELECT x.last_name,y.last_name as MANAGER,y.salary,g.grade_level
FROM employees x,employees y,job_grades g
WHERE y.employee_id = x.manager_id and y.salary > 15000 and y.salary BETWEEN g.lowest_sal AND g.highest_sal;
/*15.  Show the department number, name, number of employees, and average salary of all departments, together with the names, salaries, and jobs of the employees working in each department.
有问题*/
SELECT e.department_id,d.department_name,COUNT(e.department_id),AVG(e.salary),e.last_name,e.salary,e.job_id
from employees e right join departments d
on (e.department_id = d.department_id)
GROUP BY e.department_id,d.department_name,e.last_name,e.salary,e.job_id;
/*16.  Show the department number and the lowest salary of the department with the highest average   salary.
*/
SELECT department_id,MIN(salary)
FROM employees
GROUP BY department_id
HAVING department_id = (SELECT department_id
      FROM employees
      GROUP BY department_id
      HAVING AVG(salary)>= (SELECT MAX(AVG(salary))
      FROM employees
      GROUP BY department_id));
/*17.  Show the department numbers, names, and locations of the departments where no sales representatives work.
*/
SELECT department_id,department_name,manager_id,location_id
FROM departments
WHERE department_name != 'sales';
/*18.  Show the department number, department name, and the number of employees working in each department that:
*/
SELECT e.department_id,d.department_name,count(*)
FROM departments d,employees e
WHERE d.department_id = e.department_id
group by e.department_id,d.department_name
having count(employee_id) < 3;

SELECT e.department_id,d.department_name,count(*)
FROM departments d,employees e
WHERE d.department_id = e.department_id
group by e.department_id,d.department_name
having count(employee_id) = (SELECT MAX(COUNT(*))
       FROM employees
       group by department_id);
       
SELECT e.department_id,d.department_name,count(*)
FROM departments d,employees e
WHERE d.department_id = e.department_id
group by e.department_id,d.department_name
having count(employee_id) = (SELECT MIN(COUNT(*))
       FROM employees
       group by department_id);
/*19.  Show the employee number, last name, salary, department number, and the average salary in their department for all employees.
*/
SELECT x.employee_id,x.last_name,y.department_id,avg(y.salary)
FROM employees x,employees y
WHERE x.department_id = y.department_id
group by x.employee_id,x.last_name,y.department_id
order by employee_id asc;
/*20.  Show all employees who were hired on the day of the week on which the highest number of employees were hired.
*/
SELECT last_name,TO_CHAR(hire_date,'day')
FROM employees
where TO_CHAR(hire_date,'day') = (SELECT TO_CHAR(hire_date,'day')
      from employees
      group by TO_CHAR(hire_date,'day')
      having count(TO_CHAR(hire_date,'day')) = (select MAX(count(TO_CHAR(hire_date,'day'))) 
      from employees
      group by TO_CHAR(hire_date,'day')
      ))
/*21.  Create an anniversary overview based on the hire date of the employees. Sort the anniversaries in ascending order.
*/
SELECT last_name,TO_CHAR(hire_date,'MM-dd') as "BIRTHDAY"
FROM employees
order by TO_CHAR(hire_date,'MM-dd') asc;
/*22. Find the job that was filled in the first half of 1990 and the same job that was filled during the     same period in 1991.
*/
SELECT x.job_id
FROM employees x,employees y
where TO_CHAR(x.hire_date,'yyyy') = '1990' AND
TO_CHAR(x.hire_date,'MM')>=1 AND TO_CHAR(x.hire_date,'MM')<=6 AND
TO_CHAR(y.hire_date,'yyyy') = '1991' AND x.job_id = y.job_id ;
/*23. Write a compound query to produce a list of employees showing raise percentages, employee     IDs, and old salary and new salary increase. Employees in departments 10, 50, and 110 are     given a 5% raise, employees in department 60 are given a 10% raise, employees in     departments 20 and 80 are given a  15% raise, and employees in department 90 are not given     a raise.  
*/
SELECT '05% raise' raise, employee_id, salary, 
salary *.05 new_salary
FROM   employees
WHERE  department_id IN (10,50, 110)
UNION
SELECT '10% raise', employee_id, salary, salary * .10
FROM   employees
WHERE  department_id = 60
UNION
SELECT '15% raise', employee_id, salary, salary * .15 
FROM   employees
WHERE  department_id IN (20, 80)
UNION
SELECT 'no raise', employee_id, salary, salary
FROM   employees
WHERE  department_id = 90;

/*24.Alter the session to set the NLS_DATE_FORMAT to  DD-MON-YYYY HH24:MI:SS.
*/
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

/*25.*/
SELECT TZ_OFFSET ('Australia/Sydney') from dual;
SELECT TZ_OFFSET ('Chile/EasterIsland') from dual;
ALTER SESSION SET TIME_ZONE = '+10:00';
SELECT SYSDATE,CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM DUAL;
ALTER SESSION SET TIME_ZONE = '-06:00';
SELECT SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
FROM DUAL;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY';
/*26.   Write a query to display the last names, month of the date of join, and hire date of those                 employees who have joined in the month of January, irrespective of the year of join.
*/
SELECT last_name,TO_CHAR(hire_date,'MM'),TO_CHAR(hire_date,'dd-MM-yyyy')
FROM employees
where TO_CHAR(hire_date,'MM') = '01'
/*27.*/
COLUMN city FORMAT A25 Heading CITY
COLUMN department_name FORMAT A15 Heading DNAME
COLUMN job_id  FORMAT A10 Heading JOB
COLUMN SUM(salary)  FORMAT $99,99,999.00 Heading SUM(SALARY)

SELECT   l.city,d.department_name, e.job_id, SUM(e.salary)
FROM     locations l,employees e,departments d
WHERE    d.location_id = l.location_id
AND      e.department_id = d.department_id
AND      e.department_id > 80
GROUP    BY CUBE( l.city,d.department_name, e.job_id);
/*28*/
SELECT department_id, job_id, manager_id,max(salary),min(salary)
FROM   employees
GROUP BY GROUPING SETS
((department_id,job_id), (job_id,manager_id))


/*29. Write a query to display the top three earners in the EMPLOYEES table. Display their last   names and salaries.
*/
SELECT last_name,salary
FROM (SELECT last_name,salary from employees)
where rownum <= 3
order by rownum asc;
/*30. Write a query to display the employee ID and last names of the employees who work in the   state of California. 
*/
select e.employee_id,e.last_name
from employees e inner join departments d
on e.department_id = d.department_id
inner join locations l on d.location_id = l.location_id and
l.state_province = 'California'
order by employee_id asc;
/*31*/
DELETE FROM job_history JH
WHERE employee_id =
	(SELECT employee_id 
	 FROM employees E
	 WHERE JH.employee_id = E.employee_id
         AND START_DATE = (SELECT MIN(start_date)  
	          FROM job_history JH
	 	  WHERE JH.employee_id = E.employee_id)
	 AND 3 >  (SELECT COUNT(*)  
	          FROM job_history JH
	 	  WHERE JH.employee_id = E.employee_id
		  GROUP BY EMPLOYEE_ID
		  HAVING COUNT(*) >= 2));
/*32*/
ROLLBACK;
/*33*/
WITH 
MAX_SAL_CALC AS (
  SELECT job_title, MAX(salary) AS job_total
  FROM employees, jobs
  WHERE employees.job_id = jobs.job_id
  GROUP BY job_title)
SELECT job_title, job_total
FROM MAX_SAL_CALC
WHERE job_total > (
                    SELECT MAX(job_total) * 1/2
                    FROM MAX_SAL_CALC)
ORDER BY job_total DESC;


/*34*/
SELECT employee_id, last_name, hire_date, salary
FROM   employees
WHERE  manager_id = (SELECT employee_id
           FROM   employees
	           WHERE last_name = 'De Haan');
SELECT employee_id, last_name, hire_date, salary
FROM   employees
WHERE  employee_id != 102
CONNECT BY manager_id = PRIOR employee_id
START WITH employee_id = 102;

/*35*/
SELECT employee_id, manager_id, level, last_name
FROM   employees
WHERE LEVEL = 3
CONNECT BY manager_id = PRIOR employee_id
START WITH employee_id= 102;

/*36*/
COLUMN name FORMAT A25
SELECT  employee_id, manager_id, LEVEL,
LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_')  LAST_NAME        
FROM    employees
CONNECT BY employee_id = PRIOR manager_id;
COLUMN name CLEAR


/*37*/
INSERT ALL
WHEN SAL < 5000 THEN
INTO  special_sal VALUES (EMPID, SAL)
ELSE
INTO sal_history VALUES(EMPID,HIREDATE,SAL)
INTO mgr_history VALUES(EMPID,MGR,SAL)   
SELECT employee_id EMPID, hire_date HIREDATE,
       salary SAL, manager_id MGR
FROM employees
WHERE employee_id >=200;	
/*38*/
SELECT * FROM special_sal;
SELECT * FROM sal_history;
SELECT * FROM mgr_history;


/*39*/
CREATE TABLE LOCATIONS_NAMED_INDEX
 (location_id NUMBER(4)
         PRIMARY KEY USING INDEX
        (CREATE INDEX locations_pk_idx ON
         LOCATIONS_NAMED_INDEX(location_id)),
location_name VARCHAR2(20));
/*40*/
SELECT INDEX_NAME, TABLE_NAME
FROM USER_INDEXES
WHERE TABLE_NAME = 'LOCATIONS_NAMED_INDEX';      


      
      






 





