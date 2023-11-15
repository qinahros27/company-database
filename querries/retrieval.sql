/*Retrieve the team names and their corresponding project count.*/
SELECT team_name , COUNT(project_id) AS total_projects
FROM public.teams
JOIN public.team_project
ON teams.id = team_project.team_id
GROUP BY team_name , teams.id
ORDER BY teams.id ASC;

/*Retrieve the projects managed by the managers whose first name starts with "J" or "D".*/
SELECT DISTINCT manager.id, manager.first_name, manager.last_name, projects.name AS projects_name
FROM public.employees employee
JOIN public.employees manager
ON manager.id = employee.manager_id
JOIN public.team_project
ON employee.team = team_project.team_id
JOIN public.projects
ON team_project.team_id = projects.id
WHERE manager.first_name LIKE 'J%' OR manager.first_name LIKE 'D%'
ORDER BY manager.id ASC;

/*Retrieve all the employees (both directly and indirectly) working under Andrew Martin*/
WITH RECURSIVE employee_under_AndrewMartin AS (
  SELECT id, first_name, last_name, manager_id
  FROM employees
  WHERE first_name = 'Andrew' AND last_name = 'Martin'
	
  UNION ALL
  
  SELECT em.id, em.first_name, em.last_name, em.manager_id
  FROM employees em
  JOIN employee_under_AndrewMartin eu ON em.manager_id = eu.id
)

SELECT * FROM employee_under_AndrewMartin
WHERE first_name != 'Andrew' AND last_name != 'Martin';

/*Retrieve all the employees (both directly and indirectly) working under Robert Brown*/
WITH RECURSIVE employee_under_RobertBrown AS (
  SELECT id, first_name, last_name, manager_id
  FROM employees
  WHERE first_name = 'Robert' AND last_name = 'Brown'
	
  UNION ALL
  
  SELECT em.id, em.first_name, em.last_name, em.manager_id
  FROM employees em
  JOIN employee_under_RobertBrown eu ON em.manager_id = eu.id
)

SELECT * FROM employee_under_RobertBrown
WHERE first_name != 'Robert' AND last_name != 'Brown';

/*Retrieve the average hourly salary for each title.*/
SELECT titles.name as title, ROUND(AVG(hourly_salary),2) AS avarage_hourly_salary
FROM employees
JOIN titles
ON employees.title_id = titles.id
GROUP BY titles.name;

/*Retrieve the employees who have a higher hourly salary than their respective team's average hourly salary.*/
SELECT titles.name AS title_name, first_name , last_name, hourly_salary , average_salary.avarage_hourly_salary 
FROM public.employees
JOIN public.titles
ON employees.title_id = titles.id
JOIN 
(
	SELECT titles.id AS titles_id, ROUND(AVG(hourly_salary),2) AS avarage_hourly_salary
	FROM employees
	JOIN titles
	ON employees.title_id = titles.id
	GROUP BY titles.id
) AS average_salary
ON employees.title_id = average_salary.titles_id
WHERE hourly_salary > average_salary.avarage_hourly_salary;

/*Retrieve the projects that have more than 3 teams assigned to them.*/
SELECT projects.name ,project_id , COUNT(team_id) AS number_of_team
FROM team_project
JOIN projects
ON team_project.project_id = projects.id
GROUP BY project_id, projects.name
HAVING COUNT(team_id) > 3
ORDER BY project_id;

/*Retrieve the total hourly salary expense for each team.*/
SELECT team_name, SUM(hourly_salary) AS total_hourly_salary
FROM employees
JOIN teams
ON employees.team = teams.id
GROUP BY team_name
ORDER BY team_name;