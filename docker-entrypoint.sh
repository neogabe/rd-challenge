#!/bin/bash
set -e

# Garante que estamos no diretório correto
cd /app

# Remove o banco de dados se existir
echo "🗑️  Removendo banco de dados antigo..."
bundle exec rails db:drop 2>/dev/null || true

# Cria o banco de dados
echo "📦 Criando novo banco de dados..."
bundle exec rails db:create

# Executa as migrações
echo "🔄 Executando migrações..."
bundle exec rails db:migrate

# Executa os seeds
echo "🌱 Executando seeds..."
bundle exec rails db:seed

# Inicia o servidor na porta 3000
echo "🚀 Iniciando servidor Rails na porta 3000..."
exec bundle exec rails server -b 0.0.0.0 -p 3000 