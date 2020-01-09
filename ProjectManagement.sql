DROP DATABASE "ProjectManagement";

CREATE DATABASE "ProjectManagement"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

CREATE TABLE account_status(
	id serial PRIMARY KEY,
	name VARCHAR(25) UNIQUE NOT NULL,
	description VARCHAR (100)
);

CREATE TABLE account(
	id serial PRIMARY KEY,
	email VARCHAR (255) UNIQUE NOT NULL,
	password VARCHAR (255) NOT NULL,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (100) NOT NULL,	
	created_on TIMESTAMP NOT NULL,
	status_id integer NOT NULL,
	CONSTRAINT account_status_id_fkey FOREIGN KEY (status_id)
		REFERENCES account_status (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE role(
	id serial PRIMARY KEY,
	name VARCHAR (25) UNIQUE NOT NULL,
	description VARCHAR (255)
);

CREATE TABLE account_role
(
	account_id integer NOT NULL,
	role_id integer NOT NULL,
	PRIMARY KEY (account_id, role_id),
	CONSTRAINT account_role_account_id_fkey FOREIGN KEY (account_id)
		REFERENCES account (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT account_role_role_id_fkey FOREIGN KEY (role_id)
		REFERENCES role (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE permission
(
	id serial PRIMARY KEY,
	name VARCHAR(25) UNIQUE NOT NULL,
	description VARCHAR (100)
);

CREATE TABLE role_permission
(
	role_id integer NOT NULL,
	permission_id integer NOT NULL,
	PRIMARY KEY (role_id, permission_id),
	CONSTRAINT role_permission_role_id_fkey FOREIGN KEY (role_id)
		REFERENCES role (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT role_permission_permission_id_fkey FOREIGN KEY (permission_id)
		REFERENCES permission (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE action_status(
	id serial PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE project
(
	id serial PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL,
	description VARCHAR(255),
	created_on TIMESTAMP NOT NULL,
	planned_start_date TIMESTAMP,
	planned_end_date TIMESTAMP,
	actual_start_date TIMESTAMP,
	actual_end_date TIMESTAMP,
	status_id integer NOT NULL,
	CONSTRAINT project_action_status_status_id_fkey FOREIGN KEY (status_id)
		REFERENCES action_status (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE task
(
	id serial PRIMARY KEY,
	name VARCHAR(100) UNIQUE NOT NULL,
	description VARCHAR(255),
	created_on TIMESTAMP NOT NULL,
	created_by integer NOT NULL,
	planned_start_date TIMESTAMP,
	planned_end_date TIMESTAMP,
	actual_start_date TIMESTAMP,
	actual_end_date TIMESTAMP,
	project_id integer NOT NULL,
	parent_task_id integer,
	CONSTRAINT task_account_created_by_fkey FOREIGN KEY (created_by)
		REFERENCES account (id) MATCH SIMPLE,
	CONSTRAINT task_project_project_id_key FOREIGN KEY (project_id)
		REFERENCES project (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT task_task_parent_task_id_fkey FOREIGN KEY (parent_task_id)
		REFERENCES task (id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

	CREATE TABLE task_assignment
	(
		task_id integer NOT NULL,
		account_id integer NOT NULL,
		status_id integer NOT NULL DEFAULT 1,
		PRIMARY KEY (task_id, account_id),
		CONSTRAINT task_assignment_task_task_id_fkey FOREIGN KEY (task_id)
			REFERENCES task (id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT task_assignment_account_account_id_key FOREIGN KEY (account_id)
			REFERENCES account (id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION,
		CONSTRAINT task_assignment_action_status_status_id_fkey FOREIGN KEY (status_id)
			REFERENCES action_status (id) MATCH SIMPLE
			ON UPDATE NO ACTION ON DELETE NO ACTION
	);

INSERT INTO public.role(
	name, is_admin, description)
	VALUES ('admin', true, 'admin role');

INSERT INTO public.account_status(
	name, description)
	VALUES ('change password', 'force user to change password after login');

INSERT INTO public.account_status(
	name, description)
	VALUES ('active user', 'user changed password after first login and is active');

INSERT INTO public.account(
	email, password, first_name, last_name, created_on, status_id)
	VALUES ('mail@email.com', '$2a$11$UowIDAIXFIr8DT.umO/8W.RyIr.SA.pcPJZs/uSdi8y.5BZlsK78.', 'Name', 'Surname', NOW(), 1);

INSERT INTO public.account_role(
	account_id, role_id)
	VALUES (1, 1);

INSERT INTO public.permission(
	name, description)
	VALUES ('manage_users', 'can manage users');

INSERT INTO public.permission(
	name, description)
	VALUES ('manage_projects', 'can manage projects');

INSERT INTO public.permission(
	name, description)
	VALUES ('manage_tasks', 'can manage tasks');

INSERT INTO public.role_permission(
	role_id, permission_id)
	VALUES (1, 1);

INSERT INTO public.role_permission(
	role_id, permission_id)
	VALUES (1, 2);

INSERT INTO public.role_permission(
	role_id, permission_id)
	VALUES (1, 3);

INSERT INTO public.role_permission(
	role_id, permission_id)
	VALUES (2, 3);

INSERT INTO public.action_status(
	name)
	VALUES ('not started');

INSERT INTO public.action_status(
	name)
	VALUES ('in progress');

INSERT INTO public.action_status(
	name)
	VALUES ('completed');
