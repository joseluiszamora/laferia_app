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
('Otros y Varios', 'otros-varios', 'Productos diversos que no encajan en otras categorías', 'category', '#9E9E9E'),
('Entidades Financieras', 'entidades-financieras', 'Cajeros, agencias de banco, entidades financieras', 'category', '#9E9E9E')
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
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Autos', 'autos', 'Automóviles nuevos y usados', 'car', '#0277BD'),
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Motocicletas', 'motocicletas', 'Motocicletas y scooters', 'motorcycle', '#F44336'),
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Camiones', 'camiones', 'Camiones y vehículos comerciales', 'truck', '#FF9800'),
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Repuestos Nuevos', 'repuestos-nuevos', 'Autopartes y repuestos nuevos', 'tools', '#4CAF50'),
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Repuestos Usados', 'repuestos-usados', 'Autopartes y repuestos usados', 'wrench', '#9E9E9E'),
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Baterías', 'baterias', 'Baterías para vehículos', 'battery', '#FF5722'),
    ('82e86aab-a9f5-4c9d-b42d-a6f7e0b95968', 'Llantas', 'llantas', 'Neumáticos y llantas', 'tire', '#795548');

    -- ROPA Y MODA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Ropa Americana', 'ropa-americana', 'Ropa usada importada de USA', 'tshirt', '#2196F3'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Fardos de USA', 'fardos-usa', 'Fardos de ropa americana', 'shopping_bag', '#FF9800'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Fardos de China', 'fardos-china', 'Fardos de ropa china', 'shopping_cart', '#F44336'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Ropa Nueva', 'ropa-nueva', 'Ropa nueva nacional e importada', 'dress', '#4CAF50'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Chamarras', 'chamarras', 'Chaquetas y abrigos', 'male_clothes', '#795548'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Jeans', 'jeans', 'Pantalones de mezclilla', 'tshirt', '#1976D2'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Vestidos', 'vestidos', 'Vestidos casuales y formales', 'dress', '#E91E63'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Vestidos de Novia', 'vestidos-novia', 'Vestidos de novia y eventos especiales', 'crown', '#FFEB3B'),
    ('8ea15337-5f20-48a7-a7cc-8c89bc53098d', 'Ropa de Cholita', 'ropa-cholita', 'Vestimenta tradicional boliviana', 'female', '#FF5722');

    -- CALZADO
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Zapatos de Hombre', 'zapatos-hombre', 'Calzado masculino formal y casual', 'shoe', '#2196F3'),
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Zapatos de Mujer', 'zapatos-mujer', 'Calzado femenino y de tacón', 'running_shoe', '#E91E63'),
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Zapatos de Niños', 'zapatos-ninos', 'Calzado infantil', 'baby_clothes', '#FF9800'),
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Zapatos Americanos', 'zapatos-americanos', 'Calzado usado importado', 'shoe', '#9E9E9E'),
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Botas', 'botas', 'Botas de trabajo y fashion', 'hiking_boot', '#795548'),
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Sandalias', 'sandalias', 'Sandalias y chanclas', 'shoe', '#FF5722'),
    ('d0e15c51-80a6-4ec4-a923-b3efd1040963', 'Zapatos Deportivos', 'zapatos-deportivos', 'Calzado deportivo y running', 'running_shoe', '#4CAF50');

    -- ELECTRÓNICA Y TECNOLOGÍA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('9bd3567f-397d-4b70-b0de-0ed74b096928', 'Cámaras Fotográficas', 'camaras-fotograficas', 'Cámaras digitales y análogas', 'camera', '#FF9800'),
    ('9bd3567f-397d-4b70-b0de-0ed74b096928', 'Discos Duros', 'discos-duros', 'Almacenamiento y memorias', 'usb', '#607D8B'),
    ('9bd3567f-397d-4b70-b0de-0ed74b096928', 'CD/DVD', 'cd-dvd', 'Discos y medios físicos', 'microphone', '#FF5722');

    -- COMIDA Y BEBIDAS  
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('6', 'Charquekan', 'charquekan', 'Plato tradicional de charque', 'meat', '#FF9800'),
    ('6', 'Churrascos', 'churrascos', 'Carne a la parrilla', 'hamburger', '#FF9800'),
    ('6', 'Llauchas', 'llauchas', 'Pan tradicional boliviano', 'bread', '#FF9800'),
    ('6', 'Api', 'api', 'Bebida tradicional de maíz morado', 'coffee', '#FF9800'),
    ('6', 'Salchipapas', 'salchipapas', 'Comida rápida popular', 'hamburger', '#FF9800'),
    ('6', 'Hamburguesas', 'hamburguesas', 'Comida rápida', 'hamburger', '#FF9800'),
    ('6', 'Tortas', 'tortas', 'Pasteles y tortas', 'cake', '#FF9800'),
    ('6', 'Jugos y batidos', 'jugos-y-batidos', 'Jugos saludables', 'cake', '#FF9800'),
    ('6', 'Salteñas', 'saltenas', 'salteñas', 'grocery', '#FF9800'),
    ('6', 'Chicharron tradicional', 'chicharron-tradicional', 'Plato tradicional chicharron', 'meat', '#FF9800'),
    ('6', 'Chicharron Cochabambino', 'chicharron-cochabambino', 'Plato tradicional cochabambino', 'meat', '#FF9800');

    -- SALUD Y BELLEZA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('3d84e0b8-eb1f-44fd-9f8d-5a63946bc63d', 'Productos de Belleza', 'productos-belleza', 'Maquillaje, cremas, perfumes', 'beauty', '#E91E63'),
    ('3d84e0b8-eb1f-44fd-9f8d-5a63946bc63d', 'Cuidado Personal', 'cuidado-personal', 'Champús, jabones, desodorantes', 'hygiene', '#26A69A'),
    ('3d84e0b8-eb1f-44fd-9f8d-5a63946bc63d', 'Medicina Natural', 'medicina-natural', 'Hierbas medicinales, remedios naturales', 'spa', '#4CAF50'),
    ('3d84e0b8-eb1f-44fd-9f8d-5a63946bc63d', 'Farmacia', 'farmacia', 'Medicamentos y productos farmacéuticos', 'pharmacy', '#009688'),
    ('3d84e0b8-eb1f-44fd-9f8d-5a63946bc63d', 'Equipos Médicos', 'equipos-medicos', 'Termómetros, tensiómetros, nebulizadores', 'medical', '#0277BD');

    -- DEPORTES Y FITNESS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('5a9a3ae4-9aa5-47ab-a7cc-b6cee7286a6f', 'Equipos de Gimnasio', 'equipos-gimnasio', 'Pesas, máquinas, accesorios fitness', 'dumbbell', '#FF5722'),
    ('5a9a3ae4-9aa5-47ab-a7cc-b6cee7286a6f', 'Deportes de Pelota', 'deportes-pelota', 'Fútbol, básquet, vóley, tenis', 'football', '#4CAF50'),
    ('5a9a3ae4-9aa5-47ab-a7cc-b6cee7286a6f', 'Bicicletas y Ciclismo', 'bicicletas-ciclismo', 'Bicicletas, repuestos, accesorios', 'bicycle', '#2196F3'),
    ('5a9a3ae4-9aa5-47ab-a7cc-b6cee7286a6f', 'Deportes Acuáticos', 'deportes-acuaticos', 'Natación, surf, deportes de agua', 'swimming', '#00BCD4'),
    ('5a9a3ae4-9aa5-47ab-a7cc-b6cee7286a6f', 'Camping y Outdoor', 'camping-outdoor', 'Carpas, sleeping, equipos de montaña', 'skiing', '#795548'),
    ('5a9a3ae4-9aa5-47ab-a7cc-b6cee7286a6f', 'Ropa Deportiva', 'ropa-deportiva', 'Indumentaria para hacer deporte', 'running_shoe', '#FF9800');

    -- MASCOTAS Y ANIMALES
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Perros', 'perros', 'Cachorros, perros adultos y accesorios caninos', 'dog', '#FF9800'),
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Gatos', 'gatos', 'Gatitos, gatos y productos felinos', 'cat', '#607D8B'),
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Aves Domésticas', 'aves-domesticas', 'Pájaros, loros, canarios y jaulas', 'paw', '#FFC107'),
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Peces y Acuarios', 'peces-acuarios', 'Peces ornamentales y equipos de acuario', 'fish', '#00BCD4'),
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Animales de Granja', 'animales-granja', 'Conejos, gallinas, cerdos, vacas', 'paw', '#8BC34A'),
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Alimentos para Mascotas', 'alimentos-mascotas', 'Comida, snacks y suplementos', 'bone', '#4CAF50'),
    ('05d9b51f-b0a5-4a50-9521-29c8e63e6ac7', 'Accesorios y Juguetes', 'accesorios-juguetes-mascotas', 'Correas, camas, juguetes para mascotas', 'paw', '#9C27B0');

    -- LIBROS Y EDUCACIÓN
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('22793152-0086-42fc-acd3-04e77242a042', 'Libros Escolares', 'libros-escolares', 'Textos de primaria, secundaria y preparatoria', 'book', '#2196F3'),
    ('22793152-0086-42fc-acd3-04e77242a042', 'Libros Universitarios', 'libros-universitarios', 'Textos técnicos, tesis y material académico', 'graduation', '#673AB7'),
    ('22793152-0086-42fc-acd3-04e77242a042', 'Literatura y Novelas', 'literatura-novelas', 'Ficción, poesía, cuentos y novelas', 'library', '#795548'),
    ('22793152-0086-42fc-acd3-04e77242a042', 'Revistas y Periódicos', 'revistas-periodicos', 'Publicaciones periódicas y especializadas', 'book', '#607D8B'),
    ('22793152-0086-42fc-acd3-04e77242a042', 'Libros Técnicos', 'libros-tecnicos', 'Manuales, guías técnicas y especializadas', 'tools', '#FF5722'),
    ('22793152-0086-42fc-acd3-04e77242a042', 'Material Didáctico', 'material-didactico', 'Juegos educativos, material para enseñanza', 'puzzle', '#FF9800');

    -- MÚSICA E INSTRUMENTOS  
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('dbef5983-bf98-41bc-9228-29bad1720988', 'Instrumentos de Cuerda', 'instrumentos-cuerda', 'Guitarras, violines, charangos, mandolinas', 'guitar', '#8E24AA'),
    ('dbef5983-bf98-41bc-9228-29bad1720988', 'Instrumentos de Viento', 'instrumentos-viento', 'Flautas, zampoñas, trompetas, saxofones', 'microphone', '#FF5722'),
    ('dbef5983-bf98-41bc-9228-29bad1720988', 'Instrumentos de Percusión', 'instrumentos-percusion', 'Bombos, tambores, timbales, maracas', 'drum', '#FF9800'),
    ('dbef5983-bf98-41bc-9228-29bad1720988', 'Instrumentos Tradicionales', 'instrumentos-tradicionales', 'Charango, quena, sikus, instrumentos autóctonos', 'guitar', '#795548'),
    ('dbef5983-bf98-41bc-9228-29bad1720988', 'Equipos de Audio', 'equipos-audio', 'Amplificadores, micrófonos, mezcladores', 'music', '#2196F3'),
    ('dbef5983-bf98-41bc-9228-29bad1720988', 'Discos y Música', 'discos-musica', 'CDs, vinilos, música digital, folklore', 'music', '#424242');

    -- JUGUETES Y ENTRETENIMIENTO
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('f6da6dc2-25ef-430a-a9c0-cba1e6ed1c68', 'Juguetes para Bebés', 'juguetes-bebes', 'Sonajeros, peluches, juguetes didácticos', 'baby_clothes', '#FFB74D'),
    ('f6da6dc2-25ef-430a-a9c0-cba1e6ed1c68', 'Muñecas y Figuras', 'munecas-figuras', 'Muñecas, figuras de acción, coleccionables', 'dress', '#E91E63'),
    ('f6da6dc2-25ef-430a-a9c0-cba1e6ed1c68', 'Juegos de Mesa', 'juegos-mesa', 'Ajedrez, monopoly, cartas, juegos familiares', 'puzzle', '#9C27B0'),
    ('f6da6dc2-25ef-430a-a9c0-cba1e6ed1c68', 'Juguetes Educativos', 'juguetes-educativos', 'Rompecabezas, bloques, juegos STEM', 'graduation', '#4CAF50'),
    ('f6da6dc2-25ef-430a-a9c0-cba1e6ed1c68', 'Vehículos de Juguete', 'vehiculos-juguete', 'Autos, camiones, aviones en miniatura', 'car', '#2196F3'),
    ('f6da6dc2-25ef-430a-a9c0-cba1e6ed1c68', 'Peluches', 'peluches', 'Animales de peluche y muñecos suaves', 'cat', '#FF8A65');

    -- JOYERÍA Y ACCESORIOS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('a9d3362b-0d5f-4605-a899-52f43a10f369', 'Joyería Fina', 'joyeria-fina', 'Oro, plata, piedras preciosas', 'gem', '#FFD700'),
    ('a9d3362b-0d5f-4605-a899-52f43a10f369', 'Joyería de Fantasía', 'joyeria-fantasia', 'Bisutería, accesorios económicos', 'gem', '#E91E63'),
    ('a9d3362b-0d5f-4605-a899-52f43a10f369', 'Relojes', 'relojes', 'Relojes de pulsera, de pared, despertadores', 'smartwatch', '#424242'),
    ('a9d3362b-0d5f-4605-a899-52f43a10f369', 'Accesorios para el Cabello', 'accesorios-cabello', 'Vinchas, clips, lazos, diademas', 'hat', '#FF9800'),
    ('a9d3362b-0d5f-4605-a899-52f43a10f369', 'Bolsos y Carteras', 'bolsos-carteras', 'Mochilas, bolsos, billeteras', 'shopping_bag', '#795548'),
    ('a9d3362b-0d5f-4605-a899-52f43a10f369', 'Cinturones y Correas', 'cinturones-correas', 'Cinturones de cuero, tela, decorativos', 'hat', '#6D4C41');

    -- HERRAMIENTAS Y CONSTRUCCIÓN
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('d40511c9-bcd5-40d6-9600-d2caa2ff6db3', 'Herramientas Manuales', 'herramientas-manuales', 'Martillos, destornilladores, llaves', 'hammer', '#607D8B'),
    ('d40511c9-bcd5-40d6-9600-d2caa2ff6db3', 'Herramientas Eléctricas', 'herramientas-electricas', 'Taladros, sierras, pulidoras', 'tools', '#FF5722'),
    ('d40511c9-bcd5-40d6-9600-d2caa2ff6db3', 'Materiales de Construcción', 'materiales-construccion', 'Cemento, ladrillos, fierros, maderas', 'tools', '#795548'),
    ('d40511c9-bcd5-40d6-9600-d2caa2ff6db3', 'Cerrajería y Seguridad', 'cerrajeria-seguridad', 'Cerraduras, candados, llaves', 'key', '#424242'),
    ('d40511c9-bcd5-40d6-9600-d2caa2ff6db3', 'Pintura y Acabados', 'pintura-acabados', 'Pinturas, brochas, rodillos, barnices', 'paint_brush', '#4CAF50'),
    ('d40511c9-bcd5-40d6-9600-d2caa2ff6db3', 'Plomería y Electricidad', 'plomeria-electricidad', 'Tubos, cables, interruptores, griferías', 'tools', '#2196F3');

    -- JARDÍN Y AGRICULTURA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('6c4ef281-e186-4ce6-9566-d1ea78f2964c', 'Plantas y Flores', 'plantas-flores', 'Plantas ornamentales, flores, árboles', 'leaf', '#4CAF50'),
    ('6c4ef281-e186-4ce6-9566-d1ea78f2964c', 'Semillas y Plantines', 'semillas-plantines', 'Semillas de hortalizas, flores, césped', 'seedling', '#8BC34A'),
    ('6c4ef281-e186-4ce6-9566-d1ea78f2964c', 'Herramientas de Jardín', 'herramientas-jardin', 'Palas, rastrillos, tijeras de podar', 'tools', '#795548'),
    ('6c4ef281-e186-4ce6-9566-d1ea78f2964c', 'Fertilizantes y Abonos', 'fertilizantes-abonos', 'Abonos orgánicos, fertilizantes químicos', 'leaf', '#FF9800'),
    ('6c4ef281-e186-4ce6-9566-d1ea78f2964c', 'Productos Agrícolas', 'productos-agricolas', 'Verduras, frutas, productos del campo', 'apple', '#4CAF50'),
    ('6c4ef281-e186-4ce6-9566-d1ea78f2964c', 'Equipos de Riego', 'equipos-riego', 'Mangueras, aspersores, sistemas de riego', 'tools', '#2196F3');

    -- ARTESANÍAS Y MANUALIDADES
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('05804933-9ae9-4093-a81f-cd88f3ab820e', 'Textiles Artesanales', 'textiles-artesanales', 'Aguayos, manteles, tapices tejidos', 'tshirt', '#FF5722'),
    ('05804933-9ae9-4093-a81f-cd88f3ab820e', 'Cerámica y Alfarería', 'ceramica-alfareria', 'Vasijas, platos, objetos de barro', 'palette', '#795548'),
    ('05804933-9ae9-4093-a81f-cd88f3ab820e', 'Trabajos en Madera', 'trabajos-madera', 'Tallados, muebles rústicos, artesanías', 'chair', '#8D6E63'),
    ('05804933-9ae9-4093-a81f-cd88f3ab820e', 'Arte y Pintura', 'arte-pintura', 'Cuadros, esculturas, obras de arte', 'paint_brush', '#9C27B0'),
    ('05804933-9ae9-4093-a81f-cd88f3ab820e', 'Materiales para Manualidades', 'materiales-manualidades', 'Hilos, lanas, papeles, pegamentos', 'palette', '#FF9800'),
    ('05804933-9ae9-4093-a81f-cd88f3ab820e', 'Joyería Artesanal', 'joyeria-artesanal', 'Collares, pulseras, aretes hechos a mano', 'gem', '#E91E63');

    -- SERVICIOS PROFESIONALES
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('e1b39562-31a5-41e5-b161-0794d60d21a8', 'Reparaciones Técnicas', 'reparaciones-tecnicas', 'Servicio de reparación de electrodomésticos', 'tools', '#FF5722'),
    ('e1b39562-31a5-41e5-b161-0794d60d21a8', 'Servicios de Construcción', 'servicios-construccion', 'Albañilería, plomería, electricidad', 'hammer', '#795548'),
    ('e1b39562-31a5-41e5-b161-0794d60d21a8', 'Servicios de Limpieza', 'servicios-limpieza', 'Limpieza de hogares, oficinas, alfombras', 'cleaning', '#00BCD4'),
    ('e1b39562-31a5-41e5-b161-0794d60d21a8', 'Servicios de Transporte', 'servicios-transporte', 'Mudanzas, fletes, taxi, delivery', 'truck', '#607D8B'),
    ('e1b39562-31a5-41e5-b161-0794d60d21a8', 'Servicios Educativos', 'servicios-educativos', 'Clases particulares, tutorías', 'graduation', '#2196F3'),
    ('e1b39562-31a5-41e5-b161-0794d60d21a8', 'Servicios de Belleza', 'servicios-belleza', 'Peluquería, manicure, tratamientos', 'beauty', '#E91E63');

    -- OFICINA Y PAPELERÍA
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('f4afdb37-5dc1-4b95-9d0d-9eb0d8ce4da3', 'Papelería Básica', 'papeleria-basica', 'Cuadernos, lápices, bolígrafos, reglas', 'pen', '#FFC107'),
    ('f4afdb37-5dc1-4b95-9d0d-9eb0d8ce4da3', 'Equipos de Oficina', 'equipos-oficina', 'Impresoras, computadoras, teléfonos', 'laptop', '#607D8B'),
    ('f4afdb37-5dc1-4b95-9d0d-9eb0d8ce4da3', 'Muebles de Oficina', 'muebles-oficina', 'Escritorios, sillas, archivadores', 'chair', '#795548'),
    ('f4afdb37-5dc1-4b95-9d0d-9eb0d8ce4da3', 'Material de Archivo', 'material-archivo', 'Carpetas, folders, etiquetas', 'briefcase', '#2196F3'),
    ('f4afdb37-5dc1-4b95-9d0d-9eb0d8ce4da3', 'Suministros de Impresión', 'suministros-impresion', 'Tintas, cartuchos, papel especial', 'printer', '#424242'),
    ('f4afdb37-5dc1-4b95-9d0d-9eb0d8ce4da3', 'Accesorios de Escritorio', 'accesorios-escritorio', 'Calculadoras, grapadoras, perforadoras', 'calculator', '#FF9800');

    -- OTROS Y VARIOS
    INSERT INTO "Category" (parent_category_id, name, slug, description, icon, color) VALUES
    ('c6f97ff1-49e2-4dfe-a50d-f28410ad5b6e', 'Productos de Segunda Mano', 'productos-segunda-mano', 'Artículos usados en buen estado', 'eco', '#4CAF50'),
    ('c6f97ff1-49e2-4dfe-a50d-f28410ad5b6e', 'Coleccionables', 'coleccionables', 'Monedas, estampillas, objetos antiguos', 'gem', '#9C27B0'),
    ('c6f97ff1-49e2-4dfe-a50d-f28410ad5b6e', 'Productos Importados', 'productos-importados', 'Artículos traídos del extranjero', 'store', '#2196F3'),
    ('c6f97ff1-49e2-4dfe-a50d-f28410ad5b6e', 'Artículos de Temporada', 'articulos-temporada', 'Decoraciones navideñas, carnaval', 'gift', '#FF9800'),
    ('c6f97ff1-49e2-4dfe-a50d-f28410ad5b6e', 'Productos Reciclados', 'productos-reciclados', 'Artículos reutilizados y ecológicos', 'eco', '#4CAF50'),
    ('c6f97ff1-49e2-4dfe-a50d-f28410ad5b6e', 'Misceláneos', 'miscelaneos', 'Productos que no encajan en otras categorías', 'category', '#9E9E9E');

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
