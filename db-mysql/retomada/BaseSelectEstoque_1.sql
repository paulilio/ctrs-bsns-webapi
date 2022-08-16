delimiter $$ 
drop procedure if exists getRelEstoque$$
create procedure getRelEstoque(jsonParams JSON, OUT result longtext) 
BEGIN 
DECLARE select_result  longtext default null; 
DECLARE select_result_dados  longtext default null; 

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));
END; 


-- confronto de dados: create temp
DROP TABLE IF EXISTS tp_RelEstoque;
CREATE TEMPORARY TABLE tp_RelEstoque(
     id INT PRIMARY KEY NOT NULL AUTO_INCREMENT
    ,idProduto int
    ,idEmpresa int
    ,dsProduto varchar(120)
    ,dsClassificacao varchar(120)
    
    ,eq00 decimal(12,0)
    ,ec00 decimal(12,2)

    ,eq01 decimal(12,0)
    ,ec01 decimal(12,2)
    ,sq01 decimal(12,0)
    ,sc01 decimal(12,2)

    ,eq02 decimal(12,0)
    ,ec02 decimal(12,2)
    ,sq02 decimal(12,0)
    ,sc02 decimal(12,2)
    
    ,eq03 decimal(12,0)
    ,ec03 decimal(12,2)
    ,sq03 decimal(12,0)
    ,sc03 decimal(12,2)
    
    ,eq04 decimal(12,0)
    ,ec04 decimal(12,2)
    ,sq04 decimal(12,0)
    ,sc04 decimal(12,2)
    
    ,eq05 decimal(12,0)
    ,ec05 decimal(12,2)
    ,sq05 decimal(12,0)
    ,sc05 decimal(12,2)
    
	,eq06 decimal(12,0)
    ,ec06 decimal(12,2)
    ,sq06 decimal(12,0)
    ,sc06 decimal(12,2)

);

-- confronto de dados: carga temp
INSERT INTO tp_RelEstoque (
     idProduto
    ,idEmpresa
    ,dsProduto
    ,dsClassificacao
    
    ,eq00
    ,ec00

    ,eq01
    ,ec01
    ,sq01
    ,sc01

    ,eq02
    ,ec02
    ,sq02
    ,sc02
    
    ,eq03
    ,ec03
    ,sq03
    ,sc03
    
    ,eq04
    ,ec04
    ,sq04
    ,sc04
    
    ,eq05
    ,ec05
    ,sq05
    ,sc05
    
    ,eq06
    ,ec06
    ,sq06
    ,sc06
)
WITH a AS (
    SELECT
        tab.ref
    ,tab.idProduto
    ,tab.idEmpresa
    ,tab.dsProduto
    ,tab.dsClassificacao

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
    ,p.dsProduto
    ,p.dsClassificacao
    
    ,null e_qtd
    ,null e_cus
    ,SUM(DISTINCT fp.vlQuantidade) fp_qtd
    ,SUM(DISTINCT fp.vlCusto*fp.vlQuantidade) fp_cus
    FROM co_faturamento f
    INNER JOIN co_faturamento_produto fp ON (fp.idFaturamento = f.idFaturamento and fp.idEmpresaFat = f.idEmpresa)
    INNER JOIN co_produto p ON (p.idProduto = fp.idProduto AND p.idEmpresa = fp.idEmpresaPro)
    WHERE 1=1
    GROUP BY DATE_FORMAT(f.dtDataEmissao,'%Y-%m'), fp.idProduto, fp.idEmpresaPro -- , DATE_FORMAT(e.dtdataCompra,'%Y-%m')

    UNION ALL

    -- Estoque
    SELECT 
        DATE_FORMAT(e.dtdataCompra,'%Y-%m')
    ,e.idProduto
    ,e.idEmpresa
	,p.dsProduto
    ,p.dsClassificacao
    
    ,SUM(DISTINCT e.vlQuantidade)
    ,SUM(DISTINCT e.vlValorTotal)
    ,null
    ,null
    FROM co_entrada_estoque e
    INNER JOIN co_produto p ON (p.idProduto = e.idProduto AND p.idEmpresa = e.idEmpresa)
    WHERE 1=1
    GROUP BY DATE_FORMAT(e.dtdataCompra,'%Y-%m'), e.idProduto, e.idEmpresa -- , DATE_FORMAT(e.dtdataCompra,'%Y-%m')

    ) as tab
    GROUP BY  ref,tab.idProduto,tab.idEmpresa, tab.dsProduto, tab.dsClassificacao

)
SELECT 
 idProduto
