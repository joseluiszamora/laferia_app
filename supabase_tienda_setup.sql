-- =====================================================
-- SETUP DE TIENDAS Y COMENTARIOS PARA LA FERIA APP
-- =====================================================

-- Crear extensión para funciones de geometría (opcional, para funciones geoespaciales avanzadas)
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- =====================================================
-- TABLA TIENDA
-- =====================================================

-- Crear la tabla Tienda
CREATE TABLE IF NOT EXISTS "Tienda" (
    tienda_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(255) NOT NULL,
    nombre_propietario VARCHAR(255) NOT NULL,
    latitud DOUBLE PRECISION NOT NULL,
    longitud DOUBLE PRECISION NOT NULL,
    categoria_id UUID NOT NULL REFERENCES "Category"(category_id) ON DELETE RESTRICT,
    productos TEXT[] DEFAULT '{}', -- Array de strings para IDs de productos
    contacto JSONB, -- Información de contacto en formato JSON
    direccion TEXT,
    dias_atencion TEXT[] DEFAULT '{Jueves,Domingo}', -- Array de días de atención
    horario_atencion VARCHAR(50) DEFAULT '08:00 - 18:00',
    horario VARCHAR(50), -- Mantener por compatibilidad
    calificacion_promedio DECIMAL(3,2) DEFAULT 0.00 CHECK (calificacion_promedio >= 0 AND calificacion_promedio <= 5),
    activa BOOLEAN DEFAULT true,
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    fecha_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- TABLA COMENTARIO
-- =====================================================

-- Crear la tabla Comentario
CREATE TABLE IF NOT EXISTS "Comentario" (
    comentario_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tienda_id UUID NOT NULL REFERENCES "Tienda"(tienda_id) ON DELETE CASCADE,
    nombre_usuario VARCHAR(255) NOT NULL,
    avatar_url TEXT,
    comentario TEXT NOT NULL,
    calificacion DECIMAL(2,1) NOT NULL CHECK (calificacion >= 0 AND calificacion <= 5),
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    verificado BOOLEAN DEFAULT false,
    imagenes TEXT[] DEFAULT '{}', -- Array de URLs de imágenes
    activo BOOLEAN DEFAULT true
);

-- =====================================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para la tabla Tienda
CREATE INDEX IF NOT EXISTS idx_tienda_categoria ON "Tienda"(categoria_id);
CREATE INDEX IF NOT EXISTS idx_tienda_nombre ON "Tienda"(nombre);
CREATE INDEX IF NOT EXISTS idx_tienda_propietario ON "Tienda"(nombre_propietario);
CREATE INDEX IF NOT EXISTS idx_tienda_ubicacion ON "Tienda"(latitud, longitud);
CREATE INDEX IF NOT EXISTS idx_tienda_activa ON "Tienda"(activa);
CREATE INDEX IF NOT EXISTS idx_tienda_calificacion ON "Tienda"(calificacion_promedio);

-- Índices para la tabla Comentario
CREATE INDEX IF NOT EXISTS idx_comentario_tienda ON "Comentario"(tienda_id);
CREATE INDEX IF NOT EXISTS idx_comentario_fecha ON "Comentario"(fecha_creacion);
CREATE INDEX IF NOT EXISTS idx_comentario_calificacion ON "Comentario"(calificacion);
CREATE INDEX IF NOT EXISTS idx_comentario_verificado ON "Comentario"(verificado);

-- =====================================================
-- TRIGGERS PARA ACTUALIZACIÓN AUTOMÁTICA
-- =====================================================

-- Función para actualizar fecha_actualizacion
CREATE OR REPLACE FUNCTION update_fecha_actualizacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar fecha_actualizacion en Tienda
CREATE OR REPLACE TRIGGER trigger_tienda_fecha_actualizacion
    BEFORE UPDATE ON "Tienda"
    FOR EACH ROW
    EXECUTE FUNCTION update_fecha_actualizacion();

-- Función para recalcular calificación promedio de tienda
CREATE OR REPLACE FUNCTION recalcular_calificacion_tienda()
RETURNS TRIGGER AS $$
DECLARE
    nueva_calificacion DECIMAL(3,2);
BEGIN
    -- Calcular la nueva calificación promedio
    SELECT COALESCE(AVG(calificacion), 0)
    INTO nueva_calificacion
    FROM "Comentario"
    WHERE tienda_id = COALESCE(NEW.tienda_id, OLD.tienda_id)
    AND activo = true;

    -- Actualizar la calificación en la tabla Tienda
    UPDATE "Tienda"
    SET calificacion_promedio = nueva_calificacion
    WHERE tienda_id = COALESCE(NEW.tienda_id, OLD.tienda_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Triggers para recalcular calificación automáticamente
CREATE OR REPLACE TRIGGER trigger_comentario_insert_calificacion
    AFTER INSERT ON "Comentario"
    FOR EACH ROW
    EXECUTE FUNCTION recalcular_calificacion_tienda();

CREATE OR REPLACE TRIGGER trigger_comentario_update_calificacion
    AFTER UPDATE ON "Comentario"
    FOR EACH ROW
    EXECUTE FUNCTION recalcular_calificacion_tienda();

CREATE OR REPLACE TRIGGER trigger_comentario_delete_calificacion
    AFTER DELETE ON "Comentario"
    FOR EACH ROW
    EXECUTE FUNCTION recalcular_calificacion_tienda();

-- =====================================================
-- POLÍTICAS DE SEGURIDAD (RLS)
-- =====================================================

-- Habilitar RLS para ambas tablas
ALTER TABLE "Tienda" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Comentario" ENABLE ROW LEVEL SECURITY;

-- Políticas para la tabla Tienda
CREATE POLICY "Allow read access for all users" ON "Tienda"
    FOR SELECT
    USING (activa = true);

CREATE POLICY "Allow insert for authenticated users" ON "Tienda"
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update for authenticated users" ON "Tienda"
    FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow delete for authenticated users" ON "Tienda"
    FOR DELETE TO authenticated
    USING (true);

-- Políticas para la tabla Comentario
CREATE POLICY "Allow read comments for all users" ON "Comentario"
    FOR SELECT
    USING (activo = true);

CREATE POLICY "Allow insert comments for authenticated users" ON "Comentario"
    FOR INSERT TO authenticated
    WITH CHECK (true);

CREATE POLICY "Allow update own comments" ON "Comentario"
    FOR UPDATE TO authenticated
    USING (true) -- En producción, agregar verificación de ownership
    WITH CHECK (true);

CREATE POLICY "Allow delete own comments" ON "Comentario"
    FOR DELETE TO authenticated
    USING (true); -- En producción, agregar verificación de ownership

-- =====================================================
-- FUNCIONES ÚTILES
-- =====================================================

-- Función para buscar tiendas por proximidad (versión básica)
CREATE OR REPLACE FUNCTION buscar_tiendas_cercanas(
    lat_centro DOUBLE PRECISION,
    lng_centro DOUBLE PRECISION,
    radio_km DOUBLE PRECISION DEFAULT 5.0
)
RETURNS TABLE(
    tienda_id UUID,
    nombre VARCHAR,
    distancia_km DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        t.tienda_id,
        t.nombre,
        -- Fórmula de Haversine para calcular distancia
        (6371 * acos(cos(radians(lat_centro)) * cos(radians(t.latitud)) * 
         cos(radians(t.longitud) - radians(lng_centro)) + 
         sin(radians(lat_centro)) * sin(radians(t.latitud)))) AS distancia_km
    FROM "Tienda" t
    WHERE t.activa = true
    AND (6371 * acos(cos(radians(lat_centro)) * cos(radians(t.latitud)) * 
         cos(radians(t.longitud) - radians(lng_centro)) + 
         sin(radians(lat_centro)) * sin(radians(t.latitud)))) <= radio_km
    ORDER BY distancia_km;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de tienda
CREATE OR REPLACE FUNCTION obtener_estadisticas_tienda(p_tienda_id UUID)
RETURNS TABLE(
    total_comentarios INT,
    calificacion_promedio DECIMAL,
    comentarios_ultimo_mes INT,
    calificacion_mes DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INT as total_comentarios,
        COALESCE(AVG(c.calificacion), 0)::DECIMAL as calificacion_promedio,
        COUNT(CASE WHEN c.fecha_creacion >= NOW() - INTERVAL '30 days' THEN 1 END)::INT as comentarios_ultimo_mes,
        COALESCE(AVG(CASE WHEN c.fecha_creacion >= NOW() - INTERVAL '30 days' THEN c.calificacion END), 0)::DECIMAL as calificacion_mes
    FROM "Comentario" c
    WHERE c.tienda_id = p_tienda_id
    AND c.activo = true;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- DATOS DE EJEMPLO
-- =====================================================

-- Insertar tiendas de ejemplo (basadas en categorías existentes)
DO $$
DECLARE
    ropa_categoria_id UUID;
    autopartes_categoria_id UUID;
    comida_categoria_id UUID;
    electronica_categoria_id UUID;
BEGIN
    -- Obtener IDs de categorías
    SELECT category_id INTO ropa_categoria_id FROM "Category" WHERE slug = 'ropa-moda' LIMIT 1;
    SELECT category_id INTO autopartes_categoria_id FROM "Category" WHERE slug = 'autopartes-vehiculos' LIMIT 1;
    SELECT category_id INTO comida_categoria_id FROM "Category" WHERE slug = 'comida-bebidas' LIMIT 1;
    SELECT category_id INTO electronica_categoria_id FROM "Category" WHERE slug = 'electronica-tecnologia' LIMIT 1;

    -- Solo insertar si encontramos las categorías
    IF ropa_categoria_id IS NOT NULL THEN
        INSERT INTO "Tienda" (nombre, nombre_propietario, latitud, longitud, categoria_id, contacto, direccion, dias_atencion, horario_atencion) VALUES
        ('Ropa Americana Juan', 'Juan Pérez', -16.500123, -68.123456, ropa_categoria_id, 
         '{"telefono": "71234567", "whatsapp": "71234567", "redes_sociales": {"facebook": "ropajuan", "instagram": "@ropajuan"}}',
         'Pasillo 5, Puesto 23, La Feria', 
         '{Jueves,Domingo}', '08:00 - 18:00'),
        ('Fardos La Económica', 'María González', -16.501234, -68.124567, ropa_categoria_id,
         '{"telefono": "72345678", "whatsapp": "72345678"}',
         'Pasillo 3, Puesto 45, La Feria',
         '{Jueves,Domingo}', '07:30 - 19:00');
    END IF;

    IF autopartes_categoria_id IS NOT NULL THEN
        INSERT INTO "Tienda" (nombre, nombre_propietario, latitud, longitud, categoria_id, contacto, direccion, dias_atencion, horario_atencion) VALUES
        ('Autopartes Rodriguez', 'Carlos Rodriguez', -16.502345, -68.125678, autopartes_categoria_id,
         '{"telefono": "73456789", "whatsapp": "73456789", "redes_sociales": {"facebook": "autopartesrodriguez"}}',
         'Sector Autopartes, Puesto 12, La Feria',
         '{Martes,Jueves,Sábado,Domingo}', '08:00 - 18:30');
    END IF;

    IF comida_categoria_id IS NOT NULL THEN
        INSERT INTO "Tienda" (nombre, nombre_propietario, latitud, longitud, categoria_id, contacto, direccion, dias_atencion, horario_atencion) VALUES
        ('Comida Típica Doña Rosa', 'Rosa Mamani', -16.499876, -68.122345, comida_categoria_id,
         '{"telefono": "74567890", "whatsapp": "74567890"}',
         'Sector Comidas, Puesto 8, La Feria',
         '{Jueves,Domingo}', '06:00 - 16:00');
    END IF;

    IF electronica_categoria_id IS NOT NULL THEN
        INSERT INTO "Tienda" (nombre, nombre_propietario, latitud, longitud, categoria_id, contacto, direccion, dias_atencion, horario_atencion) VALUES
        ('Electrónicos La Moderna', 'Luis Condori', -16.503456, -68.126789, electronica_categoria_id,
         '{"telefono": "75678901", "whatsapp": "75678901", "redes_sociales": {"instagram": "@electronicos_moderna"}}',
         'Pasillo 8, Puesto 67, La Feria',
         '{Martes,Jueves,Sábado,Domingo}', '09:00 - 19:00');
    END IF;

END $$;

-- Insertar comentarios de ejemplo
DO $$
DECLARE
    tienda_ejemplo_id UUID;
BEGIN
    -- Obtener ID de una tienda de ejemplo
    SELECT tienda_id INTO tienda_ejemplo_id FROM "Tienda" LIMIT 1;
    
    IF tienda_ejemplo_id IS NOT NULL THEN
        INSERT INTO "Comentario" (tienda_id, nombre_usuario, comentario, calificacion, verificado) VALUES
        (tienda_ejemplo_id, 'Cliente Satisfecho', 'Excelente atención y buenos precios. Muy recomendado!', 5.0, true),
        (tienda_ejemplo_id, 'Comprador Frecuente', 'Buena variedad de productos, aunque a veces hay que esperar un poco.', 4.0, false),
        (tienda_ejemplo_id, 'Usuario Regular', 'Precios justos y productos de calidad. Volveré!', 4.5, true);
    END IF;
END $$;

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista para tiendas con información completa
CREATE OR REPLACE VIEW vista_tiendas_completa AS
SELECT 
    t.tienda_id,
    t.nombre,
    t.nombre_propietario,
    t.latitud,
    t.longitud,
    t.categoria_id,
    c.name as categoria_nombre,
    c.slug as categoria_slug,
    t.contacto,
    t.direccion,
    t.dias_atencion,
    t.horario_atencion,
    t.calificacion_promedio,
    COUNT(com.comentario_id) as total_comentarios,
    t.activa,
    t.fecha_registro,
    t.fecha_actualizacion
FROM "Tienda" t
LEFT JOIN "Category" c ON t.categoria_id = c.category_id
LEFT JOIN "Comentario" com ON t.tienda_id = com.tienda_id AND com.activo = true
GROUP BY t.tienda_id, c.name, c.slug;

-- Vista para ranking de tiendas mejor calificadas
CREATE OR REPLACE VIEW vista_ranking_tiendas AS
SELECT 
    t.tienda_id,
    t.nombre,
    t.nombre_propietario,
    t.calificacion_promedio,
    COUNT(c.comentario_id) as total_comentarios,
    cat.name as categoria
FROM "Tienda" t
LEFT JOIN "Comentario" c ON t.tienda_id = c.tienda_id AND c.activo = true
LEFT JOIN "Category" cat ON t.categoria_id = cat.category_id
WHERE t.activa = true
AND t.calificacion_promedio > 0
GROUP BY t.tienda_id, t.nombre, t.nombre_propietario, t.calificacion_promedio, cat.name
ORDER BY t.calificacion_promedio DESC, COUNT(c.comentario_id) DESC;

-- =====================================================
-- FINALIZACIÓN
-- =====================================================

-- Actualizar estadísticas de las tablas
ANALYZE "Tienda";
ANALYZE "Comentario";

-- Mensaje de confirmación
DO $$
DECLARE
    total_tiendas INT;
    total_comentarios INT;
BEGIN
    SELECT COUNT(*) INTO total_tiendas FROM "Tienda";
    SELECT COUNT(*) INTO total_comentarios FROM "Comentario";
    
    RAISE NOTICE 'Setup de tiendas completado exitosamente.';
    RAISE NOTICE 'Total de tiendas creadas: %', total_tiendas;
    RAISE NOTICE 'Total de comentarios creados: %', total_comentarios;
    RAISE NOTICE 'Funciones, triggers y vistas creadas correctamente.';
END $$;
