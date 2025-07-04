<?php
require_once '../../lib/db_connection.php';
header('Content-Type: application/json');

// Verificar si es una solicitud GET
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Método no permitido']);
    exit;
}

// Obtener el ID del producto de la URL
$product_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($product_id <= 0) {
    http_response_code(400);
    echo json_encode(['error' => 'ID de producto inválido']);
    exit;
}

try {
    // Obtener los detalles del producto
    $stmt = $pdo->prepare('SELECT * FROM view_products_with_categories WHERE id = ?');
    $stmt->execute([$product_id]);
    $product = $stmt->fetch();
    
    if (!$product) {
        http_response_code(404);
        echo json_encode(['error' => 'Producto no encontrado']);
        exit;
    }
    
    // Obtener imágenes adicionales del producto
    $stmt = $pdo->prepare('SELECT * FROM product_images WHERE product_id = ?');
    $stmt->execute([$product_id]);
    $images = $stmt->fetchAll();
    
    // Obtener reseñas del producto
    $stmt = $pdo->prepare('SELECT * FROM view_product_reviews_details WHERE product_id = ?');
    $stmt->execute([$product_id]);
    $reviews = $stmt->fetchAll();
    
    // Obtener productos relacionados (misma categoría)
    $stmt = $pdo->prepare('
        SELECT * FROM view_products_with_categories 
        WHERE category_id = ? AND id != ? 
        LIMIT 4
    ');
    $stmt->execute([$product['category_id'], $product_id]);
    $related_products = $stmt->fetchAll();
    
    echo json_encode([
        'success' => true,
        'product' => $product,
        'images' => $images,
        'reviews' => $reviews,
        'related_products' => $related_products
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Error en el servidor: ' . $e->getMessage()]);
}
?>
