# RD Station Challenge - Carrinho de Compras

Este projeto é um desafio técnico para a vaga de Desenvolvedor Backend Júnior na RD Station. Foi desenvolvido em Ruby on Rails e consiste em uma API para gerenciamento de carrinho de compras.

O desafio foi implementado conforme o documento fornecido:
https://docs.google.com/document/d/1QzSduQU6qfRCEhoyPvKkL0ulS2OMxr83EOCv_W3_7gg/edit?tab=t.0

## Tecnologias utilizadas

- Ruby 3.3.7
- Rails 8.0.2
- PostgreSQL 16 (via Docker)
- Redis 7.0.15 (via Docker)
- Sidekiq

---

## Como rodar o projeto

### Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e rodando
- [Git](https://git-scm.com/) instalado

---

### 1. Clone o repositório

```bash
git clone https://github.com/neogabe/rd-challenge.git
cd rd-challenge
```

---

### 2. Configure o Docker Compose

Copie o arquivo de exemplo do Docker Compose:

```bash
cp docker-compose.example.yml docker-compose.yml
```

---

### 3. Suba todos os serviços (Rails, PostgreSQL, Redis) com Docker Compose

```bash
docker-compose up -d --build
```

Aguarde alguns segundos para que todos os serviços iniciem. Você pode verificar o status com:

```bash
docker-compose ps
```

- O Rails estará disponível em [http://localhost:3000](http://localhost:3000)
- O banco de dados estará disponível na porta 5432
- O Redis estará disponível na porta 6379

> **Observação:** Não é necessário alterar a senha do banco de dados. O ambiente já está configurado para funcionar com a senha padrão definida no docker-compose.yml.

---

### 4. Rode as migrations dentro do container

Abra um novo terminal e execute:

```bash
docker-compose run web bundle exec rails db:migrate
```

---

### 5. (Opcional) Popule o banco com produtos de exemplo

```bash
docker-compose run web bundle exec rails console
Product.create(name: "Produto Teste", unit_price: 10.0)
exit
```

---

### 6. Rode o Sidekiq para processar jobs em background

```bash
docker-compose run web bundle exec sidekiq
```

---

### 7. Executando os testes

```bash
docker-compose run web bundle exec rails db:test:prepare
docker-compose run web bundle exec rspec
```

---

## Endpoints principais

- `POST /cart` - Adiciona produto ao carrinho
- `GET /cart` - Lista os itens do carrinho
- `POST /cart/add_item` - Altera a quantidade de um produto no carrinho
- `DELETE /cart/:product_id` - Remove um produto do carrinho

---

## Observações

- O projeto utiliza session para identificar o carrinho do usuário.
- O controle de carrinhos abandonados é feito via job com Sidekiq e agendamento automático com sidekiq-cron.
- O setup com Docker Compose facilita a execução do projeto em qualquer ambiente.

---
