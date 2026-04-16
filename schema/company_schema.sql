-- ==========================================================
-- Company Schema
-- Large Multi-Domain Corporate Analytics Database
-- Supports HR, Finance, Sales, Projects, IT, Ops, Security
-- ==========================================================

-- =========================
-- MASTER / ORG TABLES
-- =========================

CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) UNIQUE NOT NULL,
    iso_code VARCHAR(5) UNIQUE NOT NULL
);

CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    country_id INT REFERENCES countries(country_id)
);

CREATE TABLE offices (
    office_id SERIAL PRIMARY KEY,
    office_name VARCHAR(150),
    region_id INT REFERENCES regions(region_id),
    city VARCHAR(100),
    address TEXT,
    opened_date DATE,
    active_flag BOOLEAN DEFAULT TRUE
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(120) UNIQUE NOT NULL,
    cost_center VARCHAR(30) UNIQUE,
    office_id INT REFERENCES offices(office_id),
    budget NUMERIC(14,2)
);

CREATE TABLE job_levels (
    level_id SERIAL PRIMARY KEY,
    level_code VARCHAR(20),
    level_name VARCHAR(100),
    min_salary NUMERIC(12,2),
    max_salary NUMERIC(12,2)
);

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(120),
    level_id INT REFERENCES job_levels(level_id),
    department_id INT REFERENCES departments(department_id)
);

-- =========================
-- EMPLOYEE DOMAIN
-- =========================

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    employee_code VARCHAR(30) UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    full_name VARCHAR(220),
    email VARCHAR(200) UNIQUE,
    phone VARCHAR(40),
    gender VARCHAR(20),
    dob DATE,
    hire_date DATE,
    status VARCHAR(30), -- active, resigned, leave
    manager_id INT REFERENCES employees(employee_id),
    department_id INT REFERENCES departments(department_id),
    role_id INT REFERENCES roles(role_id),
    office_id INT REFERENCES offices(office_id),
    salary NUMERIC(12,2),
    bonus_pct NUMERIC(5,2),
    last_promotion_date DATE
);

CREATE TABLE employee_addresses (
    address_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    country_id INT REFERENCES countries(country_id)
);

CREATE TABLE emergency_contacts (
    contact_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    contact_name VARCHAR(150),
    relationship VARCHAR(80),
    phone VARCHAR(40)
);

CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    attendance_date DATE,
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    work_mode VARCHAR(30), -- remote/hybrid/office
    status VARCHAR(30) -- present/leave/holiday
);

CREATE TABLE leave_types (
    leave_type_id SERIAL PRIMARY KEY,
    leave_name VARCHAR(80),
    yearly_quota INT
);

CREATE TABLE leave_requests (
    leave_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    leave_type_id INT REFERENCES leave_types(leave_type_id),
    start_date DATE,
    end_date DATE,
    days_count NUMERIC(6,2),
    approval_status VARCHAR(30),
    approved_by INT REFERENCES employees(employee_id)
);

-- =========================
-- PERFORMANCE DOMAIN
-- =========================

CREATE TABLE performance_cycles (
    cycle_id SERIAL PRIMARY KEY,
    cycle_name VARCHAR(100),
    start_date DATE,
    end_date DATE
);

CREATE TABLE performance_reviews (
    review_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    reviewer_id INT REFERENCES employees(employee_id),
    cycle_id INT REFERENCES performance_cycles(cycle_id),
    score NUMERIC(5,2),
    rating VARCHAR(20),
    strengths TEXT,
    improvements TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE goals (
    goal_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    cycle_id INT REFERENCES performance_cycles(cycle_id),
    goal_title VARCHAR(255),
    target_value NUMERIC(12,2),
    achieved_value NUMERIC(12,2),
    status VARCHAR(30)
);

CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    old_role_id INT REFERENCES roles(role_id),
    new_role_id INT REFERENCES roles(role_id),
    effective_date DATE,
    increment_pct NUMERIC(6,2)
);

-- =========================
-- PROJECTS DOMAIN
-- =========================

CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(180),
    industry VARCHAR(120),
    country_id INT REFERENCES countries(country_id),
    annual_contract_value NUMERIC(14,2)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_code VARCHAR(30) UNIQUE,
    project_name VARCHAR(180),
    client_id INT REFERENCES clients(client_id),
    department_id INT REFERENCES departments(department_id),
    manager_id INT REFERENCES employees(employee_id),
    start_date DATE,
    end_date DATE,
    status VARCHAR(40),
    budget NUMERIC(14,2),
    actual_cost NUMERIC(14,2)
);

CREATE TABLE employee_projects (
    employee_project_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    project_id INT REFERENCES projects(project_id),
    allocation_pct NUMERIC(5,2),
    assigned_date DATE,
    release_date DATE,
    billing_rate NUMERIC(10,2)
);

CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    assigned_to INT REFERENCES employees(employee_id),
    task_title VARCHAR(255),
    priority VARCHAR(20),
    status VARCHAR(30),
    estimated_hours NUMERIC(8,2),
    actual_hours NUMERIC(8,2),
    due_date DATE
);

CREATE TABLE timesheets (
    timesheet_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    project_id INT REFERENCES projects(project_id),
    task_id INT REFERENCES tasks(task_id),
    work_date DATE,
    hours_logged NUMERIC(6,2)
);

-- =========================
-- SALES DOMAIN
-- =========================

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku VARCHAR(40) UNIQUE,
    product_name VARCHAR(180),
    category VARCHAR(100),
    unit_price NUMERIC(12,2),
    active_flag BOOLEAN DEFAULT TRUE
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(180),
    email VARCHAR(180),
    phone VARCHAR(40),
    country_id INT REFERENCES countries(country_id),
    customer_segment VARCHAR(80)
);

CREATE TABLE sales_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    sales_rep_id INT REFERENCES employees(employee_id),
    order_date DATE,
    status VARCHAR(30),
    total_amount NUMERIC(14,2)
);

CREATE TABLE sales_order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES sales_orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(12,2),
    line_total NUMERIC(14,2)
);

CREATE TABLE monthly_targets (
    target_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    target_month DATE,
    revenue_target NUMERIC(14,2),
    achieved_revenue NUMERIC(14,2)
);

-- =========================
-- FINANCE DOMAIN
-- =========================

CREATE TABLE vendors (
    vendor_id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(180),
    category VARCHAR(100),
    country_id INT REFERENCES countries(country_id)
);

CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    vendor_id INT REFERENCES vendors(vendor_id),
    invoice_number VARCHAR(50),
    invoice_date DATE,
    due_date DATE,
    amount NUMERIC(14,2),
    status VARCHAR(30)
);

CREATE TABLE expense_claims (
    claim_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    claim_date DATE,
    category VARCHAR(80),
    amount NUMERIC(12,2),
    approval_status VARCHAR(30)
);

CREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    payroll_month DATE,
    base_salary NUMERIC(12,2),
    bonus NUMERIC(12,2),
    deductions NUMERIC(12,2),
    net_pay NUMERIC(12,2)
);

-- =========================
-- IT / SECURITY DOMAIN
-- =========================

CREATE TABLE assets (
    asset_id SERIAL PRIMARY KEY,
    asset_tag VARCHAR(50) UNIQUE,
    asset_type VARCHAR(80),
    model VARCHAR(100),
    purchase_date DATE,
    assigned_to INT REFERENCES employees(employee_id),
    office_id INT REFERENCES offices(office_id),
    status VARCHAR(30)
);

CREATE TABLE incidents (
    incident_id SERIAL PRIMARY KEY,
    reported_by INT REFERENCES employees(employee_id),
    severity VARCHAR(20),
    category VARCHAR(80),
    opened_at TIMESTAMP,
    closed_at TIMESTAMP,
    status VARCHAR(30),
    description TEXT
);

CREATE TABLE system_logins (
    login_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    login_time TIMESTAMP,
    logout_time TIMESTAMP,
    ip_address VARCHAR(60),
    device_type VARCHAR(50),
    success_flag BOOLEAN
);

CREATE TABLE access_requests (
    request_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    system_name VARCHAR(100),
    requested_at TIMESTAMP,
    approved_by INT REFERENCES employees(employee_id),
    status VARCHAR(30)
);

-- =========================
-- PROCUREMENT / INVENTORY
-- =========================

CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    warehouse_name VARCHAR(150),
    office_id INT REFERENCES offices(office_id)
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    warehouse_id INT REFERENCES warehouses(warehouse_id),
    product_id INT REFERENCES products(product_id),
    quantity_available INT,
    reorder_level INT
);

CREATE TABLE purchase_orders (
    po_id SERIAL PRIMARY KEY,
    vendor_id INT REFERENCES vendors(vendor_id),
    created_by INT REFERENCES employees(employee_id),
    po_date DATE,
    total_amount NUMERIC(14,2),
    status VARCHAR(30)
);

-- =========================
-- INDEXES FOR OPTIMIZATION
-- =========================

CREATE INDEX idx_emp_department ON employees(department_id);
CREATE INDEX idx_emp_manager ON employees(manager_id);
CREATE INDEX idx_review_employee ON performance_reviews(employee_id);
CREATE INDEX idx_review_cycle ON performance_reviews(cycle_id);
CREATE INDEX idx_projects_manager ON projects(manager_id);
CREATE INDEX idx_sales_order_date ON sales_orders(order_date);
CREATE INDEX idx_sales_rep ON sales_orders(sales_rep_id);
CREATE INDEX idx_payroll_month ON payroll(payroll_month);
CREATE INDEX idx_attendance_date ON attendance(attendance_date);
CREATE INDEX idx_task_project ON tasks(project_id);
CREATE INDEX idx_login_employee ON system_logins(employee_id);
CREATE INDEX idx_incident_status ON incidents(status);