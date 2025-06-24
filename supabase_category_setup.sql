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

-- Insertar categorías principales basadas en el listado de rubros de La Feria
INSERT INTO "Category" (name, slug, description, icon, color) VALUES
-- Autopartes y Vehículos
('Autopartes y Vehículos', 'autopartes-vehiculos', 'Vehículos, repuestos, autopartes y herramientas mecánicas', 'car', '#0277BD'),
-- Ropa y Moda  
('Ropa y Moda', 'ropa-moda', 'Ropa nueva, usada, fardos y vestimenta tradicional', 'tshirt', '#E91E63'),
-- Calzado
('Calzado', 'calzado', 'Zapatos, botas, sandalias y calzado especializado', 'shoe', '#795548'),
-- Electrónica y Tecnología
('Electrónica y Tecnología', 'electronica-tecnologia', 'Dispositivos electrónicos, computadoras y accesorios tecnológicos', 'mobile', '#2196F3'),
-- Electrodomésticos
('Electrodomésticos', 'electrodomesticos', 'Hornos, neveras, televisores y electrodomésticos del hogar', 'kitchen', '#FF9800'),
-- Muebles y Hogar
('Muebles y Hogar', 'muebles-hogar', 'Muebles nuevos, usados, decoración e iluminación', 'home', '#6D4C41'),
-- Comida y Bebidas
('Comida y Bebidas', 'comida-bebidas', 'Comida tradicional, productos frescos y bebidas', 'restaurant', '#FF9800'),
-- Salud y Belleza
('Salud y Belleza', 'salud-belleza', 'Productos de belleza, cuidado personal y medicina natural', 'beauty', '#009688'),
-- Deportes y Fitness
('Deportes y Fitness', 'deportes-fitness', 'Artículos deportivos, bicicletas y equipos de camping', 'dumbbell', '#FF5722'),
-- Mascotas y Animales
('Mascotas y Animales', 'mascotas-animales', 'Mascotas domésticas, animales de cría y accesorios', 'paw', '#4CAF50'),
-- Libros y Educación
('Libros y Educación', 'libros-educacion', 'Libros, revistas, tesis y material educativo', 'book', '#3F51B5'),
-- Música e Instrumentos
('Música e Instrumentos', 'musica-instrumentos', 'Instrumentos musicales y accesorios musicales', 'guitar', '#8E24AA'),
-- Juguetes y Entretenimiento
('Juguetes y Entretenimiento', 'juguetes-entretenimiento', 'Juguetes para niños, juegos de mesa y coleccionables', 'toy_horse', '#FDD835'),
-- Joyería y Accesorios
('Joyería y Accesorios', 'joyeria-accesorios', 'Joyería fina, de fantasía y relojes', 'gem', '#9C27B0'),
-- Herramientas y Construcción
('Herramientas y Construcción', 'herramientas-construccion', 'Herramientas, materiales de construcción y cerrajería', 'hammer', '#455A64'),
-- Jardín y Agricultura
('Jardín y Agricultura', 'jardin-agricultura', 'Plantas, semillas, herramientas de jardín y productos agrícolas', 'seedling', '#388E3C'),
-- Artesanías y Manualidades
('Artesanías y Manualidades', 'artesanias-manualidades', 'Textiles artesanales, arte y manualidades', 'paint_brush', '#FF5722'),
-- Servicios Profesionales
('Servicios Profesionales', 'servicios-profesionales', 'Servicios de reparación, consultoría y profesionales', 'business', '#546E7A'),
-- Oficina y Papelería
('Oficina y Papelería', 'oficina-papeleria', 'Artículos de oficina, papelería y equipos', 'briefcase', '#607D8B'),
-- Otros y Varios
('Otros y Varios', 'otros-varios', 'Productos diversos que no encajan en otras categorías', 'category', '#9E9E9E')
ON CONFLICT (name) DO NOTHING;

