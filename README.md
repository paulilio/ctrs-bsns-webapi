# Projeto Controllership Bussiness DataBase Doc

Para criação do banco de dados em ambiente de desenvolvimento, basta acessar o mysql, com usuário root e executar as rotinas na seguinte ordem:
1-create_database
2-create_tables
3-apoio_cargainicial

## Módulo Importação

### proc_ImportCSV

Importação das tabela principais do sistema.
~~co_faturamento~~
co_conta_receber
co_conta_pagar
co_inadimplente
co_banco
~~co_estoque~~

Obs.: Desativada.
Em processo de desativação, pois as rotinas de importação ficaram mais complexas.
Agora cada importação será tratada de modo direcionado. Últimas migrações:
- setImportFaturamento
- setImportEntradaEstoque

### setImportFaturamento

Os dados são importados de um s[o arquivo csv, contendo os campos para alimentar as tabelas na seguinte sequência:
1-Insert na tabela temporária tp_import_csv, com todos os dados csv. 
    Observe que os campos todos são descrição. Isso acontece por conta da limitação de imnportação baseada em Json.
2-Insert na tabela 


## Módulo Situação Atual

## Geral - Funções

## How to Initialize Fake Server (Json-Server)

In the API folder, run the command 

```
json-server --watch banco.json
```

## How to initialize Interface VueJs

nside the client-vue folder, check the existence of the node_modules folder.
This folder is not stored in the git repository.
If necessary, install the modules.

```
npm install
npm audit fix
```

To initialize the project, run the command:

```
npm run serve -- --mode modelo
```

##  How to initialize webAPI

In the server-aspnet folder, run the command

```
dotnet build
dotnet run
```