,idEmpresa
,dsProduto-- ,tab.dsProduto
,dsClassificacao-- ,tab.Classificacao
    
,100 eq00
,120 ec00
,coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),e_qtd, 0)),0) eq01, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),e_cus, 0)),0) ec01, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),fp_qtd, 0)),0) sq01, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-01'),fp_cus, 0)),0) sc01
,coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),e_qtd, 0)),0) eq02, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),e_cus, 0)),0) ec02, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),fp_qtd, 0)),0) sq02, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-02'),fp_cus, 0)),0) sc02
,coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),e_qtd, 0)),0) eq03, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),e_cus, 0)),0) ec03, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),fp_qtd, 0)),0) sq03, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-03'),fp_cus, 0)),0) sc03
,coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),e_qtd, 0)),0) eq04, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),e_cus, 0)),0) ec04, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),fp_qtd, 0)),0) sq04, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-04'),fp_cus, 0)),0) sc04
,coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),e_qtd, 0)),0) eq05, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),e_cus, 0)),0) ec05, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),fp_qtd, 0)),0) sq05, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-05'),fp_cus, 0)),0) sc05
,coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),e_qtd, 0)),0) eq06, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),e_cus, 0)),0) ec06, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),fp_qtd, 0)),0) sq06, coalesce(SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-06'),fp_cus, 0)),0) sc06
-- ,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),e_qtd, 0)) eq07, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),e_cus, 0)) ec07, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),fp_qtd, 0)) sq07, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-07'),fp_cus, 0)) sc07
-- ,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),e_qtd, 0)) eq08, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),e_cus, 0)) ec08, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),fp_qtd, 0)) sq08, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-08'),fp_cus, 0)) sc08
-- ,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),e_qtd, 0)) eq09, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),e_cus, 0)) ec09, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),fp_qtd, 0)) sq09, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-09'),fp_cus, 0)) sc09
-- ,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),e_qtd, 0)) eq10, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),e_cus, 0)) ec10, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),fp_qtd, 0)) sq10, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-10'),fp_cus, 0)) sc10
-- ,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),e_qtd, 0)) eq11, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),e_cus, 0)) ec11, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),fp_qtd, 0)) sq11, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-11'),fp_cus, 0)) sc11
-- ,SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),e_qtd, 0)) eq12, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),e_cus, 0)) ec12, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),fp_qtd, 0)) sq12, SUM(DISTINCT if(a.ref=CONCAT(d.ano,'-12'),fp_cus, 0)) sc12
FROM (SELECT concat('2020-',Value) as ref, '2020' ano FROM JSON_TABLE('["01","02","03","04","05","06","07","08","09","10","11","12"]',"$[*]"COLUMNS(Value text PATH "$")) data) d
LEFT OUTER JOIN a ON a.ref = d.ref
GROUP BY idProduto, idEmpresa, dsProduto, dsClassificacao
ORDER BY idEmpresa, idProduto;


