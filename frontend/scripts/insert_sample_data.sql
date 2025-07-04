-- Usar la base de datos
USE supermercado_db;

-- Insertar categorías
INSERT INTO categories (name, name_es) VALUES 
('Electronics', 'Electrónicos'),
('Fashion', 'Moda'),
('Home', 'Hogar'),
('Sports', 'Deportes'),
('Beauty', 'Belleza'),
('Toys', 'Juguetes');

-- Insertar subcategorías
-- Electronics subcategories
INSERT INTO subcategories (category_id, name, name_es) VALUES 
(1, 'Smartphones', 'Teléfonos'),
(1, 'Laptops', 'Portátiles'),
(1, 'Headphones', 'Auriculares'),
(1, 'Cameras', 'Cámaras');

-- Fashion subcategories
INSERT INTO subcategories (category_id, name, name_es) VALUES 
(2, 'Men''s Clothing', 'Ropa de Hombre'),
(2, 'Women''s Clothing', 'Ropa de Mujer'),
(2, 'Shoes', 'Zapatos'),
(2, 'Accessories', 'Accesorios');

-- Home subcategories
INSERT INTO subcategories (category_id, name, name_es) VALUES 
(3, 'Kitchen', 'Cocina'),
(3, 'Bedroom', 'Dormitorio'),
(3, 'Living Room', 'Sala de Estar'),
(3, 'Garden', 'Jardín');

-- Sports subcategories
INSERT INTO subcategories (category_id, name, name_es) VALUES 
(4, 'Fitness', 'Fitness'),
(4, 'Outdoor', 'Aire Libre'),
(4, 'Team Sports', 'Deportes de Equipo'),
(4, 'Water Sports', 'Deportes Acuáticos');

-- Beauty subcategories
INSERT INTO subcategories (category_id, name, name_es) VALUES 
(5, 'Skincare', 'Cuidado de la Piel'),
(5, 'Makeup', 'Maquillaje'),
(5, 'Hair Care', 'Cuidado del Cabello'),
(5, 'Fragrances', 'Fragancias');

-- Toys subcategories
INSERT INTO subcategories (category_id, name, name_es) VALUES 
(6, 'Educational', 'Educativos'),
(6, 'Action Figures', 'Figuras de Acción'),
(6, 'Board Games', 'Juegos de Mesa'),
(6, 'Outdoor Toys', 'Juguetes de Exterior');

-- Insertar métodos de pago
INSERT INTO payment_methods (name, description, is_active) VALUES
('Credit Card', 'Pay with Visa, Mastercard, or American Express', TRUE),
('PayPal', 'Pay with your PayPal account', TRUE),
('Apple Pay', 'Pay with Apple Pay on supported devices', TRUE),
('Oxxo', 'Pay in cash at any Oxxo store', TRUE);

-- Insertar productos de muestra (10 productos por categoría)
-- Electronics - Smartphones
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('Ultra Smartphone X', 899.99, 999.99, 4.7, '/placeholder.svg?height=200&width=200', 10, TRUE, 1, 1, 
'Latest flagship smartphone with 6.7-inch AMOLED display, 108MP camera, and 5G connectivity. Features all-day battery life and fast charging.',
'Último smartphone insignia con pantalla AMOLED de 6.7 pulgadas, cámara de 108MP y conectividad 5G. Cuenta con batería de larga duración y carga rápida.',
TRUE),
('Budget Phone Pro', 299.99, NULL, 4.3, '/placeholder.svg?height=200&width=200', 0, FALSE, 1, 1, 
'Affordable smartphone with great performance. Features 6.5-inch display, quad-camera system, and large battery capacity.',
'Smartphone asequible con gran rendimiento. Cuenta con pantalla de 6.5 pulgadas, sistema de cuatro cámaras y gran capacidad de batería.',
TRUE),
('Foldable Smartphone', 1299.99, 1499.99, 4.5, '/placeholder.svg?height=200&width=200', 13, TRUE, 1, 1, 
'Revolutionary foldable smartphone with dual screens. Unfolds to tablet size with seamless display and powerful multitasking capabilities.',
'Smartphone plegable revolucionario con pantallas duales. Se despliega a tamaño de tableta con pantalla perfecta y potentes capacidades multitarea.',
TRUE);

