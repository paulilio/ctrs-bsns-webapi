use ctbsdb_dev;
delimiter $$ 
drop procedure if exists getSituacaoAtualByJsonFields;
create procedure getSituacaoAtualByJsonFields(jsonParams JSON, OUT result longtext) 
BEGIN 
DECLARE _dtStart VARCHAR(10) default null; 
DECLARE _dtEnd  VARCHAR(10) default null; 
DECLARE select_result  longtext default null; 

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
-- ROLLBACK;
END; 

/*
if (jsonParams is not null) then
  set _dtStart = JSON_UNQUOTE(JSON_EXTRACT(jsonParams,'$.dtStart')); 
  set _dtEnd = JSON_UNQUOTE(JSON_EXTRACT(jsonParams,'$.dtEnd')); 
else
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = "Os parâmetros estão vazios.";
end if;
*/

-- if (_dtStart is not null) AND (_dtEnd is not null) then 
	SELECT JSON_ARRAYAGG(
		json_object(
		'idFaturamento', idFaturamento,
		'idCarga', idCarga,
		'dsCpfCnpjCliente', CASE WHEN dsCpfCnpjCliente IS NULL OR dsCpfCnpjCliente = '' THEN 'Não Informado' ELSE dsCpfCnpjCliente END,
		'dsNomeCliente', CASE WHEN dsNomeCliente IS NULL OR dsNomeCliente = '' THEN 'Não Informado' ELSE dsNomeCliente END,
		'dsCodigoInterno', CASE WHEN dsCodigoInterno IS NULL OR dsCodigoInterno = '' THEN 'Não Informado' ELSE dsCodigoInterno END,
		'dtDataEmissao', CASE WHEN dtDataEmissao IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataEmissao, '%d/%m/%Y') END,
		'dtDataVencimento', CASE WHEN dtDataVencimento IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataVencimento, '%d/%m/%Y') END,
		'dtDataRecebimento', CASE WHEN dtDataRecebimento IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataRecebimento, '%d/%m/%Y') END ,
		'dsFormaRecebimento', CASE WHEN dsFormaRecebimento IS NULL OR dsFormaRecebimento = '' THEN 'Não Informado' ELSE dsFormaRecebimento END,
		'vlValor', CASE WHEN vlvalor IS NULL THEN 'Não Informado' ELSE REPLACE(REPLACE(REPLACE(FORMAT( vlvalor,2), '.', '|'), ',', '.'), '|', ',') END,
		'dsNatureza', CASE WHEN dsNatureza IS NULL OR dsNatureza = '' THEN 'Não Informado' ELSE dsNatureza END,
		'dsContaContabil', CASE WHEN dsContaContabil IS NULL OR dsContaContabil = '' THEN 'Não Informado' ELSE dsContaContabil END,
		'dsUnidadeNegocio',CASE WHEN dsUnidadeNegocio IS NULL OR dsUnidadeNegocio = '' THEN 'Não Informado' ELSE dsUnidadeNegocio END ,
		'dsCentroReceita', CASE WHEN dsCentroReceita IS NULL OR dsCentroReceita = '' THEN 'Não Informado' ELSE dsCentroReceita END 
		)
        ) into select_result
	FROM `ctbsdb_dev`.`co_faturamento`
	-- where date_format(str_to_date(dtDataEmissao,'%d/%m/%Y'),'%d/%m/%Y') between date_format(str_to_date(_dtStart,'%d/%m/%Y'),'%d/%m/%Y') AND date_format(str_to_date(_dtEnd,'%d/%m/%Y'),'%d/%m/%Y')
	order by idFaturamento desc;
/*elseif (i_year is not null) AND (i_month is not null) then */
-- else 
--    select null as 'no input'; 
-- end if;  

-- IF `_rollback` THEN
-- 	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));    
-- ELSE
	SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
-- END IF;
  
END $$ 
delimiter ; 
  
-- Testing 
/*
call  getSituacaoAtualByJsonFields('{"dtStart":"01/05/2010","dtEnd": "28/05/2010"}', @test);
SELECT @test as t;
*/
/*
call  getSituacaoAtualByJsonFields(null, @test);
SELECT @test as t;
*/
