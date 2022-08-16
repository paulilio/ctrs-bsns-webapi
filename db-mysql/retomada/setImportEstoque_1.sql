DELIMITER $$
DROP procedure IF EXISTS setImportEstoque$$
CREATE PROCEDURE `setImportEstoque`(
  IN p_json LONGTEXT, 
  IN p_dsNomeArquivo VARCHAR(50), 
  IN p_IdEmpresa INT,
  IN p_idUsuario INT,
  OUT result longtext)
BEGIN

DECLARE v_dtImport TIMESTAMP;
DECLARE v_idcarga INT;
DECLARE v_idEstoque INT;
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

        dtDataCompra         varchar(20),
        dsCpfCnpjFornecedor  varchar(20),
        dsNomeFornecedor         varchar(120),
        dsEstoqueCentral     varchar(50),
        dsUnidadeNegocio     varchar(50),
        dsCentroCusto        varchar(50),

        cdProduto            varchar(12),
        dsProduto            varchar(120),
        dsClassificacao      varchar(120),
        vlValor              varchar(20),
        vlQuantidade         varchar(20),
        vlValorTotal         varchar(20),
        
        primary key (idImport)
        );


    /*DADOS TEMP*/
    INSERT INTO tp_import_csv(
         dtDataCompra     
        ,dsCpfCnpjFornecedor
        ,dsNomeFornecedor  
        ,dsEstoqueCentral
        ,dsUnidadeNegocio 
		,dsCentroCusto        

        ,cdProduto
        ,dsProduto
        ,dsClassificacao
        ,vlValor  
        ,vlQuantidade  
        ,vlValorTotal
    )
    SELECT
         tt.dtDataCompra
        ,tt.dsCpfCnpjFornecedor
        ,tt.dsNomeFornecedor  
        ,tt.dsEstoqueCentral
        ,tt.dsUnidadeNegocio  
		,tt.dsCentroCusto

        ,tt.cdProduto
        ,tt.dsProduto
        ,tt.dsClassificacao
        ,tt.vlValor
        ,tt.vlQuantidade  
        ,tt.vlValorTotal

    FROM
    JSON_TABLE(
        p_json,
        "$[*]" COLUMNS(
			dtDataCompra VARCHAR(20) PATH '$."dtDataCompra"' NULL ON EMPTY,
			dsCpfCnpjFornecedor VARCHAR(20) PATH '$."dsCpfCnpjFornecedor"' NULL ON EMPTY,
            dsNomeFornecedor VARCHAR(120) PATH '$."dsNomeFornecedor"' NULL ON EMPTY,
            dsEstoqueCentral VARCHAR(50) PATH '$."dsEstoqueCentral"' NULL ON EMPTY,
            dsUnidadeNegocio VARCHAR(50) PATH '$."dsUnidadeNegocio"' NULL ON EMPTY,
            dsCentroCusto VARCHAR(50) PATH '$."dsCentroCusto"' NULL ON EMPTY,

            cdProduto VARCHAR(12) PATH '$."cdProduto"' NULL ON EMPTY,
            dsProduto VARCHAR(120) PATH '$."dsProduto"' NULL ON EMPTY,
            dsClassificacao VARCHAR(120) PATH '$."dsClassificacao"' NULL ON EMPTY,
            vlValor VARCHAR(20) PATH '$."vlCusto"' NULL ON EMPTY,
            vlQuantidade VARCHAR(20) PATH '$."vlQuantidade"' NULL ON EMPTY,
            vlValorTotal VARCHAR(20) PATH '$."vlCustoTotal"' NULL ON EMPTY
        )
    ) AS tt;
    SELECT ROW_COUNT() INTO nRowsAffected;


    /*DADOS CARGA*/
    INSERT INTO co_carga
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
        ,'E'  
        ,p_dsNomeArquivo     
        ,v_dtImport
    FROM DUAL;

    SET v_idcarga = last_insert_id();



    /*VERIFICA DUPLICIDADE?*/



    /*DADOS COMPRA ESTOQUE*/
    INSERT INTO co_entrada_estoque(
         idCarga
        ,cdProduto
        ,dsCpfCnpjFornecedor
        ,dsNomeFornecedor
        ,dtDataCompra
        ,vlValor
        ,vlQuantidade
        ,vlValorTotal
        ,dsUnidadeNegocio
        ,dsCentroCusto    
    )
    SELECT 
        v_idCarga
        ,cdProduto
        ,dsCpfCnpjFornecedor 
        ,dsNomeFornecedor 
        ,STR_TO_DATE(dtDataCompra, '%d/%m/%Y') dtDataCompra
        ,ExtractDecimal(vlValor) vlValor
        ,vlQuantidade 
        ,vlValorTotal     
        ,dsUnidadeNegocio
        ,dsCentroCusto
    FROM tp_import_csv i;


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
        ,'E'
    FROM tp_import_csv i
    WHERE i.cdProduto not in (select cdProduto from co_produto);


COMMIT;
SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    

END $$
DELIMITER ;


/* TEST PROC
CALL `setImportEstoque`('[ { "uid": 0, "descNomeCliente": "Joao", "Lancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 1, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 2, "descNomeCliente": "Joao", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 3, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 4, "descNomeCliente": "Daniel", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 2.500,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "3" }, { "uid": 5, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 6, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/6/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 7, "descNomeCliente": "Gustavo", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 1.234,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "5" } ]', 'teste.csv', 1, 1, 'F', @test);
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