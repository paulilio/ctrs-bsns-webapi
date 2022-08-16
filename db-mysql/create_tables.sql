/*==============================================================*/
/* Table: co_banco                                              */
/*==============================================================*/
create table co_banco
(
   idBanco              int not null auto_increment  comment '',
   idCarga              int not null  comment '',
   dsCpfCnpjCliente     varchar(20)  comment '',
   dsNomeCliente        varchar(120)  comment '',
   dsCodigoInterno      varchar(20)  comment '',
   dtDataEmissao        datetime  comment '',
   dtDataVencimento     datetime  comment '',
   dtDataPagamento      datetime  comment '',
   dsFormaPagamento     varchar(50)  comment '',
   vlValor              decimal(20,2)  comment '',
   dsNatureza           varchar(50)  comment '',
   dsContaContabil      varchar(50)  comment '',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroCusto        varchar(50)  comment '',
   dsBanco              varchar(50)  comment '',
   primary key (idBanco)
);

/*==============================================================*/
/* Table: co_carga                                              */
/*==============================================================*/
create table co_carga
(
   idCarga              int not null auto_increment  comment '',
   idUsuario            int not null  comment '',
   idEmpresa            int not null  comment '',
   dsNomeArquivo        varchar(50) not null  comment '',
   cdTipoImport         char(1)  comment '',
   dtImport             timestamp not null  comment '',
   primary key (idCarga)
);

/*==============================================================*/
/* Table: co_conta_pagar                                        */
/*==============================================================*/
create table co_conta_pagar
(
   idContaPagar         int not null auto_increment  comment '',
   idCarga              int  comment '',
   dsCpfCnpjCliente     varchar(20)  comment '',
   dsNomeCliente        varchar(120)  comment '',
   dsCodigoInterno      varchar(20)  comment '',
   dtDataEmissao        datetime  comment '',
   dtDataVencimento     datetime  comment '',
   dtDataPagamento      datetime  comment '',
   dsFormaPagamento     varchar(50)  comment '',
   vlValor              decimal(20,2)  comment '',
   dsNatureza           varchar(50)  comment '',
   dsContaContabil      varchar(50)  comment '',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroCusto        varchar(50)  comment '',
   primary key (idContaPagar)
);

/*==============================================================*/
/* Table: co_conta_receber                                      */
/*==============================================================*/
create table co_conta_receber
(
   idContaReceber       int not null auto_increment  comment '',
   idCarga              int not null  comment '',
   dsCpfCnpjCliente     varchar(20)  comment '',
   dsNomeCliente        varchar(120)  comment '',
   dsCodigoInterno      varchar(20)  comment '',
   dtDataEmissao        datetime  comment '',
   dtDataVencimento     datetime  comment '',
   dtDataPagamento      datetime  comment '',
   dsFormaPagamento     varchar(50)  comment '',
   vlValor              decimal(20,2)  comment '',
   dsNatureza           varchar(50)  comment '',
   dsContaContabil      varchar(50)  comment '',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroCusto        varchar(50)  comment '',
   primary key (idContaReceber)
);

/*==============================================================*/
/* Table: co_empresa                                            */
/*==============================================================*/
create table co_empresa
(
   idEmpresa            int not null auto_increment  comment '',
   dsCpfCnpj            varchar(20)  comment '',
   dsNomeOficial        varchar(120)  comment '',
   dsNomeFicticio       varchar(120)  comment '',
   primary key (idEmpresa)
);

/*==============================================================*/
/* Table: co_entrada_estoque                                    */
/*==============================================================*/
create table co_entrada_estoque
(
   idEntradaEstoque     int not null auto_increment  comment '',
   idCarga              int  comment '',
   idProduto            int  comment 'Codigo do produto do cliente',
   idEmpresa            int  comment '',
   dsCpfCNPJFornecedor  varchar(20)  comment '',
   dsNomeFornecedor     varchar(120)  comment '',
   dtDataCompra         datetime not null  comment '',
   vlValor              decimal(20,2) not null  comment '',
   vlQuantidade         decimal(12,0) not null  comment '',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroCusto        varchar(50)  comment '',
   vlValorTotal         decimal(20,2) not null  comment '',
   primary key (idEntradaEstoque)
);

