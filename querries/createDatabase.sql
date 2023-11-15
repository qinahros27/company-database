/*Create title table*/
CREATE TABLE IF NOT EXISTS public.titles
(
    id integer NOT NULL DEFAULT nextval('titles_id_seq'::regclass),
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT titles_pkey PRIMARY KEY (id),
    CONSTRAINT unique_title UNIQUE (name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.titles
    OWNER to postgres;

/*import file titles.csv to title table*/
COPY titles(name)
FROM 'C:\Users\Admin\Downloads\fs15_16_company-database\data\titles.csv'
DELIMITER ','
CSV HEADER;

/*Create teams table*/
CREATE TABLE IF NOT EXISTS public.teams
(
    id integer NOT NULL DEFAULT nextval('teams_id_seq'::regclass),
    team_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    location character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT teams_pkey PRIMARY KEY (id),
    CONSTRAINT unique_team_name UNIQUE (team_name)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.teams
    OWNER to postgres;

/*import file teams.csv to teams table*/
COPY teams(team_name,location)
FROM 'C:\Users\Admin\Downloads\fs15_16_company-database\data\teams.csv'
DELIMITER ','
CSV HEADER;

/*Create projects table*/
CREATE TABLE IF NOT EXISTS public.projects
(
    "id " integer NOT NULL DEFAULT nextval('"projects_id _seq"'::regclass),
    name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    client character varying(30) COLLATE pg_catalog."default" NOT NULL,
    start_date date NOT NULL,
    deadline date NOT NULL,
    CONSTRAINT projects_pkey PRIMARY KEY ("id ")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.projects
    OWNER to postgres;

/*import file projects.csv to projects table*/
COPY projects(name,client,start_date,deadline)
FROM 'C:\Users\Admin\Downloads\fs15_16_company-database\data\projects.csv'
DELIMITER ','
CSV HEADER;

/*Create employees table*/
CREATE TABLE IF NOT EXISTS public.employees
(
    id integer NOT NULL DEFAULT nextval('employees_id_seq'::regclass),
    first_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    last_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    hire_date date NOT NULL,
    hourly_salary numeric NOT NULL,
    title_id integer,
    manager_id integer,
    team integer,
    CONSTRAINT employees_pkey PRIMARY KEY (id),
    CONSTRAINT manager_id_fk FOREIGN KEY (manager_id)
        REFERENCES public.employees (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT team_id_fk FOREIGN KEY (team)
        REFERENCES public.teams (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT title_id_fk FOREIGN KEY (title_id)
        REFERENCES public.titles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.employees
    OWNER to postgres;

/*import file employees.csv to employees table*/
COPY employees(first_name,last_name,hire_date,hourly_salary,title_id,manager_id,team)
FROM 'C:\Users\Admin\Downloads\fs15_16_company-database\data\employees.csv'
DELIMITER ','
NULL STRINGS "NULL"
CSV HEADER;

/*Create team_project table*/
CREATE TABLE IF NOT EXISTS public.team_project
(
    id integer NOT NULL DEFAULT nextval('team_project_id_seq'::regclass),
    team_id integer NOT NULL,
    project_id integer NOT NULL,
    CONSTRAINT team_project_pkey PRIMARY KEY (id),
    CONSTRAINT project_id_fk FOREIGN KEY (project_id)
        REFERENCES public.projects ("id ") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT team_id_fk FOREIGN KEY (team_id)
        REFERENCES public.teams (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.team_project
    OWNER to postgres;

/*import file team_project.csv to team_project table*/
COPY team_project(team_id,project_id)
FROM 'C:\Users\Admin\Downloads\fs15_16_company-database\data\team_project.csv'
DELIMITER ','
CSV HEADER;

/*Create hour_tracking table*/
CREATE TABLE IF NOT EXISTS public.hour_tracking
(
    id integer NOT NULL DEFAULT nextval('hour_tracking_id_seq'::regclass),
    employee_id integer NOT NULL,
    project_id integer NOT NULL,
    total_hours integer NOT NULL,
    CONSTRAINT hour_tracking_pkey PRIMARY KEY (id),
    CONSTRAINT employee_id_fk FOREIGN KEY (employee_id)
        REFERENCES public.employees (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT project_id_fk FOREIGN KEY (project_id)
        REFERENCES public.projects ("id ") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.hour_tracking
    OWNER to postgres;

/*import file hour_tracking.csv to hour_tracking table*/
COPY hour_tracking(employee_id,project_id,total_hours)
FROM 'C:\Users\Admin\Downloads\fs15_16_company-database\data\hour_tracking.csv'
DELIMITER ','
CSV HEADER;