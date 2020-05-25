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

-- SET @jsonstr:='[{"dsUnidadeNegocio":"Goiânia"},{"dsCentroReceita":""},{"dsFormaRecebimento":""},{"dtDataEmissaoMin":"2020-04-03"},{"dtDataEmissaoMax":"2020-04-14"}]';
WITH ftr AS (SELECT 
  JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsUnidadeNegocio'),'[',''),']','')) AS dsUnidadeNegocio
, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsFormaRecebimento'),'[',''),']','')) AS dsFormaRecebimento
, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dtDataEmissaoMin'),'[',''),']','')) AS dtDataEmissaoMin
, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dtDataEmissaoMax'),'[',''),']','')) AS dtDataEmissaoMax
)
SELECT JSON_ARRAYAGG(
	json_object(
	'idFaturamento', co.idFaturamento,
	'idCarga', co.idCarga,
	'dsCpfCnpjCliente', CASE WHEN co.dsCpfCnpjCliente IS NULL OR co.dsCpfCnpjCliente = '' THEN 'Não Informado' ELSE co.dsCpfCnpjCliente END,
	'dsNomeCliente', CASE WHEN co.dsNomeCliente IS NULL OR co.dsNomeCliente = '' THEN 'Não Informado' ELSE co.dsNomeCliente END,
	'dsCodigoInterno', CASE WHEN co.dsCodigoInterno IS NULL OR co.dsCodigoInterno = '' THEN 'Não Informado' ELSE co.dsCodigoInterno END,
	'dtDataEmissao', CASE WHEN co.dtDataEmissao IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(co.dtDataEmissao, '%d/%m/%Y') END,
	'dtDataVencimento', CASE WHEN co.dtDataVencimento IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(co.dtDataVencimento, '%d/%m/%Y') END,
	'dtDataRecebimento', CASE WHEN co.dtDataRecebimento IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(co.dtDataRecebimento, '%d/%m/%Y') END ,
	'dsFormaRecebimento', CASE WHEN co.dsFormaRecebimento IS NULL OR co.dsFormaRecebimento = '' THEN 'Não Informado' ELSE co.dsFormaRecebimento END,
	'vlValor', CASE WHEN co.vlvalor IS NULL THEN 'Não Informado' ELSE REPLACE(REPLACE(REPLACE(FORMAT( co.vlvalor,2), '.', '|'), ',', '.'), '|', ',') END,
	'dsNatureza', CASE WHEN co.dsNatureza IS NULL OR co.dsNatureza = '' THEN 'Não Informado' ELSE dsNatureza END,
	'dsContaContabil', CASE WHEN co.dsContaContabil IS NULL OR co.dsContaContabil = '' THEN 'Não Informado' ELSE co.dsContaContabil END,
	'dsUnidadeNegocio',CASE WHEN co.dsUnidadeNegocio IS NULL OR co.dsUnidadeNegocio = '' THEN 'Não Informado' ELSE co.dsUnidadeNegocio END ,
	'dsCentroReceita', CASE WHEN co.dsCentroReceita IS NULL OR co.dsCentroReceita = '' THEN 'Não Informado' ELSE co.dsCentroReceita END 
	)
) into select_result
FROM `ctbsdb_dev`.`co_faturamento` co, ftr
WHERE 1=1
AND co.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
AND co.dsFormaRecebimento LIKE (CASE WHEN ftr.dsFormaRecebimento IS NULL THEN '%' WHEN ftr.dsFormaRecebimento = '' THEN '%' ELSE ftr.dsFormaRecebimento end)
AND co.dtDataEmissao 
	BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
	AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)
ORDER BY co.idFaturamento DESC;

-- where date_format(str_to_date(dtDataEmissao,'%d/%m/%Y'),'%d/%m/%Y') between date_format(str_to_date(_dtStart,'%d/%m/%Y'),'%d/%m/%Y') AND date_format(str_to_date(_dtEnd,'%d/%m/%Y'),'%d/%m/%Y')
    
    
    
    
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