/*==============================================================*/
/* Table: co_faturamento                                        */
/*==============================================================*/
create table co_faturamento
(
   idFaturamento        int not null auto_increment  comment '',
   idEmpresa            int not null  comment '',
   idCarga              int not null  comment '',
   cdCodigoInterno      int  comment '',
   dsCpfCnpjCliente     varchar(20)  comment '',
   dsNomeCliente        varchar(120)  comment '',
   dtDataEmissao        datetime  comment '',
   dtDataVencimento     datetime  comment '',
   dtDataPagamento      datetime  comment '',
   vlValor              decimal(20,2)  comment 'valor do faturamento',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroReceita      varchar(50)  comment '',
   dsFormaPagamento     varchar(50)  comment '',
   cdPlanoContas        varchar(20)  comment '',
   dsTipoRecebimento    varchar(50)  comment 'Parte do plano de contas',
   dsNatureza           varchar(50)  comment 'Parte do plano de contas',
   dsTipoCusto          varchar(50)  comment 'Parte do plano de contas',
   dsContaContabil      varchar(50)  comment 'Parte do plano de contas',
   primary key (idFaturamento, idEmpresa)
);

/*==============================================================*/
/* Table: co_faturamento_produto                                */
/*==============================================================*/
create table co_faturamento_produto
(
   idFaturaProduto      int not null auto_increment  comment '',
   idFaturamento        int not null  comment '',
   idEmpresaFat         int not null  comment '',
   idProduto            int  comment 'Codigo do produto do cliente',
   idEmpresaPro         int  comment '',
   dsProduto            varchar(120)  comment '',
   dsClassificacao      varchar(120)  comment '',
   vlCusto              decimal(20,2)  comment '',
   vlQuantidade         decimal(12)  comment '',
   primary key (idFaturaProduto)
);

/*==============================================================*/
/* Table: co_grupo_acesso                                       */
/*==============================================================*/
create table co_grupo_acesso
(
   idGrupoAcesso        int not null auto_increment  comment '',
   idUsuario            int  comment '',
   dsDescricao          varchar(50)  comment '',
   primary key (idGrupoAcesso)
);

/*==============================================================*/
/* Table: co_import_csv                                         */
/*==============================================================*/
create table co_import_csv
(
   idImport             int not null auto_increment  comment '',
   idUsuario            int not null  comment '',
   idEmpresa            int not null  comment '',
   cdTipoImport         char(1) not null  comment 'F-Faturamento;R-ContasReceber;P-ContasPagar;I-Inadimplentes;B-Bancos',
   dsNomeArquivo        varchar(50) not null  comment '',
   dtImport             timestamp not null  comment '',
   dsCpfCnpjCliente     varchar(20)  comment '',
   dsNomeCliente        varchar(120)  comment '',
   dsCodigoInterno      varchar(20)  comment '',
   dsDataEmissao        varchar(20)  comment '',
   dsDataVencimento     varchar(20)  comment '',
   dsDataPagamento      varchar(20)  comment '',
   dsFormaPagamento     varchar(50)  comment '',
   dsValor              varchar(20)  comment '',
   dsNatureza           varchar(50)  comment '',
   dsContaContabil      varchar(50)  comment '',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroCusto        varchar(50)  comment '',
   dsBanco              varchar(50)  comment '',
   primary key (idImport)
);

/*==============================================================*/
/* Table: co_inadimplente                                       */
/*==============================================================*/
create table co_inadimplente
(
   idInadimplente       int not null auto_increment  comment '',
   idCarga              int not null  comment '',
   dsCpfCnpjCliente     varchar(20)  comment '',
   dsNomeCliente        varchar(120)  comment '',
   dsCodigoInterno      varchar(20)  comment '',
   dtDataEmissao        datetime  comment '',
   dtDataVencimento     datetime  comment '',
   dtDataPagamento      datetime  comment '',
   dsFormaPagamento     varchar(50)  comment '',
   vlValor              decimal(20,2)  comment '',
   dsNatureza           varchar(50)  comment '',
   dsContaContabil      varchar(50)  comment '',
   dsUnidadeNegocio     varchar(50)  comment '',
   dsCentroCusto        varchar(50)  comment '',
   primary key (idInadimplente)
);

