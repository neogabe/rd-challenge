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

### Health Check

- `GET /up` - Verifica o status de saúde da aplicação

### Carrinho de Compras

#### 1. Criar carrinho e adicionar produto

- **POST** `/cart`
- **Descrição**: Cria um novo carrinho (se não existir) e adiciona um produto
- **Parâmetros**:
  ```json
  {
    "product_id": 1,
    "quantity": 2
  }
  ```
- **Resposta de sucesso** (200):
  ```json
  {
    "cart": {
      "id": 1,
      "items": [
        {
          "product_id": 1,
          "product_name": "Produto Teste",
          "quantity": 2,
          "unit_price": "10.0",
          "total_price": "20.0"
        }
      ],
      "total": "20.0"
    }
  }
  ```

#### 2. Visualizar carrinho

- **GET** `/cart`
- **Descrição**: Retorna os itens do carrinho atual
- **Resposta de sucesso** (200):
  ```json
  {
    "cart": {
      "id": 1,
      "items": [...],
      "total": "20.0"
    }
  }
  ```
- **Resposta de erro** (404): `{"error": "Carrinho não encontrado"}`

#### 3. Atualizar quantidade de produto

- **PATCH** `/cart/:product_id`
- **Descrição**: Atualiza a quantidade de um produto específico no carrinho
- **Parâmetros**:
  ```json
  {
    "quantity": 3
  }
  ```
- **Resposta de sucesso** (200): Mesmo formato do carrinho atualizado
- **Resposta de erro** (422): `{"error": "Quantidade deve ser maior que zero"}`

#### 4. Remover produto do carrinho

- **DELETE** `/cart/:product_id`
- **Descrição**: Remove um produto específico do carrinho
- **Resposta de sucesso** (200): Carrinho atualizado sem o produto
- **Resposta de erro** (404): `{"error": "Produto não encontrado no carrinho"}`

### Exemplos de uso no Postman

#### Configuração base:

- **Base URL**: `http://localhost:3000`
- **Headers**: `Content-Type: application/json`

#### Sequência de testes:

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