-- Electronics - Laptops
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('Ultra Slim Laptop', 1299.99, 1499.99, 4.6, '/placeholder.svg?height=200&width=200', 13, TRUE, 1, 2, 
'Ultra-thin and lightweight laptop with 14-inch 4K display. Features all-day battery life, backlit keyboard, and powerful performance in a slim package.',
'Portátil ultradelgado y ligero con pantalla 4K de 14 pulgadas. Cuenta con batería de larga duración, teclado retroiluminado y potente rendimiento en un paquete delgado.',
TRUE),
('Gaming Laptop Pro', 1799.99, NULL, 4.8, '/placeholder.svg?height=200&width=200', 0, TRUE, 1, 2, 
'High-performance gaming laptop with NVIDIA RTX graphics, 144Hz display, and RGB keyboard. Designed for immersive gaming experiences.',
'Portátil gaming de alto rendimiento con gráficos NVIDIA RTX, pantalla de 144Hz y teclado RGB. Diseñado para experiencias de juego inmersivas.',
TRUE),
('Business Ultrabook', 1099.99, 1299.99, 4.5, '/placeholder.svg?height=200&width=200', 15, FALSE, 1, 2, 
'Professional laptop with enhanced security features, long battery life, and durable construction. Perfect for business travelers and remote workers.',
'Portátil profesional con características de seguridad mejoradas, larga duración de batería y construcción duradera. Perfecto para viajeros de negocios y trabajadores remotos.',
TRUE);

-- Fashion - Men's Clothing
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('Classic Fit Dress Shirt', 49.99, 59.99, 4.5, '/placeholder.svg?height=200&width=200', 17, FALSE, 2, 5, 
'Crisp cotton dress shirt with classic collar and regular fit. Features wrinkle-resistant fabric and available in multiple colors.',
'Camisa de vestir de algodón con cuello clásico y ajuste regular. Cuenta con tela resistente a las arrugas y disponible en múltiples colores.',
TRUE),
('Slim Fit Chino Pants', 39.99, NULL, 4.3, '/placeholder.svg?height=200&width=200', 0, FALSE, 2, 5, 
'Versatile chino pants with slim fit and stretch fabric for comfort. Perfect for casual and business casual settings.',
'Pantalones chinos versátiles con ajuste slim y tela elástica para mayor comodidad. Perfectos para entornos casuales y semi-formales.',
TRUE),
('Wool Blend Blazer', 129.99, 159.99, 4.6, '/placeholder.svg?height=200&width=200', 19, TRUE, 2, 5, 
'Sophisticated blazer with wool blend fabric and modern fit. Features notched lapels and two-button closure.',
'Blazer sofisticado con mezcla de lana y ajuste moderno. Cuenta con solapas y cierre de dos botones.',
TRUE);

-- Home - Kitchen
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('Stand Mixer', 249.99, 299.99, 4.8, '/placeholder.svg?height=200&width=200', 17, TRUE, 3, 9, 
'Professional stand mixer with 5-quart stainless steel bowl. Includes multiple attachments for various cooking tasks.',
'Batidora profesional con recipiente de acero inoxidable de 5 cuartos. Incluye múltiples accesorios para varias tareas de cocina.',
TRUE),
('Non-Stick Cookware Set', 149.99, NULL, 4.6, '/placeholder.svg?height=200&width=200', 0, FALSE, 3, 9, 
'10-piece non-stick cookware set with glass lids. Features even heat distribution and stay-cool handles.',
'Juego de utensilios de cocina antiadherentes de 10 piezas con tapas de vidrio. Cuenta con distribución uniforme del calor y mangos que se mantienen fríos.',
TRUE),
('Espresso Machine', 199.99, 249.99, 4.7, '/placeholder.svg?height=200&width=200', 20, TRUE, 3, 9, 
'Semi-automatic espresso machine with milk frother. Features 15-bar pressure pump and easy-to-use controls.',
'Máquina de espresso semiautomática con espumador de leche. Cuenta con bomba de presión de 15 bares y controles fáciles de usar.',
TRUE);

-- Sports - Fitness
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('Adjustable Dumbbells', 199.99, 249.99, 4.7, '/placeholder.svg?height=200&width=200', 20, TRUE, 4, 13, 
'Space-saving adjustable dumbbells with quick weight change. Features 5-50 lbs per dumbbell with secure locking mechanism.',
'Mancuernas ajustables que ahorran espacio con cambio rápido de peso. Cuenta con 5-50 libras por mancuerna con mecanismo de bloqueo seguro.',
TRUE),
('Yoga Mat Premium', 39.99, NULL, 4.6, '/placeholder.svg?height=200&width=200', 0, FALSE, 4, 13, 
'Extra thick yoga mat with superior grip and cushioning. Features eco-friendly materials and carrying strap.',
'Tapete de yoga extra grueso con agarre superior y amortiguación. Cuenta con materiales ecológicos y correa de transporte.',
TRUE),
('Resistance Bands Set', 29.99, 39.99, 4.5, '/placeholder.svg?height=200&width=200', 25, FALSE, 4, 13, 
'Complete resistance band set with 5 different resistance levels. Includes door anchor, handles, and ankle straps.',
'Juego completo de bandas de resistencia con 5 niveles diferentes. Incluye anclaje para puerta, asas y correas para tobillos.',
TRUE);

