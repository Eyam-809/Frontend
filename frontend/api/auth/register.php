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
if (!isset($data['name']) || !isset($data['email']) || !isset($data['password'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Datos incompletos']);
    exit;
}

// Validar formato de correo electrónico
if (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Formato de correo electrónico inválido']);
    exit;
}

// Validar longitud de contraseña
if (strlen($data['password']) < 8) {
    http_response_code(400);
    echo json_encode(['error' => 'La contraseña debe tener al menos 8 caracteres']);
    exit;
}

try {
    // Hashear la contraseña
    $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);
    
    // Llamar al procedimiento almacenado para registrar al usuario
    $result = callProcedure($pdo, 'sp_register_user', [
        $data['name'],
        $data['email'],
        $hashedPassword
    ]);
    
    // Verificar si el registro fue exitoso
    if ($result[0]['user_id'] > 0) {
        // Crear una sesión para el usuario
        session_start();
        $_SESSION['user_id'] = $result[0]['user_id'];
        $_SESSION['user_name'] = $data['name'];
        $_SESSION['user_email'] = $data['email'];
        
        echo json_encode([
            'success' => true,
            'message' => $result[0]['message'],
            'user' => [
                'id' => $result[0]['user_id'],
                'name' => $data['name'],
                'email' => $data['email']
            ]
        ]);
    } else {
        http_response_code(409);
        echo json_encode(['error' => $result[0]['message']]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error en el servidor: ' . $e->getMessage()]);
}
?>
