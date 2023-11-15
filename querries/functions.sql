/*Create a function `track_working_hours(employee_id, project_id, total_hours)` to insert data into the hour_tracking table to track the working hours for each employee on specific projects. */
CREATE OR REPLACE FUNCTION track_working_hours(employee_id INTEGER, project_id INTEGER, total_hours NUMERIC) 
RETURNS VOID AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM employees WHERE id = employee_id) THEN
    RAISE EXCEPTION 'Invalid employee_id: %', employee_id;
  END IF;

  IF NOT EXISTS (SELECT 1 FROM projects WHERE id = project_id) THEN
    RAISE EXCEPTION 'Invalid project_id: %', project_id;
  END IF;
  
  IF total_hours <= 0 THEN
    RAISE EXCEPTION 'Invalid total_hours: %', total_hours;
  END IF;

  INSERT INTO hour_tracking (employee_id, project_id, total_hours)
  VALUES (employee_id, project_id, total_hours);
END;
$$ LANGUAGE plpgsql;

/*Create a function `create_project_with_teams` to create a project and assign teams to that project simultaneously.*/
CREATE OR REPLACE FUNCTION create_project_with_teams(name CHARACTER VARYING,client CHARACTER VARYING,start_date DATE,deadline DATE, project_teams INTEGER[]) 
RETURNS VOID AS $$
DECLARE
  project_id INTEGER;
  team_id INTEGER;
BEGIN
  INSERT INTO public.projects(name, client, start_date, deadline)
  VALUES (name, client, start_date, deadline)
  RETURNING id INTO project_id;
	
  FOREACH team_id IN ARRAY project_teams LOOP
  	IF NOT EXISTS (SELECT 1 FROM public.teams WHERE id = team_id) THEN
    	RAISE EXCEPTION 'Invalid team_id: %', team_id;
  	END IF;
	
	INSERT INTO public.team_project(team_id,project_id)
	VALUES (team_id, project_id);
  END LOOP;
END;
$$ LANGUAGE plpgsql;