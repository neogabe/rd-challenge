# RD Station Challenge - Carrinho de Compras

Este projeto é um desafio técnico para a vaga de desenvolvedor backend júnior na RD Station, desenvolvido em Ruby on Rails, com uma API para gerenciamento de carrinho de compras.

## Tecnologias utilizadas

- Ruby 3.3.1
- Rails 7.1.3.2
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
git clone https://github.com/SEU_USUARIO/rd-challenge.git
cd rd-challenge
```

---

### 2. Suba os containers do PostgreSQL e Redis

```bash
docker run --name postgres-rd -e POSTGRES_PASSWORD=suasenha -p 5432:5432 -d postgres:16
docker run --name redis-rd -p 6379:6379 -d redis:7.0.15
```

---

### 3. Instale as dependências do projeto

```bash
bundle install
```

---

### 4. Configure o banco de dados

Edite o arquivo `config/database.yml` se necessário, usando:

```yaml
username: postgres
password: suasenha
host: localhost
```

---

### 5. Crie e migre o banco de dados

```bash
rails db:create
rails db:migrate
```

---

### 6. (Opcional) Popule o banco com produtos de exemplo

```bash
rails console
Product.create(name: "Produto Teste", unit_price: 10.0)
exit
```

---

### 7. Rode o servidor Rails

```bash
rails server
```

A API estará disponível em [http://localhost:3000](http://localhost:3000)

---

### 8. Rode o Sidekiq (em outro terminal)

```bash
bundle exec sidekiq
```

---

### 9. Executando os testes

```bash
rails db:test:prepare
bundle exec rspec
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
- O controle de carrinhos abandonados é feito via job com Sidekiq.

---
