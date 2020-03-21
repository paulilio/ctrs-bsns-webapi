USE `ctbsDB_dev`;

DROP procedure IF EXISTS `ctbsDB_dev`.`fncImportData`;

DELIMITER // 
USE `ctbsDB_dev` // 
CREATE PROCEDURE `fncImportData`(
  IN JsonData LONGTEXT, 
  IN codigoTipo CHAR(1), 
  IN fileName VARCHAR(50), 
  OUT result longtext
)
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
    ctbsDB_dev.fnc_import_data(
        descDataLancamento,
        descCpfCnpjCliente,
        descNomeCliente,
        descValor,
        descDataVencimento,
        descDataRecebimento,
        descFormaRecebimento,
        descUnidadeNegocio,
        descPlanoContas,
        descCentroReceitas,
        descBanco,
        descricao,
        codigoTipo,
        filename,
        importDate
    )
SELECT
  tt.descDataLancamento,
  tt.descCpfCnpjCliente,
  tt.descNomeCliente,
  tt.descValor,
  tt.descDataVencimento,
  tt.descDataRecebimento,
  tt.descFormaRecebimento,
  tt.descUnidadeNegocio,
  tt.descPlanoContas,
  tt.descCentroReceitas,
  tt.descBanco,
  tt.descricao,
  codigoTipo,
  filename,
  current_timestamp()
FROM
    JSON_TABLE(
      JsonData,
      "$[*]" COLUMNS(
        descDataLancamento VARCHAR(20) PATH '$."descDataLancamento"',
        descCpfCnpjCliente VARCHAR(20) PATH '$."descCpfCnpjCliente"',
        descNomeCliente VARCHAR(120) PATH '$."descNomeCliente"',
        descValor VARCHAR(20) PATH '$."descValor"',
        descDataVencimento VARCHAR(150) PATH '$."descDataVencimento"',
        descDataRecebimento VARCHAR(20) PATH '$."descDataRecebimento"',
        descFormaRecebimento VARCHAR(60) PATH '$."descFormaRecebimento"',
        descUnidadeNegocio VARCHAR(60) PATH '$."descUnidadeNegocio"',
        descPlanoContas VARCHAR(60) PATH '$."descPlanoContas"',
        descCentroReceitas VARCHAR(60) PATH '$."descCentroReceitas"',
        descBanco VARCHAR(60) PATH '$."descBanco"',
        descricao VARCHAR(255) PATH '$."descricao"'
      )
    ) AS tt;

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
/*
CALL `ctbsdb_dev`.`fncImportData`('[{ 
  "descDataLancamento": "01/02/2020", 
  "descCpfCnpjCliente": "123.145.687", 
  "descNomeCliente": "Arnold Swwet", 
  "descValor": "145112,12", 
  "descDataVencimento": "07/02/2020", 
  "descDataRecebimento": "07/02/2020", 
  "descFormaRecebimento": "Cheque", 
  "descUnidadeNegocio": "Sede", 
  "descPlanoContas": "Vendas", 
  "descCentroReceitas": "Venda Balcão",
  "descBanco": "", 
  "descricao": "Venda de garagem 105"
   } ]', 'F', 'teste.csv', @test);
select @test
*/