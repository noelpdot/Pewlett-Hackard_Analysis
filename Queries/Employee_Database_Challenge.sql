SELECT * FROM titles;

SELECT e.emp_no,
		e.first_name,
		e.last_name,
		ti.title,
		ti.from_date,
		ti.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

--DROP TABLE retirement_titles;


--selecting from retirement titles,
SELECT DISTINCT ON (emp_no) emp_no,
					first_name,
					last_name, 
					title
					--from_date,
					--to_date
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;


SELECT * FROM unique_titles;
-- Employees by their most recent job title.
SELECT COUNT (emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;
		

SELECT * FROM employees, dept_employees,titles
LIMIT (50);

DROP TABLE trial_db;
-- mentorship eligibilty table 1965 JAN-DEC 
SELECT 	e.emp_no,
		e.first_name,
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		ti.title
INTO trial_db
	FROM employees e
	INNER JOIN dept_employees AS de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles ti
		ON (e.emp_no = ti.emp_no)
	WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') AND (de.to_date = '9999-01-01');
	
--DISTINCT ON emp_no
SELECT DISTINCT ON (emp_no)emp_no, first_name, last_name, birth_date, from_date, to_date, title
INTO mentorship_eligibility
	FROM trial_db
	ORDER BY emp_no ASC; 

SELECT COUNT(emp_no) FROM mentorship_eligibility;
-- 1549 members eligible for mentorship

--mentorship eligibility by department
SELECT COUNT(me.emp_no),
		d.dept_name
FROM mentorship_eligibility me
 INNER JOIN dept_employees de
 	ON (me.emp_no = de.emp_no)
	INNER JOIN departments d
	ON (de.dept_no = d.dept_no)
	GROUP BY d.dept_name
	ORDER BY COUNT(me.emp_no) ASC;

-- grouping by title for mentorship eligibility
SELECT COUNT(me.emp_no) AS mentorship_elibility_count, me.title
	INTO mentorship_by_dept
	FROM mentorship_eligibility AS me
	GROUP BY me.title
	ORDER BY COUNT(me.emp_no) DESC;

-- grouping by title for retirement employees
SELECT COUNT(ut.emp_no), ut.title
	INTO retiring_titles_count
	FROM unique_titles AS ut
	GROUP BY ut.title
	ORDER BY COUNT(ut.emp_no) DESC;

-- portraying both tables for comparison
SELECT m.mentorship_elibility_count, m.title, rc.count AS retiring_employee_count
	INTO cross_training
	FROM mentorship_by_dept AS m
	LEFT JOIN retiring_titles_count AS rc 
	ON (m.title = rc.title)
	ORDER BY rc.count DESC;
