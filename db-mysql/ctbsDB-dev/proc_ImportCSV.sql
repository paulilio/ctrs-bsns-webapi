USE `ctbsDB_dev`;
DROP procedure IF EXISTS `ctbsDB_dev`.`proc_ImportCSV`;

DELIMITER $$
USE `ctbsDB_dev` $$	
CREATE PROCEDURE `proc_ImportCSV`(
  IN p_json LONGTEXT, 
  IN p_dsNomeArquivo VARCHAR(50), 
  IN p_IdEmpresa INT,
  IN p_idUsuario INT,
  IN p_cdTipoImp VARCHAR(1),
  OUT result longtext)
BEGIN

DECLARE v_dtImport TIMESTAMP;
DECLARE v_idcarga INT;
DECLARE v_TipoTabela VARCHAR(50);
DECLARE v_UsaCampoBanco INT DEFAULT 0;

DECLARE nRowsAffected INT; 
-- DECLARE `_rollback` BOOL DEFAULT 0;
-- DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
ROLLBACK;
END; 

/*
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN 
	-- SET @full_error = "";
	-- ROLLBACK;
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
    -- SET @full_error = "";
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
    -- SELECT @full_error;
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));    
    -- SELECT @full_error;
END;
*/

START TRANSACTION;

SELECT current_timestamp() INTO v_dtImport FROM DUAL;

insert into
    `ctbsdb_dev`.`co_import_csv`(
    idUsuario
   ,idEmpresa
   ,cdTipoImport     
   ,dsNomeArquivo     
   ,dtImport
   ,dsCpfCnpjCliente  
   ,dsNomeCliente
   ,dsCodigoInterno   
   ,dsDataEmissao     
   ,dsDataVencimento  
   ,dsDataPagamento 
   ,dsFormaPagamento
   ,dsValor           
   ,dsNatureza        
   ,dsContaContabil   
   ,dsUnidadeNegocio  
   ,dsCentroCusto   
   ,dsBanco           
    )
SELECT
    p_idUsuario      
   ,p_idEmpresa
   ,p_cdTipoImp      
   ,p_dsNomeArquivo     
   ,v_dtImport   
   ,tt.descCpfCnpjCliente  
   ,tt.descNomeCliente
   ,tt.descCodigoInterno   
   ,tt.descDataEmissao     
   ,tt.descDataVencimento  
   ,tt.descDataPagamento 
   ,tt.descFormaPagamento
   ,tt.descValor           
   ,tt.descNatureza        
   ,tt.descContaContabil   
   ,tt.descUnidadeNegocio  
   ,tt.descCentroCusto   
   ,tt.descBanco   
