#!/bin/bash

# Corrige permisos de un proyecto Laravel + Vite en WSL/Linux
# Da permisos completos a toda la carpeta del proyecto

set -e  # Salir si hay un error
set -u  # Error si se usan variables no definidas

# === Configuración ===
PROJECT_DIR="./src"
USER_ID=$(id -u)
GROUP_ID=$(id -g)

# Colores
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔧 Dando permisos completos a toda la carpeta $PROJECT_DIR...${NC}"

# Verifica existencia del directorio
if [ ! -d "$PROJECT_DIR" ]; then
  echo -e "${RED}❌ El directorio $PROJECT_DIR no existe.${NC}"
  exit 1
fi

# Cambia propiedad completa al usuario actual
echo -e "⏳ Asignando dueño a UID $USER_ID:$GROUP_ID en $PROJECT_DIR..."
if chown -R "$USER_ID:$GROUP_ID" "$PROJECT_DIR" 2>/dev/null; then
    echo -e "${GREEN}✅ Propietario cambiado correctamente.${NC}"
else
    echo -e "${YELLOW}⚠️  Intentando con sudo...${NC}"
    if sudo chown -R "$USER_ID:$GROUP_ID" "$PROJECT_DIR"; then
        echo -e "${GREEN}✅ Propietario cambiado con sudo.${NC}"
    else
        echo -e "${RED}❌ No se pudo cambiar el propietario.${NC}"
        exit 1
    fi
fi

# Da permisos de lectura, escritura y ejecución a toda la carpeta
echo -e "⏳ Asignando permisos 755 a toda la carpeta..."
if chmod -R 755 "$PROJECT_DIR" 2>/dev/null; then
    echo -e "${GREEN}✅ Permisos 755 asignados correctamente.${NC}"
else
    echo -e "${YELLOW}⚠️  Intentando con sudo...${NC}"
    if sudo chmod -R 755 "$PROJECT_DIR"; then
        echo -e "${GREEN}✅ Permisos 755 asignados con sudo.${NC}"
    else
        echo -e "${RED}❌ No se pudieron cambiar los permisos.${NC}"
        exit 1
    fi
fi

# Opción adicional: permisos completos (777) si se necesita
echo -e "${YELLOW}¿Quieres dar permisos completos (777) para desarrollo? [y/N]:${NC}"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "⏳ Asignando permisos completos (777)..."
    if chmod -R 777 "$PROJECT_DIR" 2>/dev/null; then
        echo -e "${GREEN}✅ Permisos completos (777) asignados.${NC}"
    else
        sudo chmod -R 777 "$PROJECT_DIR" && echo -e "${GREEN}✅ Permisos completos (777) asignados con sudo.${NC}"
    fi
fi

echo -e "${GREEN}🎉 Todos los permisos han sido configurados correctamente.${NC}"
echo -e "${GREEN}📝 Ahora puedes editar cualquier archivo en VS Code sin problemas.${NC}"