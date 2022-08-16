select REPLACE(REPLACE(REPLACE(json_object('filtros', JSON_ARRAYAGG(content), "limites", JSON_ARRAYAGG(limites), "stats", stats),': ["{',':  [{'),'}"],','}],'),"\\","")
  FROM (
SELECT GROUP_CONCAT(content) content, MAX(limites) limites, MAX(stats) stats FROM (
  SELECT CASE WHEN dsUnidadeNegocio IS NULL THEN NULL ELSE json_object( 'dsUnidadeNegocio' ,JSON_ARRAYAGG(json_object('id', dsUnidadeNegocio, 'value', dsUnidadeNegocio))) END AS content, null as limites, null as stats FROM (SELECT DISTINCT dsUnidadeNegocio FROM co_faturamento ORDER BY dsUnidadeNegocio ASC ) co_fa_un group by dsUnidadeNegocio
  UNION ALL
  SELECT CASE WHEN dsCentroReceita IS NULL THEN NULL ELSE json_object( 'dsCentroReceita' ,JSON_ARRAYAGG(json_object('id', dsCentroReceita, 'value', dsCentroReceita))) END AS content, null as limites, null as stats FROM (SELECT DISTINCT dsCentroReceita FROM co_faturamento ORDER BY dsCentroReceita ASC ) co_fa_ce  group by dsCentroReceita
  UNION ALL
  SELECT null as content, json_object('max', DATE_FORMAT(dtMax, '%Y-%m-%d'), 'min', DATE_FORMAT(dtMin, '%Y-%m-%d')) limites, null as stats FROM (SELECT DISTINCT MAX(fa.dtDataEmissao) dtMax, MIN(fa.dtDataEmissao) dtMin FROM co_faturamento fa ) as fa
) AS T1 )  AS T2