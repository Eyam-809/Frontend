-- Usar la base de datos
USE supermercado_db;

-- Vista para productos con categoría y subcategoría
CREATE OR REPLACE VIEW view_products_with_categories AS
SELECT 
    p.id,
    p.name,
    p.price,
    p.original_price,
    p.rating,
    p.image,
    p.discount,
    p.is_new,
    c.name AS category_name,
    c.name_es AS category_name_es,
    s.name AS subcategory_name,
    s.name_es AS subcategory_name_es,
    p.description,
    p.description_es,
    p.in_stock,
    p.created_at,
    p.updated_at
FROM 
    products p
JOIN 
    categories c ON p.category_id = c.id
JOIN 
    subcategories s ON p.subcategory_id = s.id;

-- Vista para carrito de compras con detalles de productos
CREATE OR REPLACE VIEW view_cart_details AS
SELECT 
    ci.id AS cart_item_id,
    c.id AS cart_id,
    c.user_id,
    p.id AS product_id,
    p.name AS product_name,
    p.price,
    p.discount,
    p.image,
    ci.quantity,
    CASE 
        WHEN p.discount > 0 THEN p.price * (1 - p.discount/100) * ci.quantity
        ELSE p.price * ci.quantity
    END AS subtotal
FROM 
    cart_items ci
JOIN 
    carts c ON ci.cart_id = c.id
JOIN 
    products p ON ci.product_id = p.id;

-- Vista para favoritos con detalles de productos
CREATE OR REPLACE VIEW view_favorites_details AS
SELECT 
    f.id AS favorite_id,
    f.user_id,
    p.id AS product_id,
    p.name AS product_name,
    p.price,
    p.discount,
    p.image,
    p.rating,
    c.name AS category_name,
    c.name_es AS category_name_es,
    s.name AS subcategory_name,
    s.name_es AS subcategory_name_es
FROM 
    favorites f
JOIN 
    products p ON f.product_id = p.id
JOIN 
    categories c ON p.category_id = c.id
JOIN 
    subcategories s ON p.subcategory_id = s.id;

-- Vista para pedidos con detalles
CREATE OR REPLACE VIEW view_order_details AS
SELECT 
    o.id AS order_id,
    o.user_id,
    u.name AS user_name,
    u.email AS user_email,
    o.total_amount,
    pm.name AS payment_method,
    o.payment_status,
    o.shipping_address,
    o.shipping_city,
    o.shipping_postal_code,
    o.order_status,
    o.created_at AS order_date,
    COUNT(oi.id) AS total_items,
    SUM(oi.quantity) AS total_quantity
FROM 
    orders o
JOIN 
    users u ON o.user_id = u.id
JOIN 
    payment_methods pm ON o.payment_method_id = pm.id
JOIN 
    order_items oi ON o.id = oi.order_id
GROUP BY 
    o.id, o.user_id, u.name, u.email, o.total_amount, pm.name, o.payment_status, 
    o.shipping_address, o.shipping_city, o.shipping_postal_code, o.order_status, o.created_at;

-- Vista para reseñas de productos con detalles de usuario
CREATE OR REPLACE VIEW view_product_reviews_details AS
SELECT 
    pr.id AS review_id,
    pr.product_id,
    p.name AS product_name,
    pr.user_id,
    u.name AS user_name,
    pr.rating,
    pr.comment,
    pr.created_at AS review_date
FROM 
    product_reviews pr
JOIN 
    products p ON pr.product_id = p.id
JOIN 
    users u ON pr.user_id = u.id;

-- Vista para pagos de Oxxo con detalles de pedido
CREATE OR REPLACE VIEW view_oxxo_payments_details AS
SELECT 
    op.id AS oxxo_payment_id,
    op.order_id,
    op.reference_code,
    op.barcode,
    op.expiration_date,
    op.status AS payment_status,
    o.user_id,
    u.name AS user_name,
    u.email AS user_email,
    o.total_amount,
    o.order_status
FROM 
    oxxo_payments op
JOIN 
    orders o ON op.order_id = o.id
JOIN 
    users u ON o.user_id = u.id;
