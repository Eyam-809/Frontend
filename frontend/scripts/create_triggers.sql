-- Usar la base de datos
USE supermercado_db;

-- Trigger para actualizar la calificación promedio del producto después de insertar una reseña
DELIMITER //
CREATE TRIGGER after_review_insert
AFTER INSERT ON product_reviews
FOR EACH ROW
BEGIN
    UPDATE products
    SET rating = (
        SELECT AVG(rating) 
        FROM product_reviews 
        WHERE product_id = NEW.product_id
    )
    WHERE id = NEW.product_id;
END //
DELIMITER ;

-- Trigger para actualizar la calificación promedio del producto después de actualizar una reseña
DELIMITER //
CREATE TRIGGER after_review_update
AFTER UPDATE ON product_reviews
FOR EACH ROW
BEGIN
    UPDATE products
    SET rating = (
        SELECT AVG(rating) 
        FROM product_reviews 
        WHERE product_id = NEW.product_id
    )
    WHERE id = NEW.product_id;
END //
DELIMITER ;

-- Trigger para actualizar la calificación promedio del producto después de eliminar una reseña
DELIMITER //
CREATE TRIGGER after_review_delete
AFTER DELETE ON product_reviews
FOR EACH ROW
BEGIN
    UPDATE products
    SET rating = (
        SELECT COALESCE(AVG(rating), 0) 
        FROM product_reviews 
        WHERE product_id = OLD.product_id
    )
    WHERE id = OLD.product_id;
END //
DELIMITER ;

-- Trigger para verificar el stock antes de añadir un producto al carrito
DELIMITER //
CREATE TRIGGER before_cart_item_insert
BEFORE INSERT ON cart_items
FOR EACH ROW
BEGIN
    DECLARE product_in_stock BOOLEAN;
    
    -- Verificar si el producto está en stock
    SELECT in_stock INTO product_in_stock 
    FROM products 
    WHERE id = NEW.product_id;
    
    IF NOT product_in_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto no está disponible en stock';
    END IF;
END //
DELIMITER ;

-- Trigger para verificar el stock antes de actualizar la cantidad en el carrito
DELIMITER //
CREATE TRIGGER before_cart_item_update
BEFORE UPDATE ON cart_items
FOR EACH ROW
BEGIN
    DECLARE product_in_stock BOOLEAN;
    
    -- Verificar si el producto está en stock
    SELECT in_stock INTO product_in_stock 
    FROM products 
    WHERE id = NEW.product_id;
    
    IF NOT product_in_stock THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto no está disponible en stock';
    END IF;
END //
DELIMITER ;

-- Trigger para crear un carrito automáticamente cuando se registra un nuevo usuario
DELIMITER //
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO carts (user_id) VALUES (NEW.id);
END //
DELIMITER ;
