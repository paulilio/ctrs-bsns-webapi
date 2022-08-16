SELECT CASE WHEN dsUnidadeNegocio IS NULL THEN NULL ELSE json_object( 'dsUnidadeNegocio' ,JSON_ARRAYAGG(json_object('id', dsUnidadeNegocio, 'value', dsUnidadeNegocio))) END AS content, null as limites, null as stats 
FROM (
SELECT DISTINCT dsUnidadeNegocio FROM co_faturamento where idEmpresa = 1 ORDER BY dsUnidadeNegocio ASC 
) co_fa_un group by dsUnidadeNegocio
