<?php
require_once '../../lib/db_connection.php';
header('Content-Type: application/json');

// Verificar si el usuario está autenticado
session_start();
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(['error' => 'No autenticado']);
    exit;
}

// Verificar si es una solicitud PUT
if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit;
}

// Obtener datos del cuerpo de la solicitud
$data = json_decode(file_get_contents('php://input'), true);

// Validar datos requeridos
if (!isset($data['product_id']) || !isset($data['quantity'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Datos inválidos']);
    exit;
}

try {
    // Llamar al procedimiento almacenado para actualizar la cantidad
    $result = callProcedure($pdo, 'sp_update_cart_quantity', [
        $_SESSION['user_id'],
        $data['product_id'],
        $data['quantity']
    ]);
    
    echo json_encode([
        'success' => true,
        'message' => 'Cantidad actualizada',
        'cart_items' => $result
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error en el servidor: ' . $e->getMessage()]);
}
?>
