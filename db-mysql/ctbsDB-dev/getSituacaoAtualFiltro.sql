use ctbsdb_dev;
delimiter $$ 
drop procedure if exists getSituacaoAtualFiltro;
create procedure getSituacaoAtualFiltro(jsonParams JSON, OUT result longtext) 
BEGIN 
DECLARE select_result  longtext default null; 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
END; 

-- select Replace(json_object('filtros', GROUP_CONCAT(content), "limites", MAX(limites)),"\\","")
-- select json_object('filtros', JSON_ARRAYAGG(content), "limites", JSON_ARRAYAGG(limites)) INTO select_result FROM (
-- select REPLACE(REPLACE(json_object('filtros', JSON_ARRAYAGG(content), "limites", JSON_ARRAYAGG(limites)),': ["{',':  [{'),'}"],','}],')
select REPLACE(REPLACE(REPLACE(json_object('filtros', JSON_ARRAYAGG(content), "limites", JSON_ARRAYAGG(limites), "stats", stats),': ["{',':  [{'),'}"],','}],'),"\\","")
INTO select_result FROM (
SELECT GROUP_CONCAT(content) content, MAX(limites) limites, MAX(stats) stats FROM (
  SELECT CASE WHEN dsUnidadeNegocio IS NULL THEN NULL ELSE json_object( 'dsUnidadeNegocio' ,JSON_ARRAYAGG(json_object('id', dsUnidadeNegocio, 'value', dsUnidadeNegocio))) END AS content, null as limites, null as stats FROM (SELECT DISTINCT dsUnidadeNegocio FROM co_faturamento ORDER BY dsUnidadeNegocio ASC ) co_fa_un
  UNION ALL
  SELECT CASE WHEN dsCentroCusto IS NULL THEN NULL ELSE json_object( 'dsCentroCusto' ,JSON_ARRAYAGG(json_object('id', dsCentroCusto, 'value', dsCentroCusto))) END AS content, null as limites, null as stats FROM (SELECT DISTINCT dsCentroCusto FROM co_faturamento ORDER BY dsCentroCusto ASC ) co_fa_ce
  UNION ALL
  SELECT CASE WHEN dsFormaPagamento IS NULL THEN NULL ELSE json_object( 'dsFormaPagamento' ,JSON_ARRAYAGG(json_object('id', dsFormaPagamento, 'value', dsFormaPagamento))) END AS content, null as limites, null as stats FROM (SELECT DISTINCT dsFormaPagamento FROM co_faturamento ORDER BY dsFormaPagamento ASC ) co_fa_ce
  UNION ALL
  SELECT null as content, json_object('max', DATE_FORMAT(dtMax, '%Y-%m-%d'), 'min', DATE_FORMAT(dtMin, '%Y-%m-%d')) limites, null as stats FROM (SELECT DISTINCT MAX(fa.dtDataEmissao) dtMax, MIN(fa.dtDataEmissao) dtMin FROM co_faturamento fa ) as fa
  UNION ALL  
	SELECT null as content, null as limites,
		JSON_ARRAY(
			 json_object('vlMedioMensal', json_object('amount',FormatCurrancyBR(vlMedioMensal)))
			,json_object('qtTotalRegistro', json_object('amount',CAST(qtTotalRegistro as CHAR)))
			,json_object('dtUltImport', json_object('amount',DATE_FORMAT(dtUltImport, '%d/%m/%Y')))
		) as stats
	FROM (SELECT avg(vlValor) vlMedioMensal, count(*) qtTotalRegistro, ca.dtUltImport FROM co_faturamento, (SELECT MAX(dtImport) dtUltImport FROM co_carga ca WHERE ca.cdTipo = 'F') ca) as fa
) AS T1 )  AS T2;

/*
SELECT CONCAT('{"filtros":', GROUP_CONCAT(content), '}') INTO select_result FROM
(
    SELECT CASE WHEN dsUnidadeNegocio IS NULL THEN NULL ELSE json_object( 'Unidade de Negócio',JSON_ARRAYAGG(json_object('id', dsUnidadeNegocio, 'value', dsUnidadeNegocio))) END AS content FROM (SELECT DISTINCT dsUnidadeNegocio FROM co_faturamento ORDER BY dsUnidadeNegocio ASC ) co_fa_un
	UNION ALL
	SELECT CASE WHEN dsCentroCusto IS NULL THEN NULL ELSE json_object( 'Centro de Receita',JSON_ARRAYAGG(json_object('id', dsCentroCusto, 'value', dsCentroCusto))) END AS content FROM (SELECT DISTINCT dsCentroCusto FROM co_faturamento ORDER BY dsCentroCusto ASC ) co_fa_ce
)  AS AUX WHERE content is not null;
*/


SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
  
END $$ 
delimiter ; 
  
-- Testing 
/*
call  getSituacaoAtualFiltro(null, @test);
SELECT @test as t;
*/


/* 
Resultado Esperado:
{
  "filtros": 
  {
    "Unidade de Negócio": [
      {
        "id": 1,"value": "Brasília"
      },
      {
        "id": 2,"value": "Goiânia"
      },
      {
        "id": 3,"value": "São Paulo"
      }
    ],
    "Centro de Receita": [
      {
        "id": 1,"value": "Marista"
      },
      {
        "id": 2,"value": "Geral"
      }
    ]
  }
*/

/*
Exemplo de select explicativo
SELECT 
json_object( 'Unidade de Negócio', -- Transforma o conteúdo em objeto. ex.: {"Unidade de Negócio": [ conteúdo ]}
	JSON_ARRAYAGG( -- colocar todas as ocorrências juntas. ex.: {\"Goiânia\": \"Goiânia\"}, {\"Brasília\": \"Brasília\"}]
		json_object('id', dsUnidadeNegocio, 'value', dsUnidadeNegocio)
	) 
) as js into select_result
FROM (
	SELECT DISTINCT dsUnidadeNegocio
	FROM co_faturamento
    UNION ALL
    SELECT "Brasília" from DUAL
) co_fa
ORDER BY dsUnidadeNegocio ASC
*/