FROM
    JSON_TABLE(
        p_json,
        "$[*]" COLUMNS(
            descCpfCnpjCliente VARCHAR(20) PATH '$."descCpfCnpjCliente"' NULL ON EMPTY,
            descNomeCliente VARCHAR(120) PATH '$."descNomeCliente"' NULL ON EMPTY,
            descCodigoInterno VARCHAR(20) PATH '$."descCodigoInterno"' NULL ON EMPTY,
            descDataEmissao VARCHAR(20) PATH '$."descDataEmissao"' NULL ON EMPTY,
            descDataVencimento VARCHAR(20) PATH '$."descDataVencimento"' NULL ON EMPTY,
            descDataPagamento VARCHAR(20) PATH '$."descDataPagamento"' NULL ON EMPTY,
            descFormaPagamento VARCHAR(50) PATH '$."descFormaPagamento"' NULL ON EMPTY,
            descValor VARCHAR(20) PATH '$."descValor"' NULL ON EMPTY,
            descNatureza VARCHAR(50) PATH '$."descNatureza"' NULL ON EMPTY,
            descContaContabil VARCHAR(50) PATH '$."descContaContabil"' NULL ON EMPTY,
            descUnidadeNegocio VARCHAR(50) PATH '$."descUnidadeNegocio"' NULL ON EMPTY,
            descCentroCusto VARCHAR(50) PATH '$."descCentroCusto"' NULL ON EMPTY,
            descBanco VARCHAR(50) PATH '$."descBanco"' NULL ON EMPTY
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
    ,p_cdTipoImp  
    ,p_dsNomeArquivo     
    ,v_dtImport
    FROM DUAL;

/*VERIFICA DUPLICIDADE?*/
/*INSERIR NAS TABELAS DEFINITIVAS? OU SOMENTE AO FINALIZAR O PASSO?!*/

SELECT LAST_INSERT_ID() INTO v_idcarga FROM ctbsdb_dev.co_carga;
CASE p_cdTipoImp
    WHEN  'F' THEN
        SET v_TipoTabela =  'ctbsdb_dev.co_faturamento';
    WHEN  'R' THEN
        SET v_TipoTabela =  'ctbsdb_dev.co_conta_receber';
    WHEN  'P' THEN
        SET v_TipoTabela =  'ctbsdb_dev.co_conta_pagar';
    WHEN  'I' THEN
        SET v_TipoTabela =  'ctbsdb_dev.co_inadimplentes';
    WHEN 'B' THEN
        SET v_TipoTabela = 'ctbsdb_dev.co_banco';
        SET v_UsaCampoBanco = 1;
    #ELSE
        #SET pShipping = '5-day Shipping';
END CASE;

SET @SQLText = CONCAT(
 'INSERT INTO '
,v_TipoTabela
,' (idCarga'
,',dsCpfCnpjCliente'
,',dsNomeCliente'
,',dsCodigoInterno'
,',dtDataEmissao'
,',dtDataVencimento'
,',dtDataPagamento'
,',dsFormaPagamento'
,',vlValor'
,',dsNatureza'
,',dsContaContabil'
,',dsUnidadeNegocio'
,',dsCentroCusto'
,CASE WHEN v_UsaCampoBanco = 1 THEN ',dsBanco' ELSE '' END
,')'
,' SELECT '
,v_idCarga
,',dsCpfCnpjCliente '
,',dsNomeCliente '
,',dsCodigoInterno '   
,',STR_TO_DATE(dsDataEmissao, ''%d/%m/%Y'') dtDataEmissao'
,',STR_TO_DATE(dsDataVencimento, ''%d/%m/%Y'') dtDataVencimento'
,',STR_TO_DATE(dsDataPagamento, ''%d/%m/%Y'') dtDataPagamento'
,',dsFormaPagamento ' 
,',ExtractDecimal(dsValor) vlValor'
,',dsNatureza '
,',dsContaContabil '
,',dsUnidadeNegocio ' 
,',dsCentroCusto '
,CASE WHEN v_UsaCampoBanco = 1 THEN ',dsBanco' ELSE '' END
,' FROM `ctbsdb_dev`.`co_import_csv` i '
,' WHERE '
,' i.idUsuario = ', p_idUsuario
,' AND i.idEmpresa = ', p_idEmpresa
,' AND i.dtImport = ''', v_dtImport,''''
);

/*####DEBUG*/
-- GET DIAGNOSTICS nRowsAffected = ROW_COUNT;
-- COMMIT;
-- SET result := (select JSON_OBJECT("status", 200, "result", @SQLText));   
-- SIGNAL SQLSTATE '45000'
-- SET MESSAGE_TEXT = "";

PREPARE stmt FROM @SQLText;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- GET DIAGNOSTICS nRowsAffected = ROW_COUNT;
COMMIT;
SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    

/*
IF `_rollback` THEN
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
	-- SET result := (select JSON_OBJECT("status", 500, "result", CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text)));    
    -- SELECT @full_error;
    ROLLBACK;
ELSE
	GET DIAGNOSTICS nRowsAffected = ROW_COUNT;
    COMMIT;
	SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    
END IF;

*/


END $$
DELIMITER ;

/* TEST PROC
CALL `ctbsdb_dev`.`proc_ImportCSV`('[ { "uid": 0, "descNomeCliente": "Joao", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 1, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 2, "descNomeCliente": "Joao", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 4.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "1" }, { "uid": 3, "descNomeCliente": "Maria", "descDataLancamento": "3/4/2020", "descDataVencimento": "3/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 2.000,00 ", "descNatureza": "", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "2" }, { "uid": 4, "descNomeCliente": "Daniel", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 2.500,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "3" }, { "uid": 5, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 6, "descNomeCliente": "Paulilio", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/6/2020", "descFormaPagamento": "Cartão Credito", "descValor": " R$ 3.240,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "4" }, { "uid": 7, "descNomeCliente": "Gustavo", "descDataLancamento": "14/4/2020", "descDataVencimento": "14/5/2020", "descFormaPagamento": "Boleto", "descValor": " R$ 1.234,00 ", "descNatureza": " ", "descContaContabil": "", "descUnidadeNegocio": "Goiânia", "descCentoReceitas": "Marista", "descCodigoInterno": "5" } ]', 'teste.csv', 1, 1, 'F', @test);
SELECT @test as t;
*/

/* VERIFICA
delete from ctbsdb_dev.co_faturamento;
delete from ctbsdb_dev.co_carga;
delete from  ctbsdb_dev.co_import_csv;

select * from ctbsdb_dev.co_import_csv
select * from ctbsdb_dev.co_carga;
select * from  ctbsdb_dev.co_import_csv;
*/