-- Beauty - Skincare
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('Vitamin C Serum', 29.99, 39.99, 4.6, '/placeholder.svg?height=200&width=200', 25, TRUE, 5, 17, 
'Brightening vitamin C serum with hyaluronic acid. Features antioxidant protection and helps reduce dark spots.',
'Suero de vitamina C iluminador con ácido hialurónico. Cuenta con protección antioxidante y ayuda a reducir las manchas oscuras.',
TRUE),
('Retinol Night Cream', 34.99, NULL, 4.7, '/placeholder.svg?height=200&width=200', 0, FALSE, 5, 17, 
'Anti-aging night cream with retinol and peptides. Helps reduce fine lines and improve skin texture overnight.',
'Crema de noche antienvejecimiento con retinol y péptidos. Ayuda a reducir las líneas finas y mejorar la textura de la piel durante la noche.',
TRUE),
('Gentle Cleanser', 19.99, 24.99, 4.5, '/placeholder.svg?height=200&width=200', 20, FALSE, 5, 17, 
'Gentle foaming cleanser for all skin types. Removes makeup and impurities without stripping natural oils.',
'Limpiador espumoso suave para todo tipo de piel. Elimina el maquillaje y las impurezas sin eliminar los aceites naturales.',
TRUE);

-- Toys - Educational
INSERT INTO products (name, price, original_price, rating, image, discount, is_new, category_id, subcategory_id, description, description_es, in_stock) VALUES
('STEM Building Kit', 39.99, 49.99, 4.7, '/placeholder.svg?height=200&width=200', 20, TRUE, 6, 21, 
'Engineering building kit with 200+ pieces. Encourages STEM learning through hands-on construction projects.',
'Kit de construcción de ingeniería con más de 200 piezas. Fomenta el aprendizaje STEM a través de proyectos de construcción prácticos.',
TRUE),
('Learning Tablet', 59.99, NULL, 4.5, '/placeholder.svg?height=200&width=200', 0, FALSE, 6, 21, 
'Interactive learning tablet for ages 3-7. Features educational games, parental controls, and durable design.',
'Tableta de aprendizaje interactiva para niños de 3 a 7 años. Cuenta con juegos educativos, controles parentales y diseño duradero.',
TRUE),
('Science Experiment Kit', 29.99, 39.99, 4.6, '/placeholder.svg?height=200&width=200', 25, FALSE, 6, 21, 
'Safe science kit with 20+ experiments. Includes lab equipment and detailed instruction manual.',
'Kit de ciencia seguro con más de 20 experimentos. Incluye equipo de laboratorio y manual de instrucciones detallado.',
TRUE);

-- Insertar usuarios de muestra
INSERT INTO users (name, email, password) VALUES
('Juan Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'), -- password: password
('María García', 'maria@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'), -- password: password
('Carlos Rodríguez', 'carlos@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi'); -- password: password

-- Crear carritos para los usuarios
INSERT INTO carts (user_id) VALUES (1), (2), (3);

-- Añadir items al carrito del usuario 1
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 5, 2);

-- Añadir favoritos para el usuario 1
INSERT INTO favorites (user_id, product_id) VALUES
(1, 3),
(1, 7),
(1, 10);

-- Añadir direcciones para los usuarios
INSERT INTO user_addresses (user_id, address_line1, city, state, postal_code, is_default) VALUES
(1, 'Calle Principal 123', 'Ciudad de México', 'CDMX', '01000', TRUE),
(2, 'Avenida Juárez 456', 'Guadalajara', 'Jalisco', '44100', TRUE),
(3, 'Calle Reforma 789', 'Monterrey', 'Nuevo León', '64000', TRUE);

-- Añadir reseñas de productos
INSERT INTO product_reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, '¡Excelente smartphone! La cámara es increíble y la batería dura todo el día.'),
(1, 2, 4, 'Muy buen teléfono, pero un poco caro para lo que ofrece.'),
(2, 3, 5, 'Gran relación calidad-precio. Lo recomiendo totalmente.'),
(5, 1, 4, 'Potente laptop para gaming, pero se calienta un poco durante sesiones largas.');

-- Crear un pedido de ejemplo
INSERT INTO orders (user_id, total_amount, payment_method_id, payment_status, shipping_address, shipping_city, shipping_postal_code, order_status) VALUES
(1, 1199.98, 4, 'pending', 'Calle Principal 123', 'Ciudad de México', '01000', 'processing');

-- Añadir items al pedido
INSERT INTO order_items (order_id, product_id, quantity, price, discount) VALUES
(1, 1, 1, 899.99, 90.00),
(1, 5, 1, 299.99, 0.00);

-- Crear un código de pago de Oxxo para el pedido
INSERT INTO oxxo_payments (order_id, reference_code, barcode, expiration_date, status) VALUES
(1, 'OXX123456789', '9876543210123456', DATE_ADD(NOW(), INTERVAL 3 DAY), 'pending');
