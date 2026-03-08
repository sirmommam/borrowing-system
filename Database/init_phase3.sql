USE sports_borrow_db;

CREATE TABLE IF NOT EXISTS users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin','user') NOT NULL DEFAULT 'user',
    student_id VARCHAR(20) NULL,
    first_name VARCHAR(100) NULL,
    last_name VARCHAR(100) NULL,
    profile_image VARCHAR(255) DEFAULT 'default.jpg',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_username (username),
    KEY idx_student_id (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS categories (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS equipment (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    quantity INT(11) NOT NULL DEFAULT 0,
    category_id INT(11) NOT NULL,
    image VARCHAR(255) DEFAULT 'default.jpg',
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_category_id (category_id),
    KEY idx_equipment_name (name),
    KEY idx_quantity (quantity),
    CONSTRAINT fk_equipment_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS borrowings (
    id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    equipment_id INT(11) NOT NULL,
    quantity INT(11) NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE NULL,
    status ENUM('borrowed','returned') NOT NULL DEFAULT 'borrowed',
    approval_status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
    approved_by INT(11) NULL,
    approved_at TIMESTAMP NULL,
    rejection_reason TEXT NULL,
    pickup_confirmed TINYINT(1) NOT NULL DEFAULT 0,
    pickup_time TIMESTAMP NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_approval_status (approval_status),
    KEY idx_pickup_confirmed (pickup_confirmed),
    KEY idx_approved_by (approved_by),
    KEY idx_borrow_date (borrow_date),
    KEY idx_user_approval (user_id, approval_status, pickup_confirmed),
    KEY idx_user_borrowing (user_id, status),
    CONSTRAINT fk_borrowings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_borrowings_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_borrowings_approved_by FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS deleted_borrowings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    original_id INT NOT NULL,
    equipment_id INT NOT NULL,
    user_id INT NOT NULL,
    borrow_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status ENUM('borrowed','returned') NOT NULL,
    approval_status ENUM('pending','approved','rejected') NOT NULL,
    pickup_confirmed TINYINT(1) DEFAULT 0,
    pickup_time DATETIME NULL,
    approved_by INT NULL,
    approved_at DATETIME NULL,
    deleted_at DATETIME NOT NULL,
    deleted_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_original_id (original_id),
    INDEX idx_equipment_id (equipment_id),
    INDEX idx_user_id (user_id),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_deleted_by (deleted_by),
    CONSTRAINT fk_deleted_borrowings_equipment FOREIGN KEY (equipment_id) REFERENCES equipment(id) ON DELETE CASCADE,
    CONSTRAINT fk_deleted_borrowings_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_deleted_borrowings_deleted_by FOREIGN KEY (deleted_by) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO categories (name, description)
SELECT 'Computer', 'Computer and IT equipment'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Computer');

INSERT INTO categories (name, description)
SELECT 'Office', 'Office tools and presentation equipment'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Office');

INSERT INTO categories (name, description)
SELECT 'Sports', 'Sports and fitness equipment'
WHERE NOT EXISTS (SELECT 1 FROM categories WHERE name = 'Sports');

INSERT INTO equipment (name, description, quantity, category_id)
SELECT 'Laptop Dell XPS 15', 'High-performance laptop', 5, c.id
FROM categories c
WHERE c.name = 'Computer'
  AND NOT EXISTS (SELECT 1 FROM equipment WHERE name = 'Laptop Dell XPS 15');

INSERT INTO equipment (name, description, quantity, category_id)
SELECT 'Projector Epson EB-X41', 'Projector for class presentation', 3, c.id
FROM categories c
WHERE c.name = 'Office'
  AND NOT EXISTS (SELECT 1 FROM equipment WHERE name = 'Projector Epson EB-X41');

INSERT INTO equipment (name, description, quantity, category_id)
SELECT 'Football', 'Standard training football', 10, c.id
FROM categories c
WHERE c.name = 'Sports'
  AND NOT EXISTS (SELECT 1 FROM equipment WHERE name = 'Football');

INSERT INTO users (username, password, role, first_name, last_name)
SELECT 'admin', '$2y$10$NIc/F9mzUKxqjYkhPwPNIusNrrYUmVvm/G6rhC6xJ.RoCbMOzDIJG', 'admin', 'System', 'Admin'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin');

INSERT INTO users (username, password, role, student_id, first_name, last_name)
SELECT 'student1', '$2y$10$5vVmn2ISzsDwsydAKQ1mm.DhPdQar0mgVa5O6oMhTesCKIF0kHIPG', 'user', '6401001', 'Student', 'One'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'student1');

INSERT INTO users (username, password, role, student_id, first_name, last_name)
SELECT 'student2', '$2y$10$JydXyPtkCBNApwNQB9itfet.jbmHN6qD2E2Uy6ID8lJxkDsrbCWzC', 'user', '6401002', 'Student', 'Two'
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'student2');
