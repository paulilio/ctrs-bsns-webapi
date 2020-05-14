use ctbsdb_dev;
drop procedure if exists getSituacaoAtualFiltro;
delimiter $$ 
create procedure getSituacaoAtualFiltro(jsonParams JSON, OUT result longtext) 
BEGIN 
DECLARE select_result  longtext default null; 
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
END; 

-- SELECT CONCAT('{"filtros":', GROUP_CONCAT(content), '}') INTO select_result FROM
select json_object('filtros', GROUP_CONCAT(content)) INTO select_result FROM
(
    SELECT CASE WHEN dsUnidadeNegocio IS NULL THEN NULL ELSE json_object( 'Unidade de Negócio',JSON_ARRAYAGG(json_object('id', dsUnidadeNegocio, 'value', dsUnidadeNegocio))) END AS content FROM (SELECT DISTINCT dsUnidadeNegocio FROM co_faturamento ORDER BY dsUnidadeNegocio ASC ) co_fa_un
	UNION ALL
	SELECT CASE WHEN dsCentroReceita IS NULL THEN NULL ELSE json_object( 'Centro de Receita',JSON_ARRAYAGG(json_object('id', dsCentroReceita, 'value', dsCentroReceita))) END AS content FROM (SELECT DISTINCT dsCentroReceita FROM co_faturamento ORDER BY dsCentroReceita ASC ) co_fa_ce
)  AS AUX WHERE content is not null;

SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
  
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
