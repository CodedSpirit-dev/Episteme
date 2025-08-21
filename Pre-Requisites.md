# Configuración del Entorno de Desarrollo

## 1. Instalar Volta y Node.js
```bash
# Instalar Volta
curl https://get.volta.sh | bash

# Reiniciar tu terminal

# Instalar Node.js
volta install node@24

# Verificar versión de Node.js
node -v  # Debe mostrar una versión como "v24.x.x"
```

## 2. Instalar pnpm
```bash
volta install pnpm

# Verificar versión de pnpm
pnpm -v
```

---

## Configuración del Proyecto Laravel + Vue

## 1. Navegar al Directorio del Proyecto e Instalar Dependencias
```bash
cd /src
pnpm install
```

## 2. Aprobar Scripts de Construcción
```bash
pnpm approve-builds
```
Cuando aparezca el menú interactivo:
1. Usa la **barra espaciadora** para seleccionar:
   - `@tailwindcss/oxide`
   - `esbuild`
   - `vue-demi`
2. Presiona **Enter** para confirmar.

### ¿Por qué Aprobar Estos Paquetes?
- **`@tailwindcss/oxide`**: Requerido para Tailwind CSS.
- **`esbuild`**: Necesario para la compilación de assets (especialmente con Vite en Laravel).
- **`vue-demi`**: Asegura compatibilidad entre Vue 2 y Vue 3.

---

## Ejecutar el Proyecto

## 1. Iniciar Contenedores Docker
```bash
cd ..
# Nota: `sudo` puede ser opcional dependiendo de tu sistema
sudo docker compose up --build
```

## 2. Configurar Permisos (IMPORTANTE)
```bash
# Después de que los contenedores estén ejecutándose
# Cambiar permisos de toda la carpeta src para poder editar en VS Code
sudo chown -R $(id -u):$(id -g) ./src/

# Alternativamente, dar permisos de escritura completos
sudo chmod -R 755 ./src/
```

## 3. Iniciar Sesión
Una vez completada la configuración, ve a [http://localhost:8000](http://localhost:8000) e inicia sesión con las siguientes credenciales:
- **Email:** `admin@example.com`
- **Password:** `12345678`

---

## Solución de Problemas

### Error de Permisos en VS Code
Si no puedes editar archivos en VS Code:
```bash
# Ejecutar desde la raíz del proyecto
sudo chown -R $(id -u):$(id -g) ./src/
```

### Reconstruir Contenedores
Si necesitas reconstruir completamente:
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
# Luego configurar permisos nuevamente
sudo chown -R $(id -u):$(id -g) ./src/
```