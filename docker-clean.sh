#!/bin/bash

echo "🧹 Limpando todos os dados do Docker..."

# Para todos os containers
docker-compose down

# Remove todos os volumes
docker-compose down -v

# Remove imagens antigas
docker system prune -f

# Remove volumes órfãos
docker volume prune -f

echo "✅ Limpeza concluída!"
echo "🚀 Para iniciar novamente: docker-compose up --build" 