CREATE TABLE IF NOT EXISTS `fnc_import_data` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descDataLancamento VARCHAR(20),
    descCpfCnpjCliente VARCHAR(20),
    descNomeCliente VARCHAR(120),
    descValor VARCHAR(20),
    descDataVencimento VARCHAR(150),
    descDataRecebimento VARCHAR(20),
    descFormaRecebimento VARCHAR(60),
    descUnidadeNegocio VARCHAR(60),
    descPlanoContas VARCHAR(60),
    descCentroReceitas VARCHAR(60),
    descBanco VARCHAR(60),
    descricao VARCHAR(255),
    codigoTipo CHAR(1),
    filename VARCHAR(50),
    importDate timestamp,
    PRIMARY KEY `pk_id`(`id`)
) ENGINE = InnoDB;

ALTER TABLE `fnc_import_data` CHANGE `codigoTipo` `codigoTipo` CHAR(1) COMMENT 'F-Faturamento,C-ContasAPagar,I-Inadimplentes,B-Bancos'  