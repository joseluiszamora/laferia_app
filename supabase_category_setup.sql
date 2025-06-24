-- Crear la tabla Category en Supabase
CREATE TABLE IF NOT EXISTS "Category" (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_category_id UUID REFERENCES "Category"(category_id) ON DELETE CASCADE,
    name VARCHAR(255) UNIQUE NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    color VARCHAR(7), -- Para colores hex #RRGGBB
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índice para optimizar búsquedas por categoría padre
CREATE INDEX IF NOT EXISTS idx_category_parent_id ON "Category"(parent_category_id);

-- Crear índice para búsquedas por nombre
CREATE INDEX IF NOT EXISTS idx_category_name ON "Category"(name);

-- Crear índice para búsquedas por slug
CREATE INDEX IF NOT EXISTS idx_category_slug ON "Category"(slug);

-- Habilitar RLS (Row Level Security)
ALTER TABLE "Category" ENABLE ROW LEVEL SECURITY;

-- Política para permitir SELECT a usuarios autenticados
CREATE POLICY "Allow read access for authenticated users" ON "Category"
    FOR SELECT TO authenticated
    USING (true);

-- Política para permitir INSERT a usuarios autenticados (solo administradores en producción)
CREATE POLICY "Allow insert for authenticated users" ON "Category"
    FOR INSERT TO authenticated
    WITH CHECK (true);

-- Política para permitir UPDATE a usuarios autenticados (solo administradores en producción)
CREATE POLICY "Allow update for authenticated users" ON "Category"
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

-- Política para permitir DELETE a usuarios autenticados (solo administradores en producción)
CREATE POLICY "Allow delete for authenticated users" ON "Category"
    FOR DELETE TO authenticated
    USING (true);

-- Insertar categorías principales de ejemplo
INSERT INTO "Category" (name, slug, description, icon, color) VALUES
('Comida y Bebidas', 'comida-bebidas', 'Productos alimenticios, bebidas y delicatessen', 'restaurant', '#FF9800'),
('Ropa y Accesorios', 'ropa-accesorios', 'Vestimenta, calzado y accesorios de moda', 'checkroom', '#9C27B0'),
('Tecnología', 'tecnologia', 'Dispositivos electrónicos, gadgets y accesorios tecnológicos', 'devices', '#2196F3'),
('Hogar y Jardín', 'hogar-jardin', 'Artículos para el hogar, decoración y jardinería', 'home', '#4CAF50'),
('Salud y Belleza', 'salud-belleza', 'Productos de cuidado personal, cosméticos y salud', 'face_retouching_natural', '#E91E63'),
('Deportes', 'deportes', 'Artículos deportivos, equipamiento y accesorios', 'sports_soccer', '#FF5722'),
('Libros y Educación', 'libros-educacion', 'Libros, material educativo y papelería', 'menu_book', '#795548'),
('Automóviles', 'automoviles', 'Vehículos, repuestos y accesorios automotrices', 'directions_car', '#607D8B'),
('Mascotas', 'mascotas', 'Productos para el cuidado y bienestar de mascotas', 'pets', '#FF9800'),
('Servicios', 'servicios', 'Servicios profesionales y especializados', 'build', '#9E9E9E')
ON CONFLICT (name) DO NOTHING;

-- Obtener los IDs de las categorías principales para crear subcategorías
DO $$
DECLARE
    comida_id UUID;
    ropa_id UUID;
    tecnologia_id UUID;
    hogar_id UUID;
    salud_id UUID;
    deportes_id UUID;
    libros_id UUID;
    auto_id UUID;
    mascotas_id UUID;
    servicios_id UUID;
BEGIN
    -- Obtener IDs de categorías principales
    SELECT category_id INTO comida_id FROM "Category" WHERE slug = 'comida-bebidas';
    SELECT category_id INTO ropa_id FROM "Category" WHERE slug = 'ropa-accesorios';
    SELECT category_id INTO tecnologia_id FROM "Category" WHERE slug = 'tecnologia';
    SELECT category_id INTO hogar_id FROM "Category" WHERE slug = 'hogar-jardin';
    SELECT category_id INTO salud_id FROM "Category" WHERE slug = 'salud-belleza';
    SELECT category_id INTO deportes_id FROM "Category" WHERE slug = 'deportes';
    SELECT category_id INTO libros_id FROM "Category" WHERE slug = 'libros-educacion';
    SELECT category_id INTO auto_id FROM "Category" WHERE slug = 'automoviles';
    SELECT category_id INTO mascotas_id FROM "Category" WHERE slug = 'mascotas';
    SELECT category_id INTO servicios_id FROM "Category" WHERE slug = 'servicios';

    -- Insertar subcategorías de Comida y Bebidas
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    (comida_id, 'Frutas y Verduras', 'frutas-verduras', 'Productos frescos del campo', 'eco', '#4CAF50'),
    (comida_id, 'Carnes y Pescados', 'carnes-pescados', 'Proteínas frescas y procesadas', 'restaurant', '#F44336'),
    (comida_id, 'Panadería', 'panaderia', 'Pan, pasteles y productos horneados', 'cake', '#FFC107'),
    (comida_id, 'Bebidas', 'bebidas', 'Refrescos, jugos y bebidas alcohólicas', 'local_bar', '#03A9F4'),
    (comida_id, 'Lácteos', 'lacteos', 'Leche, quesos y derivados lácteos', 'emoji_food_beverage', '#FFEB3B')
    ON CONFLICT (name) DO NOTHING;

    -- Insertar subcategorías de Ropa y Accesorios
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    (ropa_id, 'Ropa Masculina', 'ropa-masculina', 'Vestimenta para hombres', 'man', '#2196F3'),
    (ropa_id, 'Ropa Femenina', 'ropa-femenina', 'Vestimenta para mujeres', 'woman', '#E91E63'),
    (ropa_id, 'Ropa Infantil', 'ropa-infantil', 'Vestimenta para niños y bebés', 'child_care', '#FF9800'),
    (ropa_id, 'Calzado', 'calzado', 'Zapatos, botas y sandalias', 'shoes', '#795548'),
    (ropa_id, 'Accesorios', 'accesorios', 'Joyas, bolsos y complementos', 'diamond', '#9C27B0')
    ON CONFLICT (name) DO NOTHING;

    -- Insertar subcategorías de Tecnología
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    (tecnologia_id, 'Smartphones', 'smartphones', 'Teléfonos móviles y accesorios', 'smartphone', '#4CAF50'),
    (tecnologia_id, 'Computadoras', 'computadoras', 'PCs, laptops y componentes', 'computer', '#2196F3'),
    (tecnologia_id, 'Audio y Video', 'audio-video', 'Auriculares, parlantes y equipos multimedia', 'headphones', '#FF5722'),
    (tecnologia_id, 'Gaming', 'gaming', 'Consolas, videojuegos y accesorios', 'sports_esports', '#9C27B0'),
    (tecnologia_id, 'Fotografía', 'fotografia', 'Cámaras y equipos fotográficos', 'camera_alt', '#FF9800')
    ON CONFLICT (name) DO NOTHING;

END $$;