-- Obtener los IDs de las categorías principales para crear subcategorías
DO $$
DECLARE
    autopartes_id UUID;
    ropa_id UUID;
    calzado_id UUID;
    electronica_id UUID;
    electrodomesticos_id UUID;
    muebles_id UUID;
    comida_id UUID;
    salud_id UUID;
    deportes_id UUID;
    mascotas_id UUID;
    libros_id UUID;
    musica_id UUID;
    juguetes_id UUID;
    joyeria_id UUID;
    herramientas_id UUID;
    jardin_id UUID;
    artesanias_id UUID;
    servicios_id UUID;
    oficina_id UUID;
    otros_id UUID;
BEGIN
    -- Obtener IDs de categorías principales
    SELECT category_id INTO autopartes_id FROM "Category" WHERE slug = 'autopartes-vehiculos';
    SELECT category_id INTO ropa_id FROM "Category" WHERE slug = 'ropa-moda';
    SELECT category_id INTO calzado_id FROM "Category" WHERE slug = 'calzado';
    SELECT category_id INTO electronica_id FROM "Category" WHERE slug = 'electronica-tecnologia';
    SELECT category_id INTO electrodomesticos_id FROM "Category" WHERE slug = 'electrodomesticos';
    SELECT category_id INTO muebles_id FROM "Category" WHERE slug = 'muebles-hogar';
    SELECT category_id INTO comida_id FROM "Category" WHERE slug = 'comida-bebidas';
    SELECT category_id INTO salud_id FROM "Category" WHERE slug = 'salud-belleza';
    SELECT category_id INTO deportes_id FROM "Category" WHERE slug = 'deportes-fitness';
    SELECT category_id INTO mascotas_id FROM "Category" WHERE slug = 'mascotas-animales';
    SELECT category_id INTO libros_id FROM "Category" WHERE slug = 'libros-educacion';
    SELECT category_id INTO musica_id FROM "Category" WHERE slug = 'musica-instrumentos';
    SELECT category_id INTO juguetes_id FROM "Category" WHERE slug = 'juguetes-entretenimiento';
    SELECT category_id INTO joyeria_id FROM "Category" WHERE slug = 'joyeria-accesorios';
    SELECT category_id INTO herramientas_id FROM "Category" WHERE slug = 'herramientas-construccion';
    SELECT category_id INTO jardin_id FROM "Category" WHERE slug = 'jardin-agricultura';
    SELECT category_id INTO artesanias_id FROM "Category" WHERE slug = 'artesanias-manualidades';
    SELECT category_id INTO servicios_id FROM "Category" WHERE slug = 'servicios-profesionales';
    SELECT category_id INTO oficina_id FROM "Category" WHERE slug = 'oficina-papeleria';
    SELECT category_id INTO otros_id FROM "Category" WHERE slug = 'otros-varios';

    -- AUTOPARTES Y VEHÍCULOS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Autos', 'autos', 'Automóviles nuevos y usados', 'car', '#0277BD'),
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Motocicletas', 'motocicletas', 'Motocicletas y scooters', 'motorcycle', '#F44336'),
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Camiones', 'camiones', 'Camiones y vehículos comerciales', 'truck', '#FF9800'),
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Repuestos Nuevos', 'repuestos-nuevos', 'Autopartes y repuestos nuevos', 'tools', '#4CAF50'),
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Repuestos Usados', 'repuestos-usados', 'Autopartes y repuestos usados', 'wrench', '#9E9E9E'),
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Baterías', 'baterias', 'Baterías para vehículos', 'battery', '#FF5722'),
    ('c81793df-6673-46a5-91c5-16133d4f8f5a', 'Llantas', 'llantas', 'Neumáticos y llantas', 'tire', '#795548');

    -- ROPA Y MODA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Ropa Americana', 'ropa-americana', 'Ropa usada importada de USA', 'tshirt', '#2196F3'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Fardos de USA', 'fardos-usa', 'Fardos de ropa americana', 'shopping_bag', '#FF9800'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Fardos de China', 'fardos-china', 'Fardos de ropa china', 'shopping_cart', '#F44336'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Ropa Nueva', 'ropa-nueva', 'Ropa nueva nacional e importada', 'dress', '#4CAF50'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Chamarras', 'chamarras', 'Chaquetas y abrigos', 'male_clothes', '#795548'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Jeans', 'jeans', 'Pantalones de mezclilla', 'tshirt', '#1976D2'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Vestidos', 'vestidos', 'Vestidos casuales y formales', 'dress', '#E91E63'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Vestidos de Novia', 'vestidos-novia', 'Vestidos de novia y eventos especiales', 'crown', '#FFEB3B'),
    ('c58b87b3-3f80-4ef6-8218-a4efd5298e61', 'Ropa de Cholita', 'ropa-cholita', 'Vestimenta tradicional boliviana', 'female', '#FF5722');

    -- CALZADO
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Zapatos de Hombre', 'zapatos-hombre', 'Calzado masculino formal y casual', 'shoe', '#2196F3'),
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Zapatos de Mujer', 'zapatos-mujer', 'Calzado femenino y de tacón', 'running_shoe', '#E91E63'),
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Zapatos de Niños', 'zapatos-ninos', 'Calzado infantil', 'baby_clothes', '#FF9800'),
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Zapatos Americanos', 'zapatos-americanos', 'Calzado usado importado', 'shoe', '#9E9E9E'),
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Botas', 'botas', 'Botas de trabajo y fashion', 'hiking_boot', '#795548'),
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Sandalias', 'sandalias', 'Sandalias y chanclas', 'shoe', '#FF5722'),
    ('07768f77-efb5-4315-9604-d7d9cd04c707', 'Zapatos Deportivos', 'zapatos-deportivos', 'Calzado deportivo y running', 'running_shoe', '#4CAF50');

    -- ELECTRÓNICA Y TECNOLOGÍA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('029d02f9-f500-4f28-a552-2cc2989b1845', 'Cámaras Fotográficas', 'camaras-fotograficas', 'Cámaras digitales y análogas', 'camera', '#FF9800'),
    ('029d02f9-f500-4f28-a552-2cc2989b1845', 'Discos Duros', 'discos-duros', 'Almacenamiento y memorias', 'usb', '#607D8B'),
    ('029d02f9-f500-4f28-a552-2cc2989b1845', 'CD/DVD', 'cd-dvd', 'Discos y medios físicos', 'microphone', '#FF5722');

    -- COMIDA Y BEBIDAS  
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Charquecán', 'charquecan', 'Plato tradicional de charque', 'meat', '#D32F2F'),
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Churrascos', 'churrascos', 'Carne a la parrilla', 'hamburger', '#8D6E63'),
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Llauchas', 'llauchas', 'Pan tradicional boliviano', 'bread', '#FFC107'),
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Api', 'api', 'Bebida tradicional de maíz morado', 'coffee', '#673AB7'),
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Salchipapas', 'salchipapas', 'Comida rápida popular', 'hamburger', '#FF5722'),
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Tortas', 'tortas', 'Pasteles y tortas', 'cake', '#E91E63'),
    ('d1be5889-3fd9-4430-b5e7-48a381914869', 'Abarrotes', 'abarrotes', 'Productos de despensa', 'grocery', '#4CAF50');

    SALUD Y BELLEZA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('7c37ca76-da61-460f-bf71-9b57fd9d6071', 'Productos de Belleza', 'productos-belleza', 'Maquillaje, cremas, perfumes', 'beauty', '#E91E63'),
    ('7c37ca76-da61-460f-bf71-9b57fd9d6071', 'Cuidado Personal', 'cuidado-personal', 'Champús, jabones, desodorantes', 'hygiene', '#26A69A'),
    ('7c37ca76-da61-460f-bf71-9b57fd9d6071', 'Medicina Natural', 'medicina-natural', 'Hierbas medicinales, remedios naturales', 'spa', '#4CAF50'),
    ('7c37ca76-da61-460f-bf71-9b57fd9d6071', 'Farmacia', 'farmacia', 'Medicamentos y productos farmacéuticos', 'pharmacy', '#009688'),
    ('7c37ca76-da61-460f-bf71-9b57fd9d6071', 'Equipos Médicos', 'equipos-medicos', 'Termómetros, tensiómetros, nebulizadores', 'medical', '#0277BD');

    -- DEPORTES Y FITNESS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('2cc32562-9f03-4f66-8226-eaf40dccd6d6', 'Equipos de Gimnasio', 'equipos-gimnasio', 'Pesas, máquinas, accesorios fitness', 'dumbbell', '#FF5722'),
    ('2cc32562-9f03-4f66-8226-eaf40dccd6d6', 'Deportes de Pelota', 'deportes-pelota', 'Fútbol, básquet, vóley, tenis', 'football', '#4CAF50'),
    ('2cc32562-9f03-4f66-8226-eaf40dccd6d6', 'Bicicletas y Ciclismo', 'bicicletas-ciclismo', 'Bicicletas, repuestos, accesorios', 'bicycle', '#2196F3'),
    ('2cc32562-9f03-4f66-8226-eaf40dccd6d6', 'Deportes Acuáticos', 'deportes-acuaticos', 'Natación, surf, deportes de agua', 'swimming', '#00BCD4'),
    ('2cc32562-9f03-4f66-8226-eaf40dccd6d6', 'Camping y Outdoor', 'camping-outdoor', 'Carpas, sleeping, equipos de montaña', 'skiing', '#795548'),
    ('2cc32562-9f03-4f66-8226-eaf40dccd6d6', 'Ropa Deportiva', 'ropa-deportiva', 'Indumentaria para hacer deporte', 'running_shoe', '#FF9800');

    -- MASCOTAS Y ANIMALES
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Perros', 'perros', 'Cachorros, perros adultos y accesorios caninos', 'dog', '#FF9800'),
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Gatos', 'gatos', 'Gatitos, gatos y productos felinos', 'cat', '#607D8B'),
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Aves Domésticas', 'aves-domesticas', 'Pájaros, loros, canarios y jaulas', 'paw', '#FFC107'),
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Peces y Acuarios', 'peces-acuarios', 'Peces ornamentales y equipos de acuario', 'fish', '#00BCD4'),
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Animales de Granja', 'animales-granja', 'Conejos, gallinas, cerdos, vacas', 'paw', '#8BC34A'),
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Alimentos para Mascotas', 'alimentos-mascotas', 'Comida, snacks y suplementos', 'bone', '#4CAF50'),
    ('ed046a06-8be6-4476-b5ad-51f24b886949', 'Accesorios y Juguetes', 'accesorios-juguetes-mascotas', 'Correas, camas, juguetes para mascotas', 'paw', '#9C27B0');

    -- LIBROS Y EDUCACIÓN
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('362a76a3-d16e-47db-bafc-c764b3f91e55', 'Libros Escolares', 'libros-escolares', 'Textos de primaria, secundaria y preparatoria', 'book', '#2196F3'),
    ('362a76a3-d16e-47db-bafc-c764b3f91e55', 'Libros Universitarios', 'libros-universitarios', 'Textos técnicos, tesis y material académico', 'graduation', '#673AB7'),
    ('362a76a3-d16e-47db-bafc-c764b3f91e55', 'Literatura y Novelas', 'literatura-novelas', 'Ficción, poesía, cuentos y novelas', 'library', '#795548'),
    ('362a76a3-d16e-47db-bafc-c764b3f91e55', 'Revistas y Periódicos', 'revistas-periodicos', 'Publicaciones periódicas y especializadas', 'book', '#607D8B'),
    ('362a76a3-d16e-47db-bafc-c764b3f91e55', 'Libros Técnicos', 'libros-tecnicos', 'Manuales, guías técnicas y especializadas', 'tools', '#FF5722'),
    ('362a76a3-d16e-47db-bafc-c764b3f91e55', 'Material Didáctico', 'material-didactico', 'Juegos educativos, material para enseñanza', 'puzzle', '#FF9800');

    -- MÚSICA E INSTRUMENTOS  
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('c6a7b0c8-dde4-4920-b2bf-61fa62e035f4', 'Instrumentos de Cuerda', 'instrumentos-cuerda', 'Guitarras, violines, charangos, mandolinas', 'guitar', '#8E24AA'),
    ('c6a7b0c8-dde4-4920-b2bf-61fa62e035f4', 'Instrumentos de Viento', 'instrumentos-viento', 'Flautas, zampoñas, trompetas, saxofones', 'microphone', '#FF5722'),
    ('c6a7b0c8-dde4-4920-b2bf-61fa62e035f4', 'Instrumentos de Percusión', 'instrumentos-percusion', 'Bombos, tambores, timbales, maracas', 'drum', '#FF9800'),
    ('c6a7b0c8-dde4-4920-b2bf-61fa62e035f4', 'Instrumentos Tradicionales', 'instrumentos-tradicionales', 'Charango, quena, sikus, instrumentos autóctonos', 'guitar', '#795548'),
    ('c6a7b0c8-dde4-4920-b2bf-61fa62e035f4', 'Equipos de Audio', 'equipos-audio', 'Amplificadores, micrófonos, mezcladores', 'music', '#2196F3'),
    ('c6a7b0c8-dde4-4920-b2bf-61fa62e035f4', 'Discos y Música', 'discos-musica', 'CDs, vinilos, música digital, folklore', 'music', '#424242');

    -- JUGUETES Y ENTRETENIMIENTO
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('21584740-72c7-473d-b5ef-bc4fbed97748', 'Juguetes para Bebés', 'juguetes-bebes', 'Sonajeros, peluches, juguetes didácticos', 'baby_clothes', '#FFB74D'),
    ('21584740-72c7-473d-b5ef-bc4fbed97748', 'Muñecas y Figuras', 'munecas-figuras', 'Muñecas, figuras de acción, coleccionables', 'dress', '#E91E63'),
    ('21584740-72c7-473d-b5ef-bc4fbed97748', 'Juegos de Mesa', 'juegos-mesa', 'Ajedrez, monopoly, cartas, juegos familiares', 'puzzle', '#9C27B0'),
    ('21584740-72c7-473d-b5ef-bc4fbed97748', 'Juguetes Educativos', 'juguetes-educativos', 'Rompecabezas, bloques, juegos STEM', 'graduation', '#4CAF50'),
    ('21584740-72c7-473d-b5ef-bc4fbed97748', 'Vehículos de Juguete', 'vehiculos-juguete', 'Autos, camiones, aviones en miniatura', 'car', '#2196F3'),
    ('21584740-72c7-473d-b5ef-bc4fbed97748', 'Peluches', 'peluches', 'Animales de peluche y muñecos suaves', 'cat', '#FF8A65');

    -- JOYERÍA Y ACCESORIOS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('9b191912-7b17-47a9-9aa0-70b64b1ea2b5', 'Joyería Fina', 'joyeria-fina', 'Oro, plata, piedras preciosas', 'gem', '#FFD700'),
    ('9b191912-7b17-47a9-9aa0-70b64b1ea2b5', 'Joyería de Fantasía', 'joyeria-fantasia', 'Bisutería, accesorios económicos', 'gem', '#E91E63'),
    ('9b191912-7b17-47a9-9aa0-70b64b1ea2b5', 'Relojes', 'relojes', 'Relojes de pulsera, de pared, despertadores', 'smartwatch', '#424242'),
    ('9b191912-7b17-47a9-9aa0-70b64b1ea2b5', 'Accesorios para el Cabello', 'accesorios-cabello', 'Vinchas, clips, lazos, diademas', 'hat', '#FF9800'),
    ('9b191912-7b17-47a9-9aa0-70b64b1ea2b5', 'Bolsos y Carteras', 'bolsos-carteras', 'Mochilas, bolsos, billeteras', 'shopping_bag', '#795548'),
    ('9b191912-7b17-47a9-9aa0-70b64b1ea2b5', 'Cinturones y Correas', 'cinturones-correas', 'Cinturones de cuero, tela, decorativos', 'hat', '#6D4C41');

    -- HERRAMIENTAS Y CONSTRUCCIÓN
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('9c15bbf0-a078-4f3e-8094-c5303cd18955', 'Herramientas Manuales', 'herramientas-manuales', 'Martillos, destornilladores, llaves', 'hammer', '#607D8B'),
    ('9c15bbf0-a078-4f3e-8094-c5303cd18955', 'Herramientas Eléctricas', 'herramientas-electricas', 'Taladros, sierras, pulidoras', 'tools', '#FF5722'),
    ('9c15bbf0-a078-4f3e-8094-c5303cd18955', 'Materiales de Construcción', 'materiales-construccion', 'Cemento, ladrillos, fierros, maderas', 'tools', '#795548'),
    ('9c15bbf0-a078-4f3e-8094-c5303cd18955', 'Cerrajería y Seguridad', 'cerrajeria-seguridad', 'Cerraduras, candados, llaves', 'key', '#424242'),
    ('9c15bbf0-a078-4f3e-8094-c5303cd18955', 'Pintura y Acabados', 'pintura-acabados', 'Pinturas, brochas, rodillos, barnices', 'paint_brush', '#4CAF50'),
    ('9c15bbf0-a078-4f3e-8094-c5303cd18955', 'Plomería y Electricidad', 'plomeria-electricidad', 'Tubos, cables, interruptores, griferías', 'tools', '#2196F3');

    -- JARDÍN Y AGRICULTURA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('5f90f68d-b349-4f9c-b1b7-2516d8c88426', 'Plantas y Flores', 'plantas-flores', 'Plantas ornamentales, flores, árboles', 'leaf', '#4CAF50'),
    ('5f90f68d-b349-4f9c-b1b7-2516d8c88426', 'Semillas y Plantines', 'semillas-plantines', 'Semillas de hortalizas, flores, césped', 'seedling', '#8BC34A'),
    ('5f90f68d-b349-4f9c-b1b7-2516d8c88426', 'Herramientas de Jardín', 'herramientas-jardin', 'Palas, rastrillos, tijeras de podar', 'tools', '#795548'),
    ('5f90f68d-b349-4f9c-b1b7-2516d8c88426', 'Fertilizantes y Abonos', 'fertilizantes-abonos', 'Abonos orgánicos, fertilizantes químicos', 'leaf', '#FF9800'),
    ('5f90f68d-b349-4f9c-b1b7-2516d8c88426', 'Productos Agrícolas', 'productos-agricolas', 'Verduras, frutas, productos del campo', 'apple', '#4CAF50'),
    ('5f90f68d-b349-4f9c-b1b7-2516d8c88426', 'Equipos de Riego', 'equipos-riego', 'Mangueras, aspersores, sistemas de riego', 'tools', '#2196F3');

    -- ARTESANÍAS Y MANUALIDADES
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('95437809-6c85-49b6-ad66-3f268eeb8825', 'Textiles Artesanales', 'textiles-artesanales', 'Aguayos, manteles, tapices tejidos', 'tshirt', '#FF5722'),
    ('95437809-6c85-49b6-ad66-3f268eeb8825', 'Cerámica y Alfarería', 'ceramica-alfareria', 'Vasijas, platos, objetos de barro', 'palette', '#795548'),
    ('95437809-6c85-49b6-ad66-3f268eeb8825', 'Trabajos en Madera', 'trabajos-madera', 'Tallados, muebles rústicos, artesanías', 'chair', '#8D6E63'),
    ('95437809-6c85-49b6-ad66-3f268eeb8825', 'Arte y Pintura', 'arte-pintura', 'Cuadros, esculturas, obras de arte', 'paint_brush', '#9C27B0'),
    ('95437809-6c85-49b6-ad66-3f268eeb8825', 'Materiales para Manualidades', 'materiales-manualidades', 'Hilos, lanas, papeles, pegamentos', 'palette', '#FF9800'),
    ('95437809-6c85-49b6-ad66-3f268eeb8825', 'Joyería Artesanal', 'joyeria-artesanal', 'Collares, pulseras, aretes hechos a mano', 'gem', '#E91E63');

    -- SERVICIOS PROFESIONALES
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('cbc745dd-cb5e-4d77-8fd4-bdd96b5b5c22', 'Reparaciones Técnicas', 'reparaciones-tecnicas', 'Servicio de reparación de electrodomésticos', 'tools', '#FF5722'),
    ('cbc745dd-cb5e-4d77-8fd4-bdd96b5b5c22', 'Servicios de Construcción', 'servicios-construccion', 'Albañilería, plomería, electricidad', 'hammer', '#795548'),
    ('cbc745dd-cb5e-4d77-8fd4-bdd96b5b5c22', 'Servicios de Limpieza', 'servicios-limpieza', 'Limpieza de hogares, oficinas, alfombras', 'cleaning', '#00BCD4'),
    ('cbc745dd-cb5e-4d77-8fd4-bdd96b5b5c22', 'Servicios de Transporte', 'servicios-transporte', 'Mudanzas, fletes, taxi, delivery', 'truck', '#607D8B'),
    ('cbc745dd-cb5e-4d77-8fd4-bdd96b5b5c22', 'Servicios Educativos', 'servicios-educativos', 'Clases particulares, tutorías', 'graduation', '#2196F3'),
    ('cbc745dd-cb5e-4d77-8fd4-bdd96b5b5c22', 'Servicios de Belleza', 'servicios-belleza', 'Peluquería, manicure, tratamientos', 'beauty', '#E91E63');

    -- OFICINA Y PAPELERÍA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('525d0a15-1b7f-4737-99b8-f1d7d6cd5547', 'Papelería Básica', 'papeleria-basica', 'Cuadernos, lápices, bolígrafos, reglas', 'pen', '#FFC107'),
    ('525d0a15-1b7f-4737-99b8-f1d7d6cd5547', 'Equipos de Oficina', 'equipos-oficina', 'Impresoras, computadoras, teléfonos', 'laptop', '#607D8B'),
    ('525d0a15-1b7f-4737-99b8-f1d7d6cd5547', 'Muebles de Oficina', 'muebles-oficina', 'Escritorios, sillas, archivadores', 'chair', '#795548'),
    ('525d0a15-1b7f-4737-99b8-f1d7d6cd5547', 'Material de Archivo', 'material-archivo', 'Carpetas, folders, etiquetas', 'briefcase', '#2196F3'),
    ('525d0a15-1b7f-4737-99b8-f1d7d6cd5547', 'Suministros de Impresión', 'suministros-impresion', 'Tintas, cartuchos, papel especial', 'printer', '#424242'),
    ('525d0a15-1b7f-4737-99b8-f1d7d6cd5547', 'Accesorios de Escritorio', 'accesorios-escritorio', 'Calculadoras, grapadoras, perforadoras', 'calculator', '#FF9800');

    -- OTROS Y VARIOS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('5ddab1d8-20e0-4d1f-b18d-a8ae4e91ad30', 'Productos de Segunda Mano', 'productos-segunda-mano', 'Artículos usados en buen estado', 'eco', '#4CAF50'),
    ('5ddab1d8-20e0-4d1f-b18d-a8ae4e91ad30', 'Coleccionables', 'coleccionables', 'Monedas, estampillas, objetos antiguos', 'gem', '#9C27B0'),
    ('5ddab1d8-20e0-4d1f-b18d-a8ae4e91ad30', 'Productos Importados', 'productos-importados', 'Artículos traídos del extranjero', 'store', '#2196F3'),
    ('5ddab1d8-20e0-4d1f-b18d-a8ae4e91ad30', 'Artículos de Temporada', 'articulos-temporada', 'Decoraciones navideñas, carnaval', 'gift', '#FF9800'),
    ('5ddab1d8-20e0-4d1f-b18d-a8ae4e91ad30', 'Productos Reciclados', 'productos-reciclados', 'Artículos reutilizados y ecológicos', 'eco', '#4CAF50'),
    ('5ddab1d8-20e0-4d1f-b18d-a8ae4e91ad30', 'Misceláneos', 'miscelaneos', 'Productos que no encajan en otras categorías', 'category', '#9E9E9E');

END $$;

-- Actualizar estadísticas de la tabla para optimizar consultas
ANALYZE "Category";

-- Mensaje de confirmación
DO $$
BEGIN
    RAISE NOTICE 'Setup de categorías completado exitosamente. Total de categorías principales: %, Total de subcategorías: %', 
        (SELECT COUNT(*) FROM "Category" WHERE parent_category_id IS NULL),
        (SELECT COUNT(*) FROM "Category" WHERE parent_category_id IS NOT NULL);
END $$;
