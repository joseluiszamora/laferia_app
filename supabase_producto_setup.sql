-- Configuración de base de datos para módulo de Productos en Supabase
-- Este archivo configura las tablas, políticas RLS, índices y datos de ejemplo
-- para el sistema de gestión de productos de La Feria App

-- =====================================
-- CREAR TABLA PRODUCTOS
-- =====================================

-- Crear la tabla Producto principal
CREATE TABLE IF NOT EXISTS "Producto" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    
    -- Precios y ofertas
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    discounted_price DECIMAL(10,2) CHECK (discounted_price >= 0 AND discounted_price < price),
    accept_offers BOOLEAN DEFAULT false,
    
    -- Relaciones
    categoria_id UUID NOT NULL REFERENCES "Category"(category_id) ON DELETE RESTRICT,
    marca_id UUID, -- Referencia a tabla de marcas (se puede crear después)
    
    -- Estado y disponibilidad
    status VARCHAR(20) DEFAULT 'borrador' CHECK (status IN ('borrador', 'publicado', 'archivado')),
    is_available BOOLEAN DEFAULT true,
    is_favorite BOOLEAN DEFAULT false,
    
    -- URLs de imágenes
    logo_url TEXT,
    
    -- Metadatos temporales
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================
-- CREAR TABLA PRODUCTO_ATRIBUTOS
-- =====================================

-- Tabla para atributos personalizados de productos (talla, color, material, etc.)
CREATE TABLE IF NOT EXISTS "ProductoAtributos" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES "Producto"(id) ON DELETE CASCADE,
    nombre VARCHAR(100) NOT NULL, -- Ej: "Talla", "Color", "Material"
    valor VARCHAR(255) NOT NULL,  -- Ej: "L", "Rojo", "Algodón"
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================
-- CREAR TABLA PRODUCTO_MEDIAS
-- =====================================

-- Tabla para gestionar imágenes y videos de productos
CREATE TABLE IF NOT EXISTS "ProductoMedias" (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES "Producto"(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL DEFAULT 'image' CHECK (type IN ('image', 'video')),
    url TEXT NOT NULL,
    thumbnail_url TEXT,
    
    -- Dimensiones para imágenes/videos
    width INTEGER CHECK (width > 0),
    height INTEGER CHECK (height > 0),
    
    -- Metadatos
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_main BOOLEAN DEFAULT false, -- Imagen principal del producto
    is_active BOOLEAN DEFAULT true,
    orden INTEGER DEFAULT 0, -- Para ordenar las imágenes
    descripcion TEXT,
    alt_text VARCHAR(255), -- Texto alternativo para accesibilidad
    metadata JSONB -- Información adicional en formato JSON
);

-- =====================================
-- CREAR ÍNDICES PARA OPTIMIZACIÓN
-- =====================================

-- Índices para tabla Producto
CREATE INDEX IF NOT EXISTS idx_producto_categoria ON "Producto"(categoria_id);
CREATE INDEX IF NOT EXISTS idx_producto_marca ON "Producto"(marca_id);
CREATE INDEX IF NOT EXISTS idx_producto_status ON "Producto"(status);
CREATE INDEX IF NOT EXISTS idx_producto_available ON "Producto"(is_available);
CREATE INDEX IF NOT EXISTS idx_producto_slug ON "Producto"(slug);
CREATE INDEX IF NOT EXISTS idx_producto_name ON "Producto"(name);
CREATE INDEX IF NOT EXISTS idx_producto_price ON "Producto"(price);
CREATE INDEX IF NOT EXISTS idx_producto_created_at ON "Producto"(created_at);

-- Índice compuesto para búsquedas frecuentes
CREATE INDEX IF NOT EXISTS idx_producto_categoria_status_available 
    ON "Producto"(categoria_id, status, is_available);

-- Índices para tabla ProductoAtributos
CREATE INDEX IF NOT EXISTS idx_producto_atributos_product_id ON "ProductoAtributos"(product_id);
CREATE INDEX IF NOT EXISTS idx_producto_atributos_nombre ON "ProductoAtributos"(nombre);
CREATE INDEX IF NOT EXISTS idx_producto_atributos_valor ON "ProductoAtributos"(valor);

-- Índice compuesto para búsquedas por atributo específico
CREATE INDEX IF NOT EXISTS idx_producto_atributos_nombre_valor 
    ON "ProductoAtributos"(nombre, valor);

-- Índices para tabla ProductoMedias
CREATE INDEX IF NOT EXISTS idx_producto_medias_product_id ON "ProductoMedias"(product_id);
CREATE INDEX IF NOT EXISTS idx_producto_medias_type ON "ProductoMedias"(type);
CREATE INDEX IF NOT EXISTS idx_producto_medias_main ON "ProductoMedias"(is_main);
CREATE INDEX IF NOT EXISTS idx_producto_medias_active ON "ProductoMedias"(is_active);
CREATE INDEX IF NOT EXISTS idx_producto_medias_orden ON "ProductoMedias"(orden);

-- =====================================
-- CONFIGURAR ROW LEVEL SECURITY (RLS)
-- =====================================

-- Habilitar RLS en todas las tablas
ALTER TABLE "Producto" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "ProductoAtributos" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "ProductoMedias" ENABLE ROW LEVEL SECURITY;

-- Políticas para tabla Producto
-- Permitir lectura de productos publicados y disponibles a todos los usuarios autenticados
CREATE POLICY "Allow read published products" ON "Producto"
    FOR SELECT TO authenticated
    USING (status = 'publicado' AND is_available = true);

-- Permitir lectura completa a administradores (implementar según sistema de roles)
CREATE POLICY "Allow full read for admins" ON "Producto"
    FOR SELECT TO authenticated
    USING (true); -- Aquí deberías agregar lógica para verificar si el usuario es admin

-- Permitir CRUD completo a administradores
CREATE POLICY "Allow insert for authenticated users" ON "Producto"
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for authenticated users" ON "Producto"
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete for authenticated users" ON "Producto"
    FOR DELETE TO authenticated
    USING (true);

-- Políticas para tabla ProductoAtributos
CREATE POLICY "Allow read producto atributos" ON "ProductoAtributos"
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM "Producto" p 
            WHERE p.id = product_id 
            AND p.status = 'publicado' 
            AND p.is_available = true
        )
    );

