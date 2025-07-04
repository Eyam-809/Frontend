<?php
header('Content-Type: application/json');

// Iniciar sesión
session_start();

// Destruir la sesión
session_destroy();

echo json_encode([
    'success' => true,
    'message' => 'Sesión cerrada exitosamente'
]);
?>
