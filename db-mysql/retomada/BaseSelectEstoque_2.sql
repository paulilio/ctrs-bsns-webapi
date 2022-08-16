
	WITH a AS (
		SELECT
		 tab.ref
		,tab.idProduto
		,tab.idEmpresa
		-- ,tab.dsProduto
		-- ,tab.Classificacao
		,MAX(e_qtd) e_qtd
		,MAX(e_cus) e_cus

		,MAX(fp_qtd) fp_qtd
		,MAX(fp_cus) fp_cus

		FROM (

		-- Faturamento Produto
		SELECT 
		 DATE_FORMAT(f.dtDataEmissao,'%Y-%m') ref
		,fp.idProduto
		,fp.idEmpresaPro idEmpresa
		,null e_qtd
		,null e_cus
		,SUM(DISTINCT fp.vlQuantidade) fp_qtd
		,SUM(DISTINCT fp.vlCusto*fp.vlQuantidade) fp_cus
		FROM co_faturamento f
		INNER JOIN co_faturamento_produto fp ON (fp.idFaturamento = f.idFaturamento and fp.idEmpresaFat = f.idEmpresa)
		WHERE 1=1
		GROUP BY DATE_FORMAT(f.dtDataEmissao,'%Y-%m'), fp.idProduto, fp.idEmpresaPro -- , DATE_FORMAT(e.dtdataCompra,'%Y-%m')

		UNION ALL

		-- Estoque
		SELECT 
		 DATE_FORMAT(e.dtdataCompra,'%Y-%m')
		,e.idProduto
		,e.idEmpresa
		,SUM(DISTINCT e.vlQuantidade)
		,SUM(DISTINCT e.vlValorTotal)
		,null
		,null
		FROM co_entrada_estoque e
		WHERE 1=1
		GROUP BY DATE_FORMAT(e.dtdataCompra,'%Y-%m'), e.idProduto, e.idEmpresa -- , DATE_FORMAT(e.dtdataCompra,'%Y-%m')

		) as tab
		GROUP BY  ref,tab.idProduto,tab.idEmpresa

	)
	SELECT 
	 idProduto
	,idempresa
	,100 qtd_inicial
	,120 cus_inicial
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),e_qtd, 0)) e_qtd_01, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),e_cus, 0)) e_cus_01, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),fp_qtd, 0)) fp_qtd_01, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),fp_cus, 0)) fp_cus_01
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),e_qtd, 0)) e_qtd_02, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),e_cus, 0)) e_cus_02, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),fp_qtd, 0)) fp_qtd_02, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),fp_cus, 0)) fp_cus_02
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),e_qtd, 0)) e_qtd_03, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),e_cus, 0)) e_cus_03, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),fp_qtd, 0)) fp_qtd_03, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),fp_cus, 0)) fp_cus_03
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),e_qtd, 0)) e_qtd_04, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),e_cus, 0)) e_cus_04, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),fp_qtd, 0)) fp_qtd_04, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),fp_cus, 0)) fp_cus_04
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),e_qtd, 0)) e_qtd_05, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),e_cus, 0)) e_cus_05, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),fp_qtd, 0)) fp_qtd_05, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),fp_cus, 0)) fp_cus_05
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),e_qtd, 0)) e_qtd_06, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),e_cus, 0)) e_cus_06, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),fp_qtd, 0)) fp_qtd_06, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),fp_cus, 0)) fp_cus_06
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),e_qtd, 0)) e_qtd_07, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),e_cus, 0)) e_cus_07, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),fp_qtd, 0)) fp_qtd_07, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),fp_cus, 0)) fp_cus_07
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),e_qtd, 0)) e_qtd_08, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),e_cus, 0)) e_cus_08, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),fp_qtd, 0)) fp_qtd_08, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),fp_cus, 0)) fp_cus_08
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),e_qtd, 0)) e_qtd_09, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),e_cus, 0)) e_cus_09, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),fp_qtd, 0)) fp_qtd_09, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),fp_cus, 0)) fp_cus_09
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),e_qtd, 0)) e_qtd_10, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),e_cus, 0)) e_cus_10, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),fp_qtd, 0)) fp_qtd_10, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),fp_cus, 0)) fp_cus_10
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),e_qtd, 0)) e_qtd_11, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),e_cus, 0)) e_cus_11, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),fp_qtd, 0)) fp_qtd_11, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),fp_cus, 0)) fp_cus_11
	,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),e_qtd, 0)) e_qtd_12, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),e_cus, 0)) e_cus_12, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),fp_qtd, 0)) fp_qtd_12, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),fp_cus, 0)) fp_cus_12
	FROM (SELECT concat('2020-',Value) as ref, '2020' ano FROM JSON_TABLE('["01","02","03","04","05","06","07","08","09","10","11","12"]',"$[*]"COLUMNS(Value text PATH "$")) data) d
	LEFT OUTER JOIN a ON a.ref = d.ref
	GROUP BY idProduto, idEmpresa