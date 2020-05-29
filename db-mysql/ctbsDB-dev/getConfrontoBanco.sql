use ctbsdb_dev;
delimiter $$ 
drop procedure if exists getRelConfrontoBanco;
create procedure getRelConfrontoBanco(jsonParams JSON, OUT result longtext) 
BEGIN 
DECLARE select_result  longtext default null; 
DECLARE select_result_dados  longtext default null; 
DECLARE select_result_totais  longtext default null; 

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
END; 


-- confronto de dados: create temp
DROP TABLE IF EXISTS tp_relconfrontobanco;
CREATE TEMPORARY TABLE tp_relconfrontobanco(
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    dsFormaPagamento VARCHAR(50),
    vlContaReceber DECIMAL(20,2),
    vlInadimplencia DECIMAL(20,2),
    vlTaxa DECIMAL(20,2),
    vlConfronto DECIMAL(20,2),
    vlDiagnostico DECIMAL(20,2),
    vlSitualcaoAtual DECIMAL(20,2)
);

-- confronto de dados: carga temp
INSERT INTO tp_relconfrontobanco (dsFormaPagamento, vlContaReceber, vlInadimplencia, vlTaxa, vlSitualcaoAtual, vlDiagnostico, vlConfronto)
SELECT dsFormaPagamento, MAX(rec) vlContaReceber, MAX(ina) vlInadimplencia, MAX(tax) vlTaxa, MAX(ban) vlSituacaoAtual, MAX(rec)-MAX(ina)-MAX(tax) vlDiagnostico, MAX(ban)  - (MAX(rec)-MAX(ina)-MAX(tax)) vlConfronto FROM (    
	
    WITH ftr AS (
    SELECT JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsNatureza'),'[',''),']','')) AS dsNatureza
	 , JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsContaContabil'),'[',''),']','')) AS dsContaContabil
	 , JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsUnidadeNegocio'),'[',''),']','')) AS dsUnidadeNegocio
	 , JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsCentroCusto'),'[',''),']','')) AS dsCentroCusto
	 , JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsMesAno'),'[',''),']','')) AS dsMesAno)
     
    SELECT t.dsFormaPagamento, SUM(DISTINCT vlValor) rec, 0 fat, 0 ina, 0 ban, 0 tax FROM co_conta_receber t, ftr
	WHERE t.dtDataEmissao BETWEEN STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y") AND DATE_SUB(DATE_ADD(STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y"), INTERVAL 1 MONTH), INTERVAL 1 DAY)
      AND t.dsNatureza LIKE (CASE WHEN ftr.dsNatureza IS NULL THEN '%' WHEN ftr.dsNatureza = '' THEN '%' ELSE ftr.dsNatureza end)
	  AND t.dsContaContabil LIKE (CASE WHEN ftr.dsContaContabil IS NULL THEN '%' WHEN ftr.dsContaContabil = '' THEN '%' ELSE ftr.dsContaContabil end)
	  AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
	  AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
    GROUP BY t.dsFormaPagamento
    
    /*
    UNION ALL 

	SELECT t.dsFormaPagamento, 0 rec, SUM(DISTINCT t.vlValor) fat, 0 ina, 0 ban, 0 tax FROM co_faturamento t, ftr
	WHERE t.dtDataEmissao BETWEEN STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y") AND DATE_SUB(DATE_ADD(STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y"), INTERVAL 1 MONTH), INTERVAL 1 DAY)
      AND t.dsNatureza LIKE (CASE WHEN ftr.dsNatureza IS NULL THEN '%' WHEN ftr.dsNatureza = '' THEN '%' ELSE ftr.dsNatureza end)
	  AND t.dsContaContabil LIKE (CASE WHEN ftr.dsContaContabil IS NULL THEN '%' WHEN ftr.dsContaContabil = '' THEN '%' ELSE ftr.dsContaContabil end)
	  AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
	  AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
    GROUP BY t.dsFormaPagamento
    */

    UNION ALL 

	SELECT t.dsFormaPagamento, 0 rec, 0 fat, SUM(DISTINCT t.vlValor) ina, 0 ban, 0 tax FROM co_inadimplente t, ftr
	WHERE t.dtDataEmissao BETWEEN STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y") AND DATE_SUB(DATE_ADD(STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y"), INTERVAL 1 MONTH), INTERVAL 1 DAY)
      AND t.dsNatureza LIKE (CASE WHEN ftr.dsNatureza IS NULL THEN '%' WHEN ftr.dsNatureza = '' THEN '%' ELSE ftr.dsNatureza end)
	  AND t.dsContaContabil LIKE (CASE WHEN ftr.dsContaContabil IS NULL THEN '%' WHEN ftr.dsContaContabil = '' THEN '%' ELSE ftr.dsContaContabil end)
	  AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
	  AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
    GROUP BY t.dsFormaPagamento
    
    UNION ALL 

	SELECT t.dsFormaPagamento, 0 rec, 0 fat, 0 ina, SUM(DISTINCT t.vlValor) ban, 0 tax FROM co_banco t, ftr
	WHERE t.dtDataEmissao BETWEEN STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y") AND DATE_SUB(DATE_ADD(STR_TO_DATE(CONCAT('01/',ftr.dsMesAno), "%d/%m/%Y"), INTERVAL 1 MONTH), INTERVAL 1 DAY)
      AND t.dsNatureza LIKE (CASE WHEN ftr.dsNatureza IS NULL THEN '%' WHEN ftr.dsNatureza = '' THEN '%' ELSE ftr.dsNatureza end)
	  AND t.dsContaContabil LIKE (CASE WHEN ftr.dsContaContabil IS NULL THEN '%' WHEN ftr.dsContaContabil = '' THEN '%' ELSE ftr.dsContaContabil end)
	  AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
	  AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
    GROUP BY t.dsFormaPagamento
    
    UNION ALL
    
	SELECT 'Cartão Credito' dsFormaPagamento, 0 rec, 0 fat, 0 ina, 0 ban, 120 tax 
    
) as t
GROUP BY dsFormaPagamento 
ORDER BY dsFormaPagamento;

