DELIMITER $$
DROP procedure IF EXISTS setImportFaturamento$$
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

		cdCodigoInterno     varchar(20),
        dtDataEmissao        varchar(20),
        dtDataVencimento     varchar(20),
        dsUnidadeNegocio     varchar(50),
        dsCentroReceita      varchar(50),
        dsCpfCnpjCliente     varchar(20),
        dsNomeCliente        varchar(120),
        vlValor              varchar(20),
		dsFormaPagamento     varchar(50),
        
        cdPlanoContas        varchar(20),
        dsTipoRecebimento    varchar(50),
        dsNatureza           varchar(50),
        dsTipoCusto          varchar(50),
        dsContaContabil      varchar(50),

        idProduto    		 varchar(12),
        dsProduto            varchar(120),
        dsClassificacao      varchar(120),
        vlCusto              varchar(20),
        vlQuantidade         varchar(20),
        
        primary key (idImport)
        );


    /*DADOS TEMP*/
    INSERT INTO tp_import_csv(
         dtDataEmissao     
        ,dtDataVencimento  
        ,dsUnidadeNegocio  
        ,dsCentroReceita
        ,cdCodigoInterno
        ,dsCpfCnpjCliente  
        ,dsNomeCliente
        ,vlValor 
		,dsFormaPagamento        
        
        ,cdPlanoContas
        ,dsTipoRecebimento
        ,dsNatureza
		,dsTipoCusto
        ,dsContaContabil   

        ,idProduto
        ,dsProduto
        ,dsClassificacao
        ,vlCusto
        ,vlQuantidade      
    )
    SELECT
         tt.dtDataEmissao
        ,tt.dtDataVencimento
        ,tt.dsUnidadeNegocio  
        ,tt.dsCentroReceita
        ,tt.cdCodigoInterno
        ,tt.dsCpfCnpjCliente  
        ,tt.dsNomeCliente
        ,tt.vlValor  
		,tt.dsTipoRecebimento
        
        ,tt.cdPlanoContas
        ,tt.dsTipoRecebimento
        ,tt.dsNatureza
        ,tt.dsTipoCusto
        ,tt.dsContaContabil   

        ,tt.idProduto
        ,tt.dsProduto
        ,tt.dsClassificacao
        ,tt.vlCusto
        ,tt.vlQuantidade  
    FROM
    JSON_TABLE(
        p_json,
        "$[*]" COLUMNS(
			dtDataEmissao VARCHAR(20) PATH '$."dtDataEmissao"' NULL ON EMPTY,
			dtDataVencimento VARCHAR(20) PATH '$."dtDataVencimento"' NULL ON EMPTY,
            dsUnidadeNegocio VARCHAR(50) PATH '$."dsUnidadeNegocio"' NULL ON EMPTY,
            dsCentroReceita VARCHAR(50) PATH '$."dsCentroReceita"' NULL ON EMPTY,
            cdCodigoInterno VARCHAR(20) PATH '$."cdCodigoInterno"' NULL ON EMPTY,
            dsCpfCnpjCliente VARCHAR(20) PATH '$."dsCpfCnpjCliente"' NULL ON EMPTY,
            dsNomeCliente VARCHAR(120) PATH '$."dsNomeCliente"' NULL ON EMPTY,
            vlValor VARCHAR(20) PATH '$."vlValor"' NULL ON EMPTY,
            
            cdPlanoContas VARCHAR(20) PATH '$."cdPlanoContas"' NULL ON EMPTY,
            dsTipoRecebimento VARCHAR(50) PATH '$."dsTipoRecebimento"' NULL ON EMPTY,
            dsNatureza VARCHAR(50) PATH '$."dsNatureza"' NULL ON EMPTY,
            dsTipoCusto VARCHAR(50) PATH '$."dsTipoCusto"' NULL ON EMPTY,
            dsContaContabil VARCHAR(50) PATH '$."dsContaContabil"' NULL ON EMPTY,

            idProduto VARCHAR(12) PATH '$."idProduto"' NULL ON EMPTY,
            dsProduto VARCHAR(120) PATH '$."dsProduto"' NULL ON EMPTY,
            dsClassificacao VARCHAR(120) PATH '$."dsClassificacao"' NULL ON EMPTY,
            vlCusto VARCHAR(20) PATH '$."vlCusto"' NULL ON EMPTY,
            vlQuantidade VARCHAR(20) PATH '$."vlQuantidade"' NULL ON EMPTY
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
        ,'F'  
        ,p_dsNomeArquivo     
        ,v_dtImport
    FROM DUAL;

    SET v_idcarga = last_insert_id();



    /*VERIFICA DUPLICIDADE?*/



    /*DADOS FATURAMENTO
    Insere todas as ocorrências únicas de uma lista de pedidos faturados, com seus produtos. 
    Para não repetir a ocorrência, usamos distinct sem os campos de produtos.
    O código de faturamento vem da importação.
    */
    INSERT INTO co_faturamento(
         idFaturamento
		,idEmpresa
		,idCarga
        ,cdCodigoInterno
        ,dsCpfCnpjCliente
        ,dsNomeCliente
        ,dtDataEmissao
        ,dtDataVencimento
        ,dtDataPagamento
        ,vlValor
        ,dsUnidadeNegocio
        ,dsCentroReceita
        ,dsFormaPagamento
        ,cdPlanoContas
        ,dsTipoRecebimento
        ,dsNatureza
        ,dsTipoCusto
        ,dsContaContabil
    )
    SELECT DISTINCT
		 cdCodigoInterno
        ,p_idEmpresa
        ,v_idCarga
        ,cdCodigoInterno
        ,dsCpfCnpjCliente 
        ,dsNomeCliente 
        ,STR_TO_DATE(dtDataEmissao, '%d/%m/%Y') dtDataEmissao
        ,STR_TO_DATE(dtDataVencimento, '%d/%m/%Y') dtDataVencimento
        ,NULL dtDataPagamento
        ,ExtractDecimal(vlValor) vlValor
        ,dsUnidadeNegocio 
        ,dsCentroReceita
        ,dsFormaPagamento
        ,cdPlanoContas
        ,dsTiporecebimento
        ,dsNatureza
        ,dsTipoCusto
        ,dsContaContabil 
    FROM tp_import_csv i;


    /*DADOS PRODUTO
    Insere todos os produtos que não existem no sistema.
    Os que já existem, são desconsiderados.
    */
    INSERT INTO co_produto (
	 idProduto
	,idEmpresa
    ,dsProduto
    ,dsClassificacao
    ,cdTipoUltAtualizacao
    )
    SELECT DISTINCT
         idProduto
		,p_idEmpresa
        ,dsProduto
        ,dsClassificacao 
        ,'F'
    FROM tp_import_csv i
    WHERE i.idProduto NOT IN (SELECT idproduto FROM co_produto);


    /*DADOS FATURAMENTO PRODUTO
    Insere a relação faturamento - produto.
    Veja que temos dois campos idEmpresa. Isso acontece por conta da utilização da chave primária composta.
    A tabela Faturamento possui duas chaves primárias. O Mesmo acontece com a tabela Produto.
    */
    INSERT INTO co_faturamento_produto(
         idFaturamento
		,idEmpresaFat
		,idProduto
        ,idEmpresaPro
		,vlCusto
		,vlQuantidade
    )
    SELECT 
         cdCodigoInterno
        ,p_idEmpresa
        ,idProduto
        ,p_idEmpresa
        ,vlCusto 
        ,vlQuantidade
    FROM tp_import_csv i ; 

COMMIT;
SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    

END $$
DELIMITER ;


/* TEST PROC
CALL `setImportFaturamento`('[ { "uid": 0, "descNomeCliente": "Joao", "Lancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 1, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 2, "descNomeCliente": "Joao", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 3, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 4, "descNomeCliente": "Daniel", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 2.500,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "3" }, { "uid": 5, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 6, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/6/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 7, "descNomeCliente": "Gustavo", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 1.234,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "5" } ]', 'teste.csv', 1, 1, 'F', @test);
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