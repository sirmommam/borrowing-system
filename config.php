<?php
declare(strict_types=1);

$dbHost = getenv('DB_HOST') ?: 'db';
$dbName = getenv('DB_NAME') ?: 'sports_borrow_db';
$dbUser = getenv('DB_USER') ?: 'dev_user';
$dbPass = getenv('DB_PASSWORD') ?: 'dev_password';
$dbCharset = 'utf8mb4';

$dsn = "mysql:host={$dbHost};dbname={$dbName};charset={$dbCharset}";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $dbUser, $dbPass, $options);
} catch (PDOException $e) {
    http_response_code(500);
    die('Database connection failed: ' . $e->getMessage());
}
