-- Create Database
CREATE DATABASE IF NOT EXISTS enterprise_task_db
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE enterprise_task_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('Admin', 'Developer', 'Designer', 'QA', 'Manager') NOT NULL DEFAULT 'Developer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_role (role)
) ENGINE=InnoDB;

-- 2. Tasks Table
CREATE TABLE IF NOT EXISTS tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL DEFAULT 'MEDIUM',
    status ENUM('TODO', 'IN_PROGRESS', 'IN_REVIEW', 'DONE') NOT NULL DEFAULT 'TODO',
    assignee_id BIGINT,
    due_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_task_assignee FOREIGN KEY (assignee_id) 
        REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_task_status (status),
    INDEX idx_task_priority (priority),
    INDEX idx_task_assignee (assignee_id)
) ENGINE=InnoDB;

-- 3. Activity Logs Table (For Python Analytics & Auditing)
CREATE TABLE IF NOT EXISTS activity_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    task_id BIGINT,
    action_type VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_task FOREIGN KEY (task_id) 
        REFERENCES tasks(id) ON DELETE CASCADE,
    INDEX idx_log_created (created_at)
) ENGINE=InnoDB;

-- Seed Initial Data
INSERT INTO users (name, email, role) VALUES
('Sarah Connor', 'sarah.c@company.com', 'Admin'),
('Alex Rivera', 'alex.r@company.com', 'Developer'),
('Elena Rostova', 'elena.r@company.com', 'Developer'),
('Marcus Vance', 'marcus.v@company.com', 'Designer');

INSERT INTO tasks (title, description, priority, status, assignee_id, due_date) VALUES
('Migrate Auth to OAuth2', 'Upgrade existing JWT filter to OAuth2 authorization server', 'CRITICAL', 'IN_PROGRESS', 2, '2026-10-15'),
('Optimize Query Performance', 'Index tasks table on status and assignee fields', 'HIGH', 'TODO', 3, '2026-10-20'),
('Design System Refactor', 'Create cohesive dark palette component tokens', 'MEDIUM', 'IN_REVIEW', 4, '2026-10-12'),
('CI/CD Pipeline Fix', 'Resolve runner timeout on Java integration step', 'HIGH', 'DONE', 1, '2026-10-01');
