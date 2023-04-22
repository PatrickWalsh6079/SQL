IF NOT EXISTS(SELECT * FROM sys.databases WHERE NAME='moze2')
    CREATE DATABASE moze2
GO

USE moze2
GO

-- DOWN
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_customers_customer_state')
    ALTER TABLE customers DROP CONSTRAINT fk_customers_customer_state;
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_contractors_contractor_state')
    ALTER TABLE contractors DROP CONSTRAINT fk_contractors_contractor_state;
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_jobs_job_submitted_by')
    ALTER TABLE jobs DROP CONSTRAINT fk_jobs_job_submitted_by;
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_jobs_job_contracted_by')
    ALTER TABLE jobs DROP CONSTRAINT fk_jobs_job_contracted_by;
DROP TABLE IF EXISTS contractors;
DROP TABLE IF EXISTS state_lookup;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS jobs;
GO

-- UP Metadata
CREATE TABLE state_lookup(
    state_code CHAR(2) NOT NULL,
    CONSTRAINT pk_state_lookup_state_code PRIMARY KEY(state_code)
);
GO

CREATE TABLE customers(
    customer_id INT IDENTITY NOT NULL,
    customer_email VARCHAR(50) NOT NULL,
    customer_min_price MONEY NOT NULL,
    customer_max_price MONEY NOT NULL,
    customer_city VARCHAR(50) NOT NULL,
    customer_state CHAR(2) NOT NULL,
    CONSTRAINT pk_customers_customer_id PRIMARY KEY(customer_id),
    CONSTRAINT u_customer_email UNIQUE(customer_email),
    CONSTRAINT ck_min_max_price CHECK(customer_min_price<=customer_max_price)
)
ALTER TABLE customers
    ADD CONSTRAINT fk_customers_customer_state FOREIGN KEY(customer_state)
    REFERENCES state_lookup(state_code)

CREATE TABLE contractors(
    contractor_id INT NOT NULL,
    contractor_email VARCHAR(50) NOT NULL,
    contractor_rate MONEY NOT NULL,
    contractor_city VARCHAR(50) NOT NULL,
    contractor_state CHAR(2) NOT NULL,
    CONSTRAINT pk_contractors_contractor_id PRIMARY KEY(contractor_id),
    CONSTRAINT u_contractors_contractor_email UNIQUE(contractor_email)
);
ALTER TABLE contractors
    ADD CONSTRAINT fk_contractors_contractor_state FOREIGN KEY(contractor_state)
    REFERENCES state_lookup(state_code)

CREATE TABLE jobs(
    job_id INT NOT NULL,
    job_submitted_by INT NOT NULL,
    job_requested_date DATE NOT NULL,
    job_contracted_by INT NOT NULL,
    job_service_rate MONEY NULL,
    job_estimated_date DATE NULL,
    job_completed_date DATE NULL,
    job_customer_rating INT NULL,
    CONSTRAINT pk_jobs_job_id PRIMARY KEY(job_id),
    CONSTRAINT ck_valid_job_dates CHECK(
        job_requested_date<=job_estimated_date
        AND
        job_estimated_date<=job_completed_date)
);
ALTER TABLE jobs
    ADD CONSTRAINT fk_jobs_job_submitted_by FOREIGN KEY(job_submitted_by)
    REFERENCES customers(customer_id)
ALTER TABLE jobs
    ADD CONSTRAINT fk_jobs_job_contracted_by FOREIGN KEY(job_contracted_by)
    REFERENCES contractors(contractor_id)
GO

-- UP Data
INSERT INTO state_lookup (state_code)
VALUES('NY'),('NJ'),('CT')

INSERT INTO customers (
    customer_email,
    customer_min_price,
    customer_max_price,
    customer_city,
    customer_state)
    VALUES
    ('lkarforless@superrito.com',50,100,'Syracuse','NY'),
    ('bdehatchett@dayrep.com',25,50,'Syracuse','NY'),
    ('pmeaup@gustr.com',100,150,'Syracuse','NY'),
    ('tanott@gustr.com',25,75,'Rochester','NY'),
    ('sboate@gustr.com',50,100,'New Haven','CT')

INSERT INTO contractors(
    contractor_id,
    contractor_email,
    contractor_rate,
    contractor_city,
    contractor_state
    )
    VALUES
    (1,'otyme@dayrep.com',50,'Syracuse','NY'),
    (2,'meyezing@dayrep.com',75,'Syracuse','NY'),
    (3,'bitall@dayrep.com',35,'Rochester','NY'),
    (4,'sbeeches@dayrep.com',85,'Hartford','CT')

INSERT INTO jobs(
    job_id,
    job_submitted_by,
    job_requested_date,
    job_contracted_by,
    job_service_rate,
    job_estimated_date,
    job_completed_date
    )
    VALUES
    (1,2,'2020-05-01',2,NULL,NULL,NULL),
    (2,3,'2020-05-01',1,50,'2020-05-02',NULL),
    (3,1,'2020-05-01',4,85,'2020-05-03','2020-05-03')
GO

-- Verify
SELECT * FROM state_lookup;
SELECT * FROM customers;
SELECT * FROM contractors;
SELECT * FROM jobs;