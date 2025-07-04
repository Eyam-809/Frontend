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

// Verificar si es
