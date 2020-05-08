USE `ctbsDB_dev`;

DROP procedure IF EXISTS `ctbsDB_dev`.`proc_ImportCSV`;

DELIMITER // 
USE `ctbsDB_dev` // 
CREATE PROCEDURE `proc_ImportCSV`(
  IN JsonPayload LONGTEXT, 
  IN dsNomeArquivo VARCHAR(50), 
  IN IdEmpresa INT,
  IN idUsuario INT,
  IN cdTipo VARCHAR(1),
  OUT result longtext)
BEGIN
DECLARE nRowsAffected INT; DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

BEGIN 
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
	@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
END;

-- START TRANSACTION;

insert into
    ctbsDB_dev.cb_importacao_temp(
    idUsuario
   ,idEmpresa
   ,cdTipo         
   ,dsNomeArquivo     
   ,dtImportacao      
   ,dsCpfCnpjCliente  
   ,dsNomeCliente
   ,dsCodigoInterno   
   ,dsDataEmissao     
   ,dsDataVencimento  
   ,dsDataRecebimento 
   ,dsFormaRecebimento
   ,vlValor           
   ,dsNatureza        
   ,dsContaContabil   
   ,dsUnidadeNegocio  
   ,dsCentroReceita   
   ,dsBanco           
    )
SELECT
    idUsuario      
   ,idEmpresa
   ,cdTipo        
   ,dsNomeArquivo     
   ,current_timestamp()      
   ,tt.descCpfCnpjCliente  
   ,tt.descNomeCliente
   ,tt.descCodigoInterno   
   ,tt.descDataEmissao     
   ,tt.descDataVencimento  
   ,tt.descDataRecebimento 
   ,tt.descFormaRecebimento
   ,tt.descValor           
   ,tt.descNatureza        
   ,tt.descContaContabil   
   ,tt.descUnidadeNegocio  
   ,tt.descCentroReceita   
   ,tt.descBanco   
FROM
    JSON_TABLE(
        JsonPayload,
        "$[*]" COLUMNS(
            descCpfCnpjCliente VARCHAR(20) PATH '$."descCpfCnpjCliente"' NULL ON EMPTY,
            descNomeCliente VARCHAR(120) PATH '$."descNomeCliente"' NULL ON EMPTY,
            descCodigoInterno VARCHAR(20) PATH '$."descCodigoInterno"' NULL ON EMPTY,
            descDataEmissao VARCHAR(20) PATH '$."descDataEmissao"' NULL ON EMPTY,
            descDataVencimento VARCHAR(20) PATH '$."descDataVencimento"' NULL ON EMPTY,
            descDataRecebimento VARCHAR(20) PATH '$."descDataRecebimento"' NULL ON EMPTY,
            descFormaRecebimento VARCHAR(50) PATH '$."descFormaRecebimento"' NULL ON EMPTY,
            descValor VARCHAR(20) PATH '$."descValor"' NULL ON EMPTY,
            descNatureza VARCHAR(50) PATH '$."descNatureza"' NULL ON EMPTY,
            descContaContabil VARCHAR(50) PATH '$."descContaContabil"' NULL ON EMPTY,
            descUnidadeNegocio VARCHAR(50) PATH '$."descUnidadeNegocio"' NULL ON EMPTY,
            descCentroReceita VARCHAR(50) PATH '$."descCentroReceita"' NULL ON EMPTY,
            descBanco VARCHAR(50) PATH '$."descBanco"' NULL ON EMPTY
        )
    ) AS tt;

-- INSERIR NAS TABELAS DEFINITIVAS? OU SOMENTE AO FINALIZAR O PASSO?!

IF `_rollback` THEN
	ROLLBACK;
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));    
ELSE
	GET DIAGNOSTICS nRowsAffected = ROW_COUNT;
    COMMIT;
	SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    
END IF;

END // 
DELIMITER ;



-- debug:
-- CALL `ctbsdb_dev`.`proc_ImportCSV`('[{ "region": "Sub-Saharan Africa", "country": "Mozambique", "itemType": "Household", "salesChannel": "Offline", "orderPriority": "L", "orderDate": "2/10/2012", "orderID": "665095412", "shipDate": "2/15/2012", "unitsSold": "5367", "unitPrice": "668.27", "unitCost": "502.54", "totalRevenue": "3586605.09", "totalCost": "2697132.18", "totalProfit": "889472.91" } ]', 'teste.csv');