-- confronto de dados: resultado json
WITH tab as (
    SELECT dsFormaPagamento, SUM(DISTINCT vlContaReceber) vlContaReceber, SUM(DISTINCT vlInadimplencia) vlInadimplencia, SUM(DISTINCT vlTaxa) vlTaxa, SUM(DISTINCT vlSitualcaoAtual) vlSitualcaoAtual, SUM(DISTINCT vlDiagnostico) vlDiagnostico, SUM(DISTINCT vlConfronto) vlConfronto
	FROM tp_relconfrontobanco tp GROUP BY dsFormaPagamento
)
SELECT 
	JSON_ARRAYAGG(
    JSON_OBJECT(
    'dsFormaPagamento', dsFormaPagamento, 
    'vlContaReceber', FormatCurrancyBr(vlContaReceber), 
    'vlInadimplencia', FormatCurrancyBr(vlInadimplencia), 
    'vlTaxa', FormatCurrancyBr(vlTaxa), 
    'vlSitualcaoAtual', FormatCurrancyBr(vlSitualcaoAtual), 
    'vlDiagnostico', FormatCurrancyBr(vlDiagnostico), 
    'vlConfronto', FormatCurrancyBr(vlConfronto) 
    )
    ) jsonresult into select_result_dados
FROM tab;

-- confronto de dados TOTAIS : resultado json
IF select_result_dados IS NOT NULL THEN 
	WITH tab as (
		SELECT SUM(DISTINCT vlDiagnostico) vlDiagnosticoTo, SUM(DISTINCT vlConfronto) vlConfrontoTo
		FROM tp_relconfrontobanco  tp
	)
	SELECT 
		JSON_ARRAYAGG(
		JSON_OBJECT(
		'vlDiagnosticoTo', FormatCurrancyBr(vlDiagnosticoTo), 
		'vlConfrontoTo', FormatCurrancyBr(vlConfrontoTo) 
		)
		) jsonresult into select_result_totais
	FROM tab;
END IF;



SELECT 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(JSON_OBJECT(
	'dados', select_result_dados,
	'totais', select_result_totais
),'"{','{'),'}"','}'),'\"[','['),']\"',']'),"\\","")
INTO select_result 
FROM DUAL;

SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
  
END $$ 
delimiter ; 
  
-- Testing 
/*
call  getRelConfrontoBanco('{"dsMesAno":"04/2020"}', @test);
SELECT @test as t;
*/
