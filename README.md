# Projeto Controllership Bussiness WebAPI

## Inicializa SERVER-FAKE (Json-Server)

Na pasta API, executar o comando

```
json-server --watch banco.json
```

## Inicializa Interface

Dentro pasta client-vue, verifique a existencia da pasta node_modules.
Esta pasta não é guardada no repositório git.
Se preciso realiza a instalação dos módulos.

```
npm install
npm audit fix
```

Para inicializar o projeto, execute o comando:

```
npm run serve -- --mode modelo
```

## Inicializa webAPI

Na pasta server-aspnet, executar o comando

```
dotnet build
dotnet run
```