/*==============================================================*/
/* Table: co_menu                                               */
/*==============================================================*/
create table co_menu
(
   idMenu               int not null auto_increment  comment '',
   idMenuPai            int  comment '',
   dsDescricao          varchar(50)  comment '',
   dsUrl                varchar(150)  comment '',
   primary key (idMenu)
);

/*==============================================================*/
/* Table: co_operacao                                           */
/*==============================================================*/
create table co_operacao
(
   idOperacao           int not null auto_increment  comment '',
   dsDescricao          varchar(50)  comment '',
   chIncluir            char(1)  comment '',
   chAlterar            char(1)  comment '',
   chExcluir            char(1)  comment '',
   chVisualizar         char(1)  comment '',
   primary key (idOperacao)
);

/*==============================================================*/
/* Table: co_permissao_acesso                                   */
/*==============================================================*/
create table co_permissao_acesso
(
   idPermissaoAcesso    int not null auto_increment  comment '',
   idGrupoAcesso        int  comment '',
   idUsuario            int  comment '',
   idMenu               int  comment '',
   chSituacao           char(1)  comment 'A-Ativo;I-Inativo',
   primary key (idPermissaoAcesso)
);

/*==============================================================*/
/* Table: co_permissao_operacao                                 */
/*==============================================================*/
create table co_permissao_operacao
(
   idPermissaoOperacao  int not null auto_increment  comment '',
   idOperacao           int  comment '',
   idPermissao          int  comment '',
   primary key (idPermissaoOperacao)
);

/*==============================================================*/
/* Table: co_produto                                            */
/*==============================================================*/
create table co_produto
(
   idProduto            int not null auto_increment  comment 'Codigo do produto do cliente',
   idEmpresa            int not null  comment '',
   idProdutoInterno     int  comment '',
   dsProduto            varchar(120)  comment '',
   dsClassificacao      varchar(120)  comment '',
   cdTipoUltAtualizacao varchar(1)  comment 'C-Cadastro;F-Faturamento;E-Entrada de EStoque',
   primary key (idProduto, idEmpresa)
);

/*==============================================================*/
/* Table: co_usuario                                            */
/*==============================================================*/
create table co_usuario
(
   idUsuario            int not null auto_increment  comment '',
   dsLogin              varchar(50) not null  comment '',
   dsSenha              varchar(50) not null  comment '',
   dtUltimoAcesso       datetime  comment '',
   dsEmail              varchar(50) not null  comment '',
   chSituacao           char(1) not null  comment 'A-Ativo;I-Inativo',
   chAdmin              char(1) not null  comment 'A-Administrador;C-UsuarioComum',
   primary key (idUsuario)
);

/*==============================================================*/
/* Table: co_usuario_empresa                                    */
/*==============================================================*/
create table co_usuario_empresa
(
   idEmpresa            int  comment '',
   idUsuario            int  comment ''
);

alter table co_banco add constraint FK_CO_BANCO_REFERENCE_CO_CARGA foreign key (idCarga)
      references co_carga (idCarga) on delete restrict on update restrict;

alter table co_carga add constraint FK_CO_CARGA_REFERENCE_CO_EMPRE foreign key (idEmpresa)
      references co_empresa (idEmpresa) on delete restrict on update restrict;

alter table co_carga add constraint FK_CO_CARGA_REFERENCE_CO_USUAR foreign key (idUsuario)
      references co_usuario (idUsuario) on delete restrict on update restrict;

alter table co_conta_pagar add constraint FK_CO_CONTAPG_REFERENCE_CO_CARGA foreign key (idCarga)
      references co_carga (idCarga) on delete restrict on update restrict;

alter table co_conta_receber add constraint FK_CO_CONTA_REFERENCE_CO_CARGA foreign key (idCarga)
      references co_carga (idCarga) on delete restrict on update restrict;

alter table co_entrada_estoque add constraint FK_CO_ENTRA_REFERENCE_CO_CARGA foreign key (idCarga)
      references co_carga (idCarga) on delete restrict on update restrict;

alter table co_entrada_estoque add constraint FK_CO_ENTRA_REFERENCE_CO_PRODU foreign key (idProduto, idEmpresa)
      references co_produto (idProduto, idEmpresa) on delete restrict on update restrict;

alter table co_faturamento add constraint FK_CO_FATUR_REFERENCE_CO_CARGA foreign key (idCarga)
      references co_carga (idCarga) on delete restrict on update restrict;

alter table co_faturamento add constraint FK_CO_FATUR_REFERENCE_CO_EMPRE foreign key (idEmpresa)
      references co_empresa (idEmpresa) on delete restrict on update restrict;

alter table co_faturamento_produto add constraint FK_CO_FATUR_REFERENCE_CO_FATUR foreign key (idFaturamento, idEmpresaFat)
      references co_faturamento (idFaturamento, idEmpresa) on delete restrict on update restrict;

alter table co_faturamento_produto add constraint FK_CO_FATUR_REFERENCE_CO_PRODU foreign key (idProduto, idEmpresaPro)
      references co_produto (idProduto, idEmpresa) on delete restrict on update restrict;

alter table co_grupo_acesso add constraint FK_CO_GRUPO_REFERENCE_CO_USUAR foreign key (idUsuario)
      references co_usuario (idUsuario) on delete restrict on update restrict;

alter table co_import_csv add constraint FK_CO_IMPOR_REFERENCE_CO_EMPRE foreign key (idEmpresa)
      references co_empresa (idEmpresa) on delete restrict on update restrict;

alter table co_import_csv add constraint FK_CO_IMPOR_REFERENCE_CO_USUAR foreign key (idUsuario)
      references co_usuario (idUsuario) on delete restrict on update restrict;

alter table co_inadimplente add constraint FK_CO_INADI_REFERENCE_CO_CARGA foreign key (idCarga)
      references co_carga (idCarga) on delete restrict on update restrict;

alter table co_menu add constraint FK_CO_MENU_REFERENCE_CO_MENU foreign key (idMenuPai)
      references co_menu (idMenu) on delete restrict on update restrict;

alter table co_permissao_acesso add constraint FK_CO_PERMI_REFERENCE_CO_GRUPO foreign key (idGrupoAcesso)
      references co_grupo_acesso (idGrupoAcesso) on delete restrict on update restrict;

alter table co_permissao_acesso add constraint FK_CO_PERMI_REFERENCE_CO_USUAR foreign key (idUsuario)
      references co_usuario (idUsuario) on delete restrict on update restrict;

alter table co_permissao_acesso add constraint FK_CO_PERMI_REFERENCE_CO_MENU foreign key (idMenu)
      references co_menu (idMenu) on delete restrict on update restrict;

alter table co_permissao_operacao add constraint FK_CO_PERMI_REFERENCE_CO_PERMI foreign key (idPermissao)
      references co_permissao_acesso (idPermissaoAcesso) on delete restrict on update restrict;

alter table co_permissao_operacao add constraint FK_CO_PERMI_REFERENCE_CO_OPERA foreign key (idOperacao)
      references co_operacao (idOperacao) on delete restrict on update restrict;

alter table co_produto add constraint FK_CO_PRODU_REFERENCE_CO_EMPRE foreign key (idEmpresa)
      references co_empresa (idEmpresa) on delete restrict on update restrict;

alter table co_usuario_empresa add constraint FK_CO_USUAR_REFERENCE_CO_EMPRE foreign key (idEmpresa)
      references co_empresa (idEmpresa) on delete restrict on update restrict;

alter table co_usuario_empresa add constraint FK_CO_USUAR_REFERENCE_CO_USUAR foreign key (idUsuario)
      references co_usuario (idUsuario) on delete restrict on update restrict;
