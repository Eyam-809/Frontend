<?php
// Configuración de la base de datos
$host = 'localhost';
$db = 'supermercado_db';
$user = 'root';
$password = ''; // Cambia esto si has configurado una contraseña en XAMPP
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
];

try {
    $pdo = new PDO($dsn, $user, $password, $options);
} catch (PDOException $e) {
    throw new PDOException($e->getMessage(), (int)$e->getCode());
}

// Función para ejecutar procedimientos almacenados
function callProcedure($pdo, $procedure, $params = []) {
    $placeholders = implode(',', array_fill(0, count($params), '?'));
    $sql = "CALL $procedure($placeholders)";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    
    return $stmt->fetchAll();
}
?>
