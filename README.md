# Dynamik Devs

Aplicação fullstack para gerir uma lista de desenvolvedores.  
Backend em **Laravel** exposto via REST API · Frontend em **Flutter Web/Mobile**.

---

## Stacks e versões

| Camada | Tecnologia | Versão |
|--------|-----------|--------|
| Backend | PHP | 8.3 |
| Backend | Laravel | 11.51 |
| Backend | PostgreSQL | 16 |
| Frontend | Flutter | 3.38.3 |
| Frontend | Dart | 3.10.1 |
| Infra | Docker / Compose | 29 / 5 |

---

## Estrutura do repositório

```
desafio-fullstack/
├── docker-compose.yml   # Orquestra os 3 serviços (API + Frontend + PostgreSQL)
├── backend/             # API Laravel
│   ├── app/
│   │   ├── Actions/              # CreateDevAction
│   │   ├── Http/Controllers/Api/ # DevController
│   │   ├── Http/Requests/        # StoreDevRequest (validação)
│   │   ├── Http/Resources/       # DevResource
│   │   └── Models/               # Dev (UUID, PostgresArray)
│   ├── database/migrations/
│   ├── routes/api.php
│   └── Dockerfile
└── mobile/              # App Flutter
    └── lib/
        ├── core/
        │   ├── errors/       # Exceções tipadas (ApiException…)
        │   ├── network/      # DioClient (interceptors)
        │   └── theme/        # AppTheme Material 3
        ├── features/devs/
        │   ├── data/         # Dev model (Freezed), DevRepository
        │   └── presentation/
        │       ├── pages/    # DevsListPage · DevDetailPage · DevCreatePage
        │       ├── providers/# Riverpod providers
        │       └── widgets/  # DevCard · DevAvatar · DateScrollPicker
        └── routing/          # GoRouter
```

---

## Correr o projeto

### Pré-requisitos

Tudo corre em Docker.

---

### Iniciar com Docker

As imagens estão publicadas no Docker Hub.

```bash
git clone https://github.com/Vasco-a-cards/desafio-fullstack.git
cd desafio-fullstack

# Puxa as imagens (API + Frontend + PostgreSQL) e inicia os 3 serviços
docker compose up -d

# Cria as tabelas e popula com dados de exemplo
docker exec dynamik-app-1 php artisan migrate --seed
```

| Serviço | URL |
|---------|-----|
| **Frontend** (Flutter web) | http://localhost:3000 |
| **API** (Laravel) | http://localhost:8000 |

#### Imagens Docker Hub

| Imagem | Descrição |
|--------|-----------|
| `vsk0/dynamik-devs-api:latest` | API Laravel + PHP 8.3 |
| `vsk0/dynamik-devs-frontend:latest` | Flutter web servido por Nginx |

---

### API

| Método | Rota | Descrição |
|--------|------|-----------|
| `GET` | `/devs` | Lista paginada · header `X-Total-Count` |
| `GET` | `/devs?terms=query` | Pesquisa por nome, nickname ou stack |
| `GET` | `/devs/{uuid}` | Detalhe de um dev |
| `POST` | `/devs` | Criar dev |

---

## Funcionalidades

### Backend

- **UUID** como chave primária gerado pelo PostgreSQL
- Campo **`stack`** como array nativo PostgreSQL com cast automático no Eloquent
- **Pesquisa por trigrama** (`pg_trgm`) com índice GIN, tolerante a acentos via `unaccent`
- Validação com `FormRequest` — nickname único, datas válidas, limites de caracteres
- **Action pattern** (`CreateDevAction`) para isolar a lógica de criação
- `DevResource` para serialização consistente (`birth_date` em snake_case)
- Header `X-Total-Count` na listagem para paginação no cliente
- CORS configurado com `X-Total-Count` e `Location` expostos

### Mobile

- **Material 3** com paleta azul/teal personalizada, light e dark mode
- **Lista** com contador total, pesquisa com debounce (380 ms) e pull-to-refresh
- **Detalhe do dev** com Hero animation no avatar, skeleton shimmer durante loading, idade calculada, stack em chips, estado 404 dedicado
- **Criar dev** com validação client-side espelhando o backend:
  - Erros inline por campo nas respostas 422 (incluindo "Este nickname já existe")
  - Snackbar para erros 400 e falhas de rede
  - Picker de data com scroll nativo (dia | mês em PT | ano), sem dependências externas
- Tratamento de erros tipado (`BadRequestException`, `NotFoundException`, `ValidationException`)
- Logging de requests/responses activo apenas em modo debug

### Principais bibliotecas Flutter

| Biblioteca | Uso |
|-----------|-----|
| `flutter_riverpod` | State management |
| `go_router` | Navegação declarativa |
| `dio` | Cliente HTTP com interceptors |
| `freezed` + `json_serializable` | Modelos imutáveis e serialização JSON |
| `intl` | Formatação de datas |

---

## Notas

- O seed inclui 5 devs de exemplo prontos a usar na listagem e na pesquisa.
- A pesquisa é feita no servidor com `ILIKE` + `unaccent` — não é sensível a maiúsculas nem acentos.
- A data de nascimento é sempre enviada à API em `YYYY-MM-DD` e apresentada na app em `DD/MM/YYYY`.
