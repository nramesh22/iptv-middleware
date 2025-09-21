# IPTV Middleware
Perfect! I’ll prepare a **complete IPTV Middleware package** with all the features we discussed, and provide step-by-step instructions to install it on **Ubuntu**.

---

# 1️⃣ Full Package Structure

```
iptv-middleware/
├── assets/
│   ├── css/
│   │   ├── bootstrap.min.css
│   │   └── style.css
│   └── js/
│       ├── bootstrap.bundle.min.js
│       └── chart.min.js
├── admin/
│   ├── dashboard.php
│   ├── resellers.php
│   ├── credit_requests.php
│   └── login.php
├── reseller/
│   ├── login.php
│   ├── dashboard.php
│   ├── create_subscription.php
│   ├── my_customers.php
│   ├── topup.php
│   ├── header.php
│   ├── footer.php
│   └── logout.php
├── db.php
├── channels.php
├── plans.php
├── subscriptions.php
└── README.md
```

> Includes:

* Admin panel
* Reseller module
* Subscription management
* Credit top-up system
* Dashboard charts with Chart.js
* Bootstrap + custom CSS

---

# 2️⃣ Database Setup

### 2.1 Create Database

```sql
CREATE DATABASE iptv_middleware;
USE iptv_middleware;
```

### 2.2 Create Tables

```sql
-- Admins
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Resellers
CREATE TABLE resellers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    credits DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Plans
CREATE TABLE plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    duration_days INT,
    credit_cost DECIMAL(10,2)
);

-- Channels
CREATE TABLE channels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    stream_url VARCHAR(255)
);

-- Subscriptions
CREATE TABLE subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    plan_id INT,
    start_date DATE,
    end_date DATE,
    status ENUM('active','expired') DEFAULT 'active',
    reseller_id INT
);

-- Credit Requests
CREATE TABLE credit_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reseller_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending','approved','rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

# 3️⃣ Install Dependencies on Ubuntu

### 3.1 Update System

```bash
sudo apt update
sudo apt upgrade -y
```

### 3.2 Install Apache, PHP & MySQL

```bash
sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql php-curl php-mbstring -y
```

### 3.3 Enable Apache Modules

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

---

# 4️⃣ Configure MySQL

```bash
sudo mysql
```

```sql
-- Create user
CREATE USER 'iptvuser'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON iptv_middleware.* TO 'iptvuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

> Update `db.php` with these credentials.

---

# 5️⃣ Deploy Files

```bash
sudo mkdir -p /var/www/html/iptv-middleware
sudo cp -r iptv-middleware/* /var/www/html/iptv-middleware/
sudo chown -R www-data:www-data /var/www/html/iptv-middleware
sudo chmod -R 755 /var/www/html/iptv-middleware
```

---

# 6️⃣ Apache Virtual Host (Optional)

```bash
sudo nano /etc/apache2/sites-available/iptv.conf
```

```apache
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot /var/www/html/iptv-middleware
    ServerName iptv.local
    <Directory /var/www/html/iptv-middleware>
        AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/iptv_error.log
    CustomLog ${APACHE_LOG_DIR}/iptv_access.log combined
</VirtualHost>
```

```bash
sudo a2ensite iptv.conf
sudo systemctl reload apache2
```

> Add `127.0.0.1 iptv.local` in `/etc/hosts` for local testing.

---

# 7️⃣ Access the System

* Admin Login: `http://your-server/iptv-middleware/admin/login.php`
* Reseller Login: `http://your-server/iptv-middleware/reseller/login.php`

> First, insert an admin user manually:

```sql
INSERT INTO admins (username,password) VALUES ('admin', '{hashed_password}');
```

Generate hashed password using PHP:

```php
<?php echo password_hash('admin123', PASSWORD_DEFAULT); ?>
```

---

# 8️⃣ Optional: Cron Jobs

* To auto-expire subscriptions, add cron:

```bash
crontab -e
```

```bash
* * * * * /usr/bin/php /var/www/html/iptv-middleware/expire_subscriptions.php
```

> `expire_subscriptions.php` should check `subscriptions` where `end_date < today` and set status to `expired`.

---

# ✅ Full Package Features

1. Admin Panel
2. Reseller Module
3. Subscription Management
4. Credit Top-Up Requests & Approval
5. Dashboard Charts (Reseller Sales, Top-Ups, Monthly Trends)
6. Bootstrap + Chart.js UI
7. Cron-based subscription expiry

---