# APITaskList

API REST para gerenciamento de tarefas desenvolvida em Delphi 10.2.3.

## Visao geral

O projeto expoe uma API HTTP para cadastro, consulta, atualizacao e exclusao de tarefas.
A aplicacao usa Horse como servidor web, GBSwagger para documentacao e GBJSON para serializacao e desserializacao dos objetos.

## Arquitetura

A aplicacao esta organizada em camadas:

- `server.pas`: bootstrap do servidor, middlewares globais e inicializacao da aplicacao.
- `src/api/route`: registro das rotas publicadas no Horse/GBSwagger.
- `src/task/controller`: camada HTTP, responsavel por receber request, validar entrada de rota/query/body e devolver response HTTP.
- `src/task/service`: camada de servico, responsavel por regras de negocio e validacoes de create, update, delete e leitura.
- `src/task/repository`: camada de persistencia, responsavel pelo SQL e mapeamento entre dataset e objetos.
- `src/database`: factories e abstracoes de conexao/query com FireDAC.
- `src/config`: configuracao de banco e Swagger.
- `src/task/types`: DTOs, entidades e tipos auxiliares do dominio.

Fluxo principal:

1. O Horse recebe a requisicao.
2. O controller interpreta parametros de rota, query string e body.
3. O service aplica validacoes e regras de negocio.
4. O repository executa o acesso ao banco.
5. O controller devolve o objeto serializado na resposta HTTP.

## Versao do Delphi

- Delphi 10.2.3

## Dependencias

Dependencias declaradas em `boss.json`:

- `github.com/hashload/horse` `^3.2.0`
- `github.com/hashload/horse-cors` `^1.0.7`
- `github.com/hashload/jhonson` `^1.2.1`
- `https://github.com/willder-root/gbjson` `^1.0.1`
- `https://github.com/willder-root/gbswagger` `^1.0.1`

Dependencias de runtime e plataforma:

- FireDAC
- Firebird
- `fbclient.dll` configurada via `config.ini`

## Configuracao

O projeto le um arquivo `config.ini` no mesmo diretorio do executavel.

Exemplo:

```ini
[DB]
HOST=localhost
PATH=C:\dados\APITASKLIST.FDB
USER=SYSDBA
PASS=masterkey
VENDORLIB=C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll
```

Chaves esperadas:

- `HOST`
- `PATH`
- `USER`
- `PASS`
- `VENDORLIB`

## Execucao

A API sobe na porta `4040`.

Configuracoes aplicadas na inicializacao:

- CORS habilitado
- middleware JSON via Jhonson
- middleware Swagger via GBSwagger
- formatacao de data do GBJSON em `dd/mm/yyyy hh:mm:ss`
- locale de data do GBJSON em `pt-BR`



## Base da API

```text
http://localhost:4040/v1
```

O `BasePath` configurado no Swagger e `v1`.

## Rotas

### Buscar tarefa por id

```http
GET /v1/Task/{id}
```

Resposta:

- `200 OK` quando encontrar a tarefa
- `404 Not Found` quando a tarefa nao existir
- `400 Bad Request` quando o `id` for invalido

### Listar tarefas

```http
GET /v1/Task/List
```

Query params suportados:

- `Title`: filtro por titulo
- `DateStart`: filtro por data, obrigatorio no formato `dd/mm/yyyy`
- `Status`: filtro por status, com valores `PENDING` ou `FINISH`

Exemplo:

```http
GET /v1/Task/List?Title=Delphi&DateStart=04/04/2026&Status=PENDING
```

Resposta:

- `200 OK`
- `400 Bad Request` para data invalida ou status invalido

Observacao:

- o filtro `DateStart` pesquisa o intervalo do dia entre `00:01` e `23:59` no repository

### Criar tarefa

```http
POST /v1/Task
Content-Type: application/json
```

Exemplo de body:

```json
{
  "title": "Nova tarefa",
  "startedAt": "04/04/2026 08:00:00",
  "finishedAt": "04/04/2026 18:00:00",
  "status": "PENDING"
}
```

Regras atuais de validacao:

- `Title` obrigatorio
- `StartedAt` obrigatorio
- `Status` obrigatorio

Resposta:

- `201 Created`
- `400 Bad Request` para payload invalido

### Atualizar tarefa

```http
PUT /v1/Task/{id}
Content-Type: application/json
```

Exemplo de body:

```json
{
  "title": "Tarefa atualizada",
  "startedAt": "04/04/2026 08:00:00",
  "finishedAt": "04/04/2026 18:00:00",
  "status": "FINISH"
}
```

Regras atuais de validacao:

- `Title` obrigatorio
- `StartedAt` obrigatorio
- `FinishedAt` obrigatorio
- `Status` obrigatorio

Resposta:

- `200 OK`
- `400 Bad Request` para `id` ou payload invalido
- `404 Not Found` quando a tarefa nao existir

### Excluir tarefa

```http
DELETE /v1/Task/{id}
```

Resposta:

- `200 OK`
- `400 Bad Request` quando o `id` for invalido
- `404 Not Found` quando a tarefa nao existir

## Tipos do dominio

### Status

Os status disponiveis atualmente sao:

- `PENDING`
- `FINISH`

### Datas

No contrato atual:

- `DateStart` da rota `List` deve ser enviado em `dd/mm/yyyy`
- campos de data/hora documentados no Swagger usam `dd/mm/yyyy hh:mm:ss`

## Documentacao Swagger

O projeto usa GBSwagger para publicar a documentacao da API.
O `BasePath` configurado e `v1`, e as rotas sao registradas a partir do `TTaskController`.