-- confronto de dados: resultado json
WITH tab as (
	SELECT 
         idProduto
        ,idEmpresa
        ,dsProduto
        ,dsClassificacao

        ,eq00
        ,ec00

        ,eq01
        ,ec01
        ,sq01 
        ,sc01 
        ,eq00 + eq01 -sq01  tq01
        ,ec00 + ec01 -sc01  tc01

        ,eq02
        ,ec02
        ,sq02 
        ,sc02 
        ,eq00 + eq01 -sq01 + eq02 -sq02  tq02
        ,ec00 + ec01 -sc01 + ec02 -sc02  tc02

        ,eq03
        ,ec03
        ,sq03 
        ,sc03 
        ,eq00 + eq01 -sq01 + eq02 -sq02 + eq03 -sq03 tq03
        ,ec00 + ec01 -sc01 + ec02 -sc02 + ec03 -sc03 tc03
        
        ,eq04
        ,ec04
        ,sq04 
        ,sc04 
        ,eq00 + eq01 -sq01 + eq02 -sq02 + eq03 -sq03 + eq04 -sq04 tq04
        ,ec00 + ec01 -sc01 + ec02 -sc02 + ec03 -sc03 + ec04 -sc04 tc04
        
        ,eq05
        ,ec05
        ,sq05 
        ,sc05 
        ,eq00 + eq01 -sq01 + eq02 -sq02 + eq03 -sq03 + eq04 -sq04 + eq05 -sq05  tq05
        ,ec00 + ec01 -sc01 + ec02 -sc02 + ec03 -sc03 + ec04 -sc04 + ec05 -sc05  tc05
        
        ,eq06
        ,ec06
        ,sq06 
        ,sc06 
        ,eq00 + eq01 -sq01 + eq02 -sq02 + eq03 -sq03 + eq04 -sq04 + eq05 -sq05 + eq06 -sq06 tq06
        ,ec00 + ec01 -sc01 + ec02 -sc02 + ec03 -sc03 + ec04 -sc04 + ec05 -sc05 + ec06 -sc06  tc06

	FROM tp_RelEstoque tp WHERE tp.idProduto IS NOT NULL
)
SELECT 
	JSON_ARRAYAGG(
    JSON_OBJECT(
    'idProduto', idProduto, 
    'dsProduto', dsProduto,
    'dsClassificacao', dsClassificacao,
    
    'eq00', eq00,
    'ec00', FormatCurrancyBr(ec00), 
    
    'eq01', eq01,
    'ec01', FormatCurrancyBr(ec01), 
    'sq01', sq01,
    'sc01', FormatCurrancyBr(sc01),
    'tq01', tq01,
    'tc01', FormatCurrancyBr(tc01),

    'eq02', eq02,
    'ec02', FormatCurrancyBr(ec02), 
    'sq02', sq02,
    'sc02', FormatCurrancyBr(sc02),
    'tq02', tq02,
    'tc02', FormatCurrancyBr(tc02),
    
    'eq03', eq03,
    'ec03', FormatCurrancyBr(ec03), 
    'sq03', sq03,
    'sc03', FormatCurrancyBr(sc03),
    'tq03', tq03,
    'tc03', FormatCurrancyBr(tc03),
    
    'eq04', eq04,
    'ec04', FormatCurrancyBr(ec04), 
    'sq04', sq04,
    'sc04', FormatCurrancyBr(sc04),
    'tq04', tq04,
    'tc04', FormatCurrancyBr(tc04),
    
    'eq05', eq05,
    'ec05', FormatCurrancyBr(ec05), 
    'sq05', sq05,
    'sc05', FormatCurrancyBr(sc05),
    'tq05', tq05,
    'tc05', FormatCurrancyBr(tc05),
    
    'eq06', eq06,
    'ec06', FormatCurrancyBr(ec06), 
    'sq06', sq06,
    'sc06', FormatCurrancyBr(sc06),
    'tq06', tq06,
    'tc06', FormatCurrancyBr(tc06)
    )
    ) jsonresult into select_result_dados
FROM tab;


SELECT 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(JSON_OBJECT(
	'dados', select_result_dados
),'"{','{'),'}"','}'),'\"[','['),']\"',']'),"\\","")
INTO select_result 
FROM DUAL;

SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
  
END $$ 
delimiter ; 
  
  
-- Testing 
/*
call  getRelEstoque('{"dsMesAno":"04/2020"}', @test);
SELECT @test as t;
*/