CREATE POLICY "Allow insert producto atributos" ON "ProductoAtributos"
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update producto atributos" ON "ProductoAtributos"
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete producto atributos" ON "ProductoAtributos"
    FOR DELETE TO authenticated
    USING (true);

-- Políticas para tabla ProductoMedias
CREATE POLICY "Allow read producto medias" ON "ProductoMedias"
    FOR SELECT TO authenticated
    USING (
        is_active = true AND EXISTS (
            SELECT 1 FROM "Producto" p 
            WHERE p.id = product_id 
            AND p.status = 'publicado' 
            AND p.is_available = true
        )
    );

CREATE POLICY "Allow insert producto medias" ON "ProductoMedias"
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update producto medias" ON "ProductoMedias"
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete producto medias" ON "ProductoMedias"
    FOR DELETE TO authenticated
    USING (true);

-- =====================================
-- CREAR FUNCIONES Y TRIGGERS
-- =====================================

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para actualizar updated_at
CREATE TRIGGER update_producto_updated_at 
    BEFORE UPDATE ON "Producto" 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_producto_medias_updated_at 
    BEFORE UPDATE ON "ProductoMedias" 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Función para validar que solo una imagen sea principal por producto
CREATE OR REPLACE FUNCTION validate_single_main_image()
RETURNS TRIGGER AS $$
BEGIN
    -- Si se está marcando como imagen principal
    IF NEW.is_main = true THEN
        -- Desmarcar todas las otras imágenes del mismo producto como no principales
        UPDATE "ProductoMedias" 
        SET is_main = false 
        WHERE product_id = NEW.product_id 
        AND id != NEW.id 
        AND is_main = true;
    END IF;
    
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para validar imagen principal única
CREATE TRIGGER validate_single_main_image_trigger
    BEFORE INSERT OR UPDATE ON "ProductoMedias"
    FOR EACH ROW EXECUTE FUNCTION validate_single_main_image();

-- =====================================
-- CREAR VISTAS ÚTILES
-- =====================================

