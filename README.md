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

### 2. Pare e remova containers antigos (se existirem)

```bash
docker stop postgres-rd redis-rd
docker rm postgres-rd redis-rd
```

---

### 3. Suba todos os serviços (Rails, PostgreSQL, Redis) com Docker Compose

```bash
docker-compose up --build
```

Aguarde até aparecer a mensagem "Listening on http://0.0.0.0:3000"

- O Rails estará disponível em [http://localhost:3000](http://localhost:3000)
- O banco de dados estará disponível na porta 5432
- O Redis estará disponível na porta 6379

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

## Endpoints da API

1. **Criar carrinho**: POST `/cart` com `{"product_id": 1, "quantity": 2}`
2. **Ver carrinho**: GET `/cart`
3. **Atualizar produto**: PATCH `/cart/1` com `{"quantity": 5}`
4. **Remover produto**: DELETE `/cart/1`

---

## Observações

- O projeto utiliza session para identificar o carrinho do usuário.
- O controle de carrinhos abandonados é feito via job com Sidekiq e agendamento automático com sidekiq-cron.
- O setup com Docker Compose facilita a execução do projeto em qualquer ambiente.
- Todos os endpoints retornam JSON e utilizam códigos de status HTTP apropriados.
- Validações incluem verificação de quantidade positiva e existência de produtos.

---
