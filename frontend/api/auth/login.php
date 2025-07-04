<?php
require_once '../../lib/db_connection.php';
header('Content-Type: application/json');

// Verificar si es una solicitud POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit;
}

// Obtener datos del cuerpo de la solicitud
$data = json_decode(file_get_contents('php://input'), true);

// Validar datos requeridos
if (!isset($data['email']) || !isset($data['password'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Datos incompletos']);
    exit;
}

try {
    // Llamar al procedimiento almacenado para obtener los datos del usuario
    $result = callProcedure($pdo, 'sp_login_user', [$data['email']]);
    
    // Verificar si el usuario existe
    if (empty($result)) {
        http_response_code(401);
        echo json_encode(['error' => 'Correo electrónico o contraseña incorrectos']);
        exit;
    }
    
    $user = $result[0];
    
    // Verificar la contraseña
    if (!password_verify($data['password'], $user['password'])) {
        http_response_code(401);
        echo json_encode(['error' => 'Correo electrónico o contraseña incorrectos']);
        exit;
    }
    
    // Crear una sesión para el usuario
    session_start();
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['user_name'] = $user['name'];
    $_SESSION['user_email'] = $user['email'];
    
    // Devolver los datos del usuario (sin la contraseña)
    unset($user['password']);
    echo json_encode([
        'success' => true,
        'message' => 'Inicio de sesión exitoso',
        'user' => $user
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error en el servidor: ' . $e->getMessage()]);
}
?>
