-- Usar la base de datos
USE supermercado_db;

-- Procedimiento para registrar un nuevo usuario
DELIMITER //
CREATE PROCEDURE sp_register_user(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE user_exists INT DEFAULT 0;
    
    -- Verificar si el correo ya existe
    SELECT COUNT(*) INTO user_exists FROM users WHERE email = p_email;
    
    IF user_exists = 0 THEN
        -- Insertar el nuevo usuario
        INSERT INTO users (name, email, password) VALUES (p_name, p_email, p_password);
        
        -- Crear un carrito para el nuevo usuario
        INSERT INTO carts (user_id) VALUES (LAST_INSERT_ID());
        
        SELECT 'Usuario registrado exitosamente' AS message, LAST_INSERT_ID() AS user_id;
    ELSE
        SELECT 'El correo electrónico ya está registrado' AS message, 0 AS user_id;
    END IF;
END //
DELIMITER ;

-- Procedimiento para iniciar sesión
DELIMITER //
CREATE PROCEDURE sp_login_user(
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT id, name, email, password FROM users WHERE email = p_email;
END //
DELIMITER ;

-- Procedimiento para añadir un producto al carrito
DELIMITER //
CREATE PROCEDURE sp_add_to_cart(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_cart_id INT;
    DECLARE v_cart_item_exists INT DEFAULT 0;
    
    -- Obtener el ID del carrito del usuario
    SELECT id INTO v_cart_id FROM carts WHERE user_id = p_user_id;
    
    -- Verificar si el producto ya está en el carrito
    SELECT COUNT(*) INTO v_cart_item_exists FROM cart_items 
    WHERE cart_id = v_cart_id AND product_id = p_product_id;
    
    IF v_cart_item_exists > 0 THEN
        -- Actualizar la cantidad si el producto ya está en el carrito
        UPDATE cart_items 
        SET quantity = quantity + p_quantity 
        WHERE cart_id = v_cart_id AND product_id = p_product_id;
    ELSE
        -- Añadir el producto al carrito
        INSERT INTO cart_items (cart_id, product_id, quantity) 
        VALUES (v_cart_id, p_product_id, p_quantity);
    END IF;
    
    -- Devolver los detalles actualizados del carrito
    SELECT * FROM view_cart_details WHERE cart_id = v_cart_id;
END //
DELIMITER ;

-- Procedimiento para actualizar la cantidad de un producto en el carrito
DELIMITER //
CREATE PROCEDURE sp_update_cart_quantity(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_cart_id INT;
    
    -- Obtener el ID del carrito del usuario
    SELECT id INTO v_cart_id FROM carts WHERE user_id = p_user_id;
    
    IF p_quantity > 0 THEN
        -- Actualizar la cantidad
        UPDATE cart_items 
        SET quantity = p_quantity 
        WHERE cart_id = v_cart_id AND product_id = p_product_id;
    ELSE
        -- Eliminar el producto del carrito si la cantidad es 0 o menos
        DELETE FROM cart_items 
        WHERE cart_id = v_cart_id AND product_id = p_product_id;
    END IF;
    
    -- Devolver los detalles actualizados del carrito
    SELECT * FROM view_cart_details WHERE cart_id = v_cart_id;
END //
DELIMITER ;

-- Procedimiento para eliminar un producto del carrito
DELIMITER //
CREATE PROCEDURE sp_remove_from_cart(
    IN p_user_id INT,
    IN p_product_id INT
)
BEGIN
    DECLARE v_cart_id INT;
    
    -- Obtener el ID del carrito del usuario
    SELECT id INTO v_cart_id FROM carts WHERE user_id = p_user_id;
    
    -- Eliminar el producto del carrito
    DELETE FROM cart_items 
    WHERE cart_id = v_cart_id AND product_id = p_product_id;
    
    -- Devolver los detalles actualizados del carrito
    SELECT * FROM view_cart_details WHERE cart_id = v_cart_id;
END //
DELIMITER ;

-- Procedimiento para añadir un producto a favoritos
DELIMITER //
CREATE PROCEDURE sp_add_to_favorites(
    IN p_user_id INT,
    IN p_product_id INT
)
BEGIN
    DECLARE v_favorite_exists INT DEFAULT 0;
    
    -- Verificar si el producto ya está en favoritos
    SELECT COUNT(*) INTO v_favorite_exists FROM favorites 
    WHERE user_id = p_user_id AND product_id = p_product_id;
    
    IF v_favorite_exists = 0 THEN
        -- Añadir el producto a favoritos
        INSERT INTO favorites (user_id, product_id) 
        VALUES (p_user_id, p_product_id);
        
        SELECT 'Producto añadido a favoritos' AS message;
    ELSE
        SELECT 'El producto ya está en favoritos' AS message;
    END IF;
END //
DELIMITER ;

-- Procedimiento para eliminar un producto de favoritos
DELIMITER //
CREATE PROCEDURE sp_remove_from_favorites(
    IN p_user_id INT,
    IN p_product_id INT
)
BEGIN
    -- Eliminar el producto de favoritos
    DELETE FROM favorites 
    WHERE user_id = p_user_id AND product_id = p_product_id;
    
    SELECT 'Producto eliminado de favoritos' AS message;
END //
DELIMITER ;

-- Procedimiento para crear un nuevo pedido
DELIMITER //
CREATE PROCEDURE sp_create_order(
    IN p_user_id INT,
    IN p_payment_method_id INT,
    IN p_shipping_address TEXT,
    IN p_shipping_city VARCHAR(100),
    IN p_shipping_postal_code VARCHAR(20)
)
BEGIN
    DECLARE v_cart_id INT;
    DECLARE v_total_amount DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_order_id INT;
    
    -- Obtener el ID del carrito del usuario
    SELECT id INTO v_cart_id FROM carts WHERE user_id = p_user_id;
    
    -- Calcular el monto total del pedido
    SELECT SUM(
        CASE 
            WHEN p.discount > 0 THEN p.price * (1 - p.discount/100) * ci.quantity
            ELSE p.price * ci.quantity
        END
    ) INTO v_total_amount
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.id
    WHERE ci.cart_id = v_cart_id;
    
    -- Crear el pedido
    INSERT INTO orders (
        user_id, 
        total_amount, 
        payment_method_id, 
        payment_status, 
        shipping_address, 
        shipping_city, 
        shipping_postal_code, 
        order_status
    ) VALUES (
        p_user_id, 
        v_total_amount, 
        p_payment_method_id, 
        'pending', 
        p_shipping_address, 
        p_shipping_city, 
        p_shipping_postal_code, 
        'pending'
    );
    
    SET v_order_id = LAST_INSERT_ID();
    
    -- Transferir los productos del carrito al pedido
    INSERT INTO order_items (order_id, product_id, quantity, price, discount)
    SELECT 
        v_order_id, 
        p.id, 
        ci.quantity, 
        p.price, 
        CASE WHEN p.discount > 0 THEN (p.price * p.discount/100) ELSE 0 END
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.id
    WHERE ci.cart_id = v_cart_id;
    
    -- Si el método de pago es Oxxo, generar un código de referencia
    IF p_payment_method_id = 4 THEN
        INSERT INTO oxxo_payments (
            order_id, 
            reference_code, 
            barcode, 
            expiration_date, 
            status
        ) VALUES (
            v_order_id, 
            CONCAT('OXX', LPAD(v_order_id, 8, '0')), 
            CONCAT('987654321', LPAD(v_order_id, 10, '0')), 
            DATE_ADD(NOW(), INTERVAL 3 DAY), 
            'pending'
        );
    END IF;
    
    -- Vaciar el carrito
    DELETE FROM cart_items WHERE cart_id = v_cart_id;
    
    -- Devolver los detalles del pedido
    SELECT * FROM view_order_details WHERE order_id = v_order_id;
END //
DELIMITER ;

-- Procedimiento para obtener los productos por categoría y subcategoría
DELIMITER //
CREATE PROCEDURE sp_get_products_by_category(
    IN p_category_id INT,
    IN p_subcategory_id INT
)
BEGIN
    IF p_subcategory_id > 0 THEN
        -- Filtrar por subcategoría
        SELECT * FROM view_products_with_categories 
        WHERE category_id = p_category_id AND subcategory_id = p_subcategory_id;
    ELSE
        -- Filtrar solo por categoría
        SELECT * FROM view_products_with_categories 
        WHERE category_id = p_category_id;
    END IF;
END //
DELIMITER ;

-- Procedimiento para buscar productos
DELIMITER //
CREATE PROCEDURE sp_search_products(
    IN p_search_term VARCHAR(100)
)
BEGIN
    SELECT * FROM view_products_with_categories 
    WHERE 
        name LIKE CONCAT('%', p_search_term, '%') OR
        description LIKE CONCAT('%', p_search_term, '%') OR
        description_es LIKE CONCAT('%', p_search_term, '%') OR
        category_name LIKE CONCAT('%', p_search_term, '%') OR
        category_name_es LIKE CONCAT('%', p_search_term, '%') OR
        subcategory_name LIKE CONCAT('%', p_search_term, '%') OR
        subcategory_name_es LIKE CONCAT('%', p_search_term, '%');
END //
DELIMITER ;

-- Procedimiento para añadir una reseña de producto
DELIMITER //
CREATE PROCEDURE sp_add_product_review(
    IN p_product_id INT,
    IN p_user_id INT,
    IN p_rating INT,
    IN p_comment TEXT
)
BEGIN
    DECLARE v_review_exists INT DEFAULT 0;
    
    -- Verificar si el usuario ya ha dejado una reseña para este producto
    SELECT COUNT(*) INTO v_review_exists FROM product_reviews 
    WHERE product_id = p_product_id AND user_id = p_user_id;
    
    IF v_review_exists = 0 THEN
        -- Añadir la reseña
        INSERT INTO product_reviews (product_id, user_id, rating, comment) 
        VALUES (p_product_id, p_user_id, p_rating, p_comment);
        
        -- Actualizar la calificación promedio del producto
        UPDATE products p
        SET rating = (
            SELECT AVG(rating) 
            FROM product_reviews 
            WHERE product_id = p_product_id
        )
        WHERE id = p_product_id;
        
        SELECT 'Reseña añadida exitosamente' AS message;
    ELSE
        SELECT 'Ya has dejado una reseña para este producto' AS message;
    END IF;
END //
DELIMITER ;

-- Procedimiento para obtener el estado de un pago de Oxxo
DELIMITER //
CREATE PROCEDURE sp_get_oxxo_payment_status(
    IN p_reference_code VARCHAR(50)
)
BEGIN
    SELECT * FROM view_oxxo_payments_details 
    WHERE reference_code = p_reference_code;
END //
DELIMITER ;

-- Procedimiento para actualizar el estado de un pago de Oxxo
DELIMITER //
CREATE PROCEDURE sp_update_oxxo_payment_status(
    IN p_reference_code VARCHAR(50),
    IN p_status VARCHAR(20)
)
BEGIN
    DECLARE v_order_id INT;
    
    -- Obtener el ID del pedido
    SELECT order_id INTO v_order_id FROM oxxo_payments 
    WHERE reference_code = p_reference_code;
    
    -- Actualizar el estado del pago de Oxxo
    UPDATE oxxo_payments 
    SET status = p_status 
    WHERE reference_code = p_reference_code;
    
    -- Si el pago se completó, actualizar también el estado del pedido
    IF p_status = 'completed' THEN
        UPDATE orders 
        SET payment_status = 'completed', order_status = 'processing' 
        WHERE id = v_order_id;
    ELSEIF p_status = 'expired' THEN
        UPDATE orders 
        SET payment_status = 'failed', order_status = 'cancelled' 
        WHERE id = v_order_id;
    END IF;
    
    SELECT * FROM view_oxxo_payments_details 
    WHERE reference_code = p_reference_code;
END //
DELIMITER ;
