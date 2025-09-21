
-- Database: iptv_middleware
CREATE DATABASE IF NOT EXISTS iptv_middleware;
USE iptv_middleware;

CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE resellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    credits DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    duration_days INT,
    credit_cost DECIMAL(10,2)
);

CREATE TABLE channels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    stream_url VARCHAR(255)
);

CREATE TABLE subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    plan_id INT,
    start_date DATE,
    end_date DATE,
    status ENUM('active','expired') DEFAULT 'active',
    reseller_id INT
);

CREATE TABLE credit_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reseller_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending','approved','rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample admin user
INSERT INTO admins (username,password) VALUES ('admin','\$2y\$10\$examplehashplaceholder');
