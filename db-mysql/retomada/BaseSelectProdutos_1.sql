SELECT
 MAX(ref) ref
,tab.idProduto
,tab.idEmpresa
,tab.dsProduto
-- ,tab.Classificacao
,MAX(e_qtd) e_qtd
,MAX(e_cus) e_cus

,MAX(fp_qtd) fp_qtd
,MAX(fp_cus) fp_cus

FROM (

SELECT aux.ref ,p.*

,null e_qtd
,null e_cus

,SUM(DISTINCT fp.vlQuantidade) fp_qtd
,SUM(DISTINCT fp.vlCusto*fp.vlQuantidade) fp_cus

FROM (SELECT concat('2020-',Value) as ref FROM JSON_TABLE('["01","02","03","04","05","06","07","08","09","10","11","12"]',"$[*]"COLUMNS(Value text PATH "$")) data) aux
LEFT OUTER JOIN co_faturamento f ON DATE_FORMAT(f.dtDataEmissao,'%Y-%m') = aux.ref
LEFT OUTER JOIN co_faturamento_produto fp ON (fp.idFaturamento = f.idFaturamento and fp.idEmpresaFat = f.idEmpresa)
LEFT OUTER JOIN co_produto p ON (p.idProduto = fp.idProduto AND p.idEmpresa = fp.idEmpresaPro)
-- LEFT OUTER JOIN co_entrada_estoque e ON (e.idProduto = p.idProduto AND e.idEmpresa = p.idEmpresa) -- AND DATE_FORMAT(e.dtdataCompra,'%Y-%m') = aux.ref

WHERE 1=1
GROUP BY aux.ref, p.idProduto, p.idEmpresa -- , DATE_FORMAT(e.dtdataCompra,'%Y-%m')

UNION ALL

SELECT aux.ref,p.*

,SUM(DISTINCT e.vlQuantidade)
,SUM(DISTINCT e.vlValorTotal)

,null
,null

FROM (SELECT concat('2020-',Value) as ref FROM JSON_TABLE('["01","02","03","04","05","06","07","08","09","10","11","12"]',"$[*]"COLUMNS(Value text PATH "$")) data) aux
LEFT OUTER JOIN co_entrada_estoque e ON DATE_FORMAT(e.dtdataCompra,'%Y-%m') = aux.ref
LEFT OUTER JOIN co_produto p ON (p.idProduto = e.idProduto AND p.idEmpresa = e.idEmpresa)
WHERE 1=1
GROUP BY aux.ref, p.idProduto, p.idEmpresa -- , DATE_FORMAT(e.dtdataCompra,'%Y-%m')

) as tab
GROUP BY  tab.idProduto,tab.idEmpresa,tab.dsProduto
-- ORDER BY p.idProduto