-- Vista para productos con información completa
CREATE OR REPLACE VIEW "ProductoCompleto" AS
SELECT 
    p.*,
    -- Contar total de imágenes
    COALESCE(media_count.total_images, 0) as total_images,
    -- URL de imagen principal
    main_image.url as imagen_principal_url,
    -- Información de categoría
    c.name as categoria_name,
    c.slug as categoria_slug
FROM "Producto" p
LEFT JOIN "Category" c ON p.categoria_id = c.category_id
LEFT JOIN (
    SELECT 
        product_id, 
        COUNT(*) as total_images 
    FROM "ProductoMedias" 
    WHERE is_active = true 
    GROUP BY product_id
) media_count ON p.id = media_count.product_id
LEFT JOIN (
    SELECT 
        product_id, 
        url 
    FROM "ProductoMedias" 
    WHERE is_main = true 
    AND is_active = true
) main_image ON p.id = main_image.product_id;

-- Vista para productos publicados y disponibles (para frontend público)
CREATE OR REPLACE VIEW "ProductoPublico" AS
SELECT * FROM "ProductoCompleto"
WHERE status = 'publicado' AND is_available = true;

-- =====================================
-- INSERTAR DATOS DE EJEMPLO
-- =====================================

-- Insertar algunos productos de ejemplo (requiere que existan categorías)
-- Nota: Estos INSERT dependen de que la tabla Category ya tenga datos

-- Obtener algunos IDs de categorías para los ejemplos
DO $$
DECLARE
    categoria_ropa_id UUID;
    categoria_electronics_id UUID;
    categoria_hogar_id UUID;
    
    producto1_id UUID;
    producto2_id UUID;
    producto3_id UUID;
BEGIN
    -- Obtener IDs de categorías (ajustar según las categorías que tengas)
    SELECT category_id INTO categoria_ropa_id FROM "Category" WHERE slug = 'ropa-moda' LIMIT 1;
    SELECT category_id INTO categoria_electronics_id FROM "Category" WHERE slug = 'electronica-tecnologia' LIMIT 1;
    SELECT category_id INTO categoria_hogar_id FROM "Category" WHERE slug = 'muebles-hogar' LIMIT 1;
    
    -- Solo insertar si encontramos las categorías
    IF categoria_ropa_id IS NOT NULL THEN
        -- Producto 1: Camiseta
        INSERT INTO "Producto" (id, name, slug, description, price, categoria_id, status, is_available)
        VALUES (
            gen_random_uuid(),
            'Camiseta Básica Cotton',
            'camiseta-basica-cotton',
            'Camiseta básica de algodón 100%, cómoda y versátil para uso diario. Disponible en varios colores.',
            45.50,
            categoria_ropa_id,
            'publicado',
            true
        ) RETURNING id INTO producto1_id;
        
        -- Agregar atributos al producto 1
        INSERT INTO "ProductoAtributos" (product_id, nombre, valor) VALUES
        (producto1_id, 'Talla', 'M'),
        (producto1_id, 'Color', 'Azul'),
        (producto1_id, 'Material', 'Algodón 100%'),
        (producto1_id, 'Cuidado', 'Lavado a máquina');
        
        -- Agregar imágenes al producto 1
        INSERT INTO "ProductoMedias" (product_id, type, url, is_main, orden, alt_text) VALUES
        (producto1_id, 'image', 'https://example.com/camiseta-azul-frente.jpg', true, 1, 'Camiseta azul vista frontal'),
        (producto1_id, 'image', 'https://example.com/camiseta-azul-espalda.jpg', false, 2, 'Camiseta azul vista posterior');
    END IF;
    
    IF categoria_electronics_id IS NOT NULL THEN
        -- Producto 2: Smartphone
        INSERT INTO "Producto" (id, name, slug, description, price, discounted_price, accept_offers, categoria_id, status, is_available)
        VALUES (
            gen_random_uuid(),
            'Smartphone Galaxy Pro Max',
            'smartphone-galaxy-pro-max',
            'Smartphone de última generación con cámara de 108MP, pantalla AMOLED de 6.7" y batería de larga duración.',
            899.99,
            749.99,
            true,
            categoria_electronics_id,
            'publicado',
            true
        ) RETURNING id INTO producto2_id;
        
        -- Agregar atributos al producto 2
        INSERT INTO "ProductoAtributos" (product_id, nombre, valor) VALUES
        (producto2_id, 'Pantalla', '6.7" AMOLED'),
        (producto2_id, 'Cámara', '108MP'),
        (producto2_id, 'Almacenamiento', '256GB'),
        (producto2_id, 'RAM', '8GB'),
        (producto2_id, 'Color', 'Negro Espacial');
        
        -- Agregar imágenes al producto 2
        INSERT INTO "ProductoMedias" (product_id, type, url, is_main, orden, alt_text) VALUES
        (producto2_id, 'image', 'https://example.com/smartphone-frontal.jpg', true, 1, 'Smartphone vista frontal'),
        (producto2_id, 'image', 'https://example.com/smartphone-posterior.jpg', false, 2, 'Smartphone vista posterior'),
        (producto2_id, 'image', 'https://example.com/smartphone-lateral.jpg', false, 3, 'Smartphone vista lateral');
    END IF;
    
    IF categoria_hogar_id IS NOT NULL THEN
        -- Producto 3: Mesa de comedor
        INSERT INTO "Producto" (id, name, slug, description, price, categoria_id, status, is_available)
        VALUES (
            gen_random_uuid(),
            'Mesa de Comedor Roble',
            'mesa-comedor-roble',
            'Mesa de comedor de madera de roble macizo para 6 personas. Diseño moderno y elegante.',
            1250.00,
            categoria_hogar_id,
            'publicado',
            true
        ) RETURNING id INTO producto3_id;
        
        -- Agregar atributos al producto 3
        INSERT INTO "ProductoAtributos" (product_id, nombre, valor) VALUES
        (producto3_id, 'Material', 'Roble macizo'),
        (producto3_id, 'Dimensiones', '180cm x 90cm x 75cm'),
        (producto3_id, 'Capacidad', '6 personas'),
        (producto3_id, 'Acabado', 'Barniz natural'),
        (producto3_id, 'Peso', '45kg');
        
        -- Agregar imágenes al producto 3
        INSERT INTO "ProductoMedias" (product_id, type, url, is_main, orden, alt_text) VALUES
        (producto3_id, 'image', 'https://example.com/mesa-comedor-principal.jpg', true, 1, 'Mesa de comedor roble'),
        (producto3_id, 'image', 'https://example.com/mesa-comedor-detalle.jpg', false, 2, 'Detalle de la madera'),
        (producto3_id, 'image', 'https://example.com/mesa-comedor-ambiente.jpg', false, 3, 'Mesa en ambiente');
    END IF;
    
END $$;

-- =====================================
-- COMENTARIOS Y DOCUMENTACIÓN
-- =====================================

COMMENT ON TABLE "Producto" IS 'Tabla principal de productos del marketplace';
COMMENT ON TABLE "ProductoAtributos" IS 'Atributos personalizados de productos (talla, color, material, etc.)';
COMMENT ON TABLE "ProductoMedias" IS 'Imágenes y videos asociados a productos';

COMMENT ON COLUMN "Producto".status IS 'Estado del producto: borrador, publicado, archivado';
COMMENT ON COLUMN "Producto".accept_offers IS 'Indica si el producto acepta ofertas de los compradores';
COMMENT ON COLUMN "ProductoMedias".is_main IS 'Indica si es la imagen principal del producto (solo una por producto)';
COMMENT ON COLUMN "ProductoMedias".metadata IS 'Información adicional en formato JSON (EXIF, etc.)';

-- =====================================
-- SCRIPT COMPLETADO
-- =====================================

-- Este script configura:
-- ✅ Tablas principales (Producto, ProductoAtributos, ProductoMedias)
-- ✅ Índices optimizados para consultas frecuentes
-- ✅ Políticas RLS para seguridad
-- ✅ Triggers automáticos (updated_at, imagen principal única)
-- ✅ Vistas útiles para consultas complejas
-- ✅ Datos de ejemplo para testing
-- ✅ Documentación y comentarios

-- Para usar este script:
-- 1. Asegúrate de que la tabla Category ya existe y tiene datos
-- 2. Ejecuta este script en tu instancia de Supabase
-- 3. Ajusta las políticas RLS según tu sistema de autenticación
-- 4. Modifica los datos de ejemplo según tus necesidades
