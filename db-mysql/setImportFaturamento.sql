DELIMITER $$
DROP procedure IF EXISTS setImportFaturamento;
CREATE PROCEDURE `setImportFaturamento`(
  IN p_json LONGTEXT, 
  IN p_dsNomeArquivo VARCHAR(50), 
  IN p_IdEmpresa INT,
  IN p_idUsuario INT,
  OUT result longtext)
BEGIN

DECLARE v_dtImport TIMESTAMP;
DECLARE v_idcarga INT;
DECLARE v_idfaturamento INT;
DECLARE nRowsAffected INT; 

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
    SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
    SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
    ROLLBACK;
END;

START TRANSACTION;

    SELECT current_timestamp() INTO v_dtImport FROM DUAL;


    /*CREATE TEMP*/
    DROP TEMPORARY TABLE IF EXISTS tp_import_csv;
    CREATE TEMPORARY TABLE tp_import_csv(
        idImport             int not null auto_increment,
   
        -- Dados Faturamento
        cdPedido             varchar(20),
        dsCpfCnpjCliente     varchar(20),
        dsNomeCliente        varchar(120),
        dtDataEmissao        varchar(20),
        dtDataVencimento     varchar(20),
        dtDataPagamento      varchar(20),
        vlValor              varchar(20),
        dsUnidadeNegocio     varchar(50),
        dsCentroReceita      varchar(50),
        dsFormaPagamento     varchar(50),
        cdPlanoContas        varchar(20),
        dsTipoRecebimento    varchar(50),
        dsNatureza           varchar(50),
        dsTipoCusto          varchar(50),
        dsContaContabil      varchar(50),

        -- Dados Produto
        cdProduto            varchar(12),
        dsProduto            varchar(120),
        dsClassificacao      varchar(120),
        dsTipoCusto          varchar(20),
        vlCusto              varchar(20),
        vlQuantidade         varchar(20),
        
        primary key (idImport)
        );


    /*DADOS TEMP*/
    INSERT INTO tp_import_csv(
        cdPedido
        ,dsCpfCnpjCliente  
        ,dsNomeCliente
        ,dtDataEmissao     
        ,dtDataVencimento  
        ,dtDataPagamento 
        ,dsFormaPagamento
        ,vlValor  
        ,dsUnidadeNegocio  
        ,dsCentroReceita
        ,cdPlanoContas
        ,dsTipoRecebimento
        ,dsNatureza
        ,dsTipoCusto
        ,dsContaContabil   

        ,cdProduto
        ,dsProduto
        ,dsClassificacao
        ,dsTipoCusto
        ,vlCusto
        ,vlQuantidade      
    )
    SELECT
        tt.cdPedido
        ,tt.dsCpfCnpjCliente  
        ,tt.dsNomeCliente
        ,tt.dtDataEmissao     
        ,tt.dtDataVencimento  
        ,tt.dtDataPagamento 
        ,tt.dsFormaPagamento
        ,tt.vlValor  
        ,tt.dsUnidadeNegocio  
        ,tt.dsCentroReceita
        ,tt.cdPlanoContas
        ,tt.dsTipoRecebimento
        ,tt.dsNatureza
        ,tt.dsTipoCusto
        ,tt.dsContaContabil   

        ,tt.cdProduto
        ,tt.dsProduto
        ,tt.dsClassificacao
        ,tt.dsTipoCusto
        ,tt.vlCusto
        ,tt.vlQuantidade  
    FROM
    JSON_TABLE(
        p_json,
        "$[*]" COLUMNS(
            cdPedido VARCHAR(20) PATH '$."cdPedido"' NULL ON EMPTY,
            dsCpfCnpjCliente VARCHAR(20) PATH '$."dsCpfCnpjCliente"' NULL ON EMPTY,
            dsNomeCliente VARCHAR(120) PATH '$."dsNomeCliente"' NULL ON EMPTY,
            dtDataEmissao VARCHAR(20) PATH '$."dtDataEmissao"' NULL ON EMPTY,
            dtDataVencimento VARCHAR(20) PATH '$."dtDataVencimento"' NULL ON EMPTY,
            dtDataPagamento VARCHAR(20) PATH '$."dtDataPagamento"' NULL ON EMPTY,
            descFormaPagamento VARCHAR(50) PATH '$."descFormaPagamento"' NULL ON EMPTY,
            vlValor VARCHAR(20) PATH '$."vlValor"' NULL ON EMPTY,
            dsUnidadeNegocio VARCHAR(50) PATH '$."dsUnidadeNegocio"' NULL ON EMPTY,
            dsCentroReceita VARCHAR(50) PATH '$."dsCentroReceita"' NULL ON EMPTY,
            dsFormaPagamento VARCHAR(50) PATH '$."dsFormaPagamento"' NULL ON EMPTY,
            dsTipoRecebimento VARCHAR(50) PATH '$."dsTipoRecebimento"' NULL ON EMPTY,
            dsNatureza VARCHAR(50) PATH '$."dsNatureza"' NULL ON EMPTY,
            dsTipoCusto VARCHAR(50) PATH '$."dsTipoCusto"' NULL ON EMPTY,
            dsContaContabil VARCHAR(50) PATH '$."dsContaContabil"' NULL ON EMPTY,

            cdProduto VARCHAR(12) PATH '$."cdProduto"' NULL ON EMPTY,
            dsProduto VARCHAR(120) PATH '$."dsProduto"' NULL ON EMPTY,
            dsClassificacao VARCHAR(120) PATH '$."dsClassificacao"' NULL ON EMPTY,
            dsTipoCusto VARCHAR(20) PATH '$."dsTipoCusto"' NULL ON EMPTY,
            vlCusto VARCHAR(20) PATH '$."vlCusto"' NULL ON EMPTY,
            vlQuantidade VARCHAR(20) PATH '$."vlQuantidade"' NULL ON EMPTY
        )
    ) AS tt;
    SELECT ROW_COUNT() INTO nRowsAffected;


    /*DADOS CARGA*/
    INSERT INTO ctbsdb_dev.co_carga
    (
        idUsuario
        ,idEmpresa
        ,cdTipoImport
        ,dsNomeArquivo
        ,dtImport
    )
    SELECT
        p_idUsuario
        ,p_idEmpresa       
        ,'F'  
        ,p_dsNomeArquivo     
        ,v_dtImport
    FROM DUAL;

    SET v_idcarga = last_insert_id();



    /*VERIFICA DUPLICIDADE?*/



    /*DADOS FATURAMENTO*/
    INSERT INTO co_faturamento(
        idCarga
        ,cdPedido
        ,dsCpfCnpjCliente
        ,dsNomeCliente
        ,dtDataEmissao
        ,dtDataVencimento
        ,dtDataPagamento
        ,vlValor
        ,dsUnidadeNegocio
        ,dsCentroCusto    
        ,dsFormaPagamento
        ,cdPlanoContas
        ,dsTiporecebimento
        ,dsNatureza
        ,dsTipoCusto
        ,dsContaContabil
    )
    SELECT 
        v_idCarga
        ,cdPedido
        ,dsCpfCnpjCliente 
        ,dsNomeCliente 
        ,STR_TO_DATE(dsDataEmissao, '%d/%m/%Y') dtDataEmissao
        ,STR_TO_DATE(dsDataVencimento, '%d/%m/%Y') dtDataVencimento
        ,STR_TO_DATE(dsDataPagamento, '%d/%m/%Y') dtDataPagamento
        ,ExtractDecimal(dsValor) vlValor
        ,dsUnidadeNegocio 
        ,dsCentroCusto     
        ,dsFormaPagamento
        ,cdPlanoContas
        ,dsTiporecebimento
        ,dsNatureza
        ,dsTipoCusto
        ,dsContaContabil 
    FROM tp_import_csv i 
    WHERE 1=1
    AND i.idUsuario = p_idUsuario
    AND i.idEmpresa = p_idEmpresa
    AND i.dtImport = v_dtImport;
    SET v_idfaturamento = last_insert_id();


    /*DADOS PRODUTO*/
    INSERT INTO co_produto (
        cdProduto
    ,dsProduto
    ,dsClassificacao
    ,cdTipoUltAtualizacao
    )
    SELECT 
        cdProduto
        ,dsProduto
        ,dsClassificacao 
        ,'F'
    FROM tp_import_csv i 
    WHERE 1=1
    AND i.idUsuario = p_idUsuario
    AND i.idEmpresa = p_idEmpresa
    AND i.dtImport = v_dtImport;


    /*DADOS FATURAMENTO PRODUTO*/
    INSERT INTO co_faturamento_produto(
        idFaturamento
    ,cdProduto
    ,vlCusto
    ,vlQuantidade
    )
    SELECT 
        v_idfaturamento
        ,cdProduto
        ,vlCusto 
        ,vlQuantidade
    FROM tp_import_csv i 
    WHERE 1=1
    AND i.idUsuario = p_idUsuario
    AND i.idEmpresa = p_idEmpresa
    AND i.dtImport = v_dtImport;

COMMIT;
SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    

END $$
DELIMITER ;


/* TEST PROC
CALL `ctbsdb_dev`.`setImportFaturamento`('[ { "uid": 0, "descNomeCliente": "Joao", "Lancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 1, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 2, "descNomeCliente": "Joao", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 3, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 4, "descNomeCliente": "Daniel", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 2.500,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "3" }, { "uid": 5, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 6, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/6/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 7, "descNomeCliente": "Gustavo", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 1.234,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "5" } ]', 'teste.csv', 1, 1, 'F', @test);
SELECT @test as t;
*/

/* VERIFICA
delete from co_faturamento;
delete from co_carga;
delete from co_produto;
delete from co_faturamento_produto;

select * from co_carga;
select * from co_import_csv;
select * from co_produto;
select * from co_faturamento_produto;
*/