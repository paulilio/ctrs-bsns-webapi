WITH tab as (

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

-- ORDER BY p.idProduto

)
SELECT
 tab.idProduto
,tab.dsProduto
,tab.dsClassificacao

,0 qtd_inicial
,0 cus_inicial

-- ,e_ref

,SUM(DISTINCT if(ref=CONCAT('2020','-01'),e_qtd, 0)) e_qtd_01, SUM(DISTINCT if(ref=CONCAT('2020','-01'),e_cus, 0)) e_cus_01, SUM(DISTINCT if(ref=CONCAT('2020','-01'),fp_qtd, 0)) fp_qtd_01, SUM(DISTINCT if(ref=CONCAT('2020','-01'),fp_cus, 0)) fp_cus_01
,SUM(DISTINCT if(ref=CONCAT('2020','-02'),e_qtd, 0)) e_qtd_02, SUM(DISTINCT if(ref=CONCAT('2020','-02'),e_cus, 0)) e_cus_01, SUM(DISTINCT if(ref=CONCAT('2020','-02'),fp_qtd, 0)) fp_qtd_02, SUM(DISTINCT if(ref=CONCAT('2020','-02'),fp_cus, 0)) fp_cus_02
-- ,SUM(DISTINCT if(ref=CONCAT('2020','-03'),e_qtd, 0)) e_qtd_03, SUM(DISTINCT if(ref=CONCAT('2020','-03'),e_cus, 0)) e_cus_01, SUM(DISTINCT if(ref=CONCAT('2020','-03'),fp_qtd, 0)) fp_qtd_03, SUM(DISTINCT if(ref=CONCAT('2020','-03'),fp_cus, 0)) fp_cus_03
-- ,SUM(DISTINCT if(ref=CONCAT('2020','-04'),e_qtd, 0)) e_qtd_04, SUM(DISTINCT if(ref=CONCAT('2020','-04'),e_cus, 0)) e_cus_01, SUM(DISTINCT if(ref=CONCAT('2020','-04'),fp_qtd, 0)) fp_qtd_04, SUM(DISTINCT if(ref=CONCAT('2020','-04'),fp_cus, 0)) fp_cus_04

FROM tab 
WHERE idProduto IS NOT NULL
GROUP BY tab.idProduto, tab.dsProduto, tab.dsClassificacao ,ref
ORDER BY idProduto