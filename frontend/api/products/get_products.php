<?php
require_once '../../lib/db_connection.php';
header('Content-Type: application/json');

// Verificar si es una solicitud GET
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit;
}

try {
    // Obtener parámetros de la URL
    $category_id = isset($_GET['category_id']) ? (int)$_GET['category_id'] : 0;
    $subcategory_id = isset($_GET['subcategory_id']) ? (int)$_GET['subcategory_id'] : 0;
    $search = isset($_GET['search']) ? $_GET['search'] : '';
    
    if (!empty($search)) {
        // Buscar productos por término de búsqueda
        $result = callProcedure($pdo, 'sp_search_products', [$search]);
    } elseif ($category_id > 0) {
        // Obtener productos por categoría y subcategoría
        $result = callProcedure($pdo, 'sp_get_products_by_category', [$category_id, $subcategory_id]);
    } else {
        // Obtener todos los productos
        $stmt = $pdo->query('SELECT * FROM view_products_with_categories');
        $result = $stmt->fetchAll();
    }
    
    echo json_encode([
        'success' => true,
        'products' => $result,
        'count' => count($result)
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error en el servidor: ' . $e->getMessage()]);
}
?>
