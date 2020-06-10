use ctbsdb_dev;
delimiter $$ 
drop procedure if exists getSituacaoAtualLista;
create procedure getSituacaoAtualLista(jsonParams JSON, IN p_cdTipoImp VARCHAR(1), OUT result longtext) 
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

CASE WHEN p_cdTipoImp IN ('F','R','P','I','B') THEN

	-- situacaoatual: temp
	DROP TEMPORARY TABLE IF EXISTS tp_situacaoatual;
	CREATE TEMPORARY TABLE tp_situacaoatual(
	`id` int NOT NULL AUTO_INCREMENT,
	`idCarga` int NOT NULL,
	`dsCpfCnpjCliente` varchar(20),
	`dsNomeCliente` varchar(120),
	`dsCodigoInterno` varchar(20),
	`dtDataEmissao` datetime,
	`dtDataVencimento` datetime,
	`dtDataPagamento` datetime,
	`dsFormaPagamento` varchar(50),
	`vlValor` decimal(20,2),
	`dsNatureza` varchar(50),
	`dsContaContabil` varchar(50),
	`dsUnidadeNegocio` varchar(50),
	`dsCentroCusto` varchar(50),
	`dsBanco` varchar(50),
	PRIMARY KEY (`id`)
	);


	-- situacaoatual: insert temp
	-- TipoImport

	INSERT INTO tp_situacaoatual
	SELECT * FROM (

		WITH ftr AS (SELECT 
		JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsUnidadeNegocio'),'[',''),']','')) AS dsUnidadeNegocio
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsFormaPagamento'),'[',''),']','')) AS dsFormaPagamento
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsCentroCusto'),'[',''),']','')) AS dsCentroCusto
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dtDataEmissaoMin'),'[',''),']','')) AS dtDataEmissaoMin
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dtDataEmissaoMax'),'[',''),']','')) AS dtDataEmissaoMax
		)

		SELECT t.*, 0 dsBanco
		FROM co_faturamento t, ftr WHERE p_cdTipoImp='F'
		AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
		AND t.dsFormaPagamento LIKE (CASE WHEN ftr.dsFormaPagamento IS NULL THEN '%' WHEN ftr.dsFormaPagamento = '' THEN '%' ELSE ftr.dsFormaPagamento end)
		AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
		AND t.dtDataEmissao 
			BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
			AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)
		
		UNION ALL

		SELECT t.*, 0 dsBanco
		FROM co_conta_receber t, ftr WHERE p_cdTipoImp='R'
		AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
		AND t.dsFormaPagamento LIKE (CASE WHEN ftr.dsFormaPagamento IS NULL THEN '%' WHEN ftr.dsFormaPagamento = '' THEN '%' ELSE ftr.dsFormaPagamento end)
		AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
		AND t.dtDataEmissao 
			BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
			AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)

		UNION ALL

		SELECT t.*, 0 dsBanco
		FROM co_conta_pagar t, ftr WHERE p_cdTipoImp='P'
		AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
		AND t.dsFormaPagamento LIKE (CASE WHEN ftr.dsFormaPagamento IS NULL THEN '%' WHEN ftr.dsFormaPagamento = '' THEN '%' ELSE ftr.dsFormaPagamento end)
		AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
		AND t.dtDataEmissao 
			BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
			AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)
			
		UNION ALL

		SELECT t.*, 0 dsBanco
		FROM co_inadimplente t, ftr WHERE p_cdTipoImp='I'
		AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
		AND t.dsFormaPagamento LIKE (CASE WHEN ftr.dsFormaPagamento IS NULL THEN '%' WHEN ftr.dsFormaPagamento = '' THEN '%' ELSE ftr.dsFormaPagamento end)
		AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
		AND t.dtDataEmissao 
			BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
			AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)

		UNION ALL

		SELECT t.*
		FROM co_banco t, ftr WHERE p_cdTipoImp='B'
		AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
		AND t.dsFormaPagamento LIKE (CASE WHEN ftr.dsFormaPagamento IS NULL THEN '%' WHEN ftr.dsFormaPagamento = '' THEN '%' ELSE ftr.dsFormaPagamento end)
		AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
		AND t.dtDataEmissao 
			BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
			AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)

	) as temp;

	WITH tab as (
		SELECT *
		FROM tp_situacaoatual tp
	)
	SELECT JSON_ARRAYAGG(
		json_object(
		'id', id,
		'idCarga', idCarga,
		'dsCpfCnpjCliente', CASE WHEN dsCpfCnpjCliente IS NULL OR dsCpfCnpjCliente = '' THEN 'Não Informado' ELSE dsCpfCnpjCliente END,
		'dsNomeCliente', CASE WHEN dsNomeCliente IS NULL OR dsNomeCliente = '' THEN 'Não Informado' ELSE dsNomeCliente END,
		'dsCodigoInterno', CASE WHEN dsCodigoInterno IS NULL OR dsCodigoInterno = '' THEN 'Não Informado' ELSE dsCodigoInterno END,
		'dtDataEmissao', CASE WHEN dtDataEmissao IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataEmissao, '%d/%m/%Y') END,
		'dtDataVencimento', CASE WHEN dtDataVencimento IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataVencimento, '%d/%m/%Y') END,
		'dtDataPagamento', CASE WHEN dtDataPagamento IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataPagamento, '%d/%m/%Y') END ,
		'dsFormaPagamento', CASE WHEN dsFormaPagamento IS NULL OR dsFormaPagamento = '' THEN 'Não Informado' ELSE dsFormaPagamento END,
		'vlValor', CASE WHEN vlvalor IS NULL THEN 'Não Informado' ELSE REPLACE(REPLACE(REPLACE(FORMAT(vlvalor,2), '.', '|'), ',', '.'), '|', ',') END,
		'dsNatureza', CASE WHEN dsNatureza IS NULL OR dsNatureza = '' THEN 'Não Informado' ELSE dsNatureza END,
		'dsContaContabil', CASE WHEN dsContaContabil IS NULL OR dsContaContabil = '' THEN 'Não Informado' ELSE dsContaContabil END,
		'dsUnidadeNegocio',CASE WHEN dsUnidadeNegocio IS NULL OR dsUnidadeNegocio = '' THEN 'Não Informado' ELSE dsUnidadeNegocio END ,
		'dsCentroCusto', CASE WHEN dsCentroCusto IS NULL OR dsCentroCusto = '' THEN 'Não Informado' ELSE dsCentroCusto END 
		)
	) into select_result
	FROM tab;

WHEN p_cdTipoImp = 'E' THEN

-- tp_estoque: temp
	DROP TEMPORARY TABLE IF EXISTS tp_estoque;
	CREATE TEMPORARY TABLE tp_estoque(
	idEstoque            int not null auto_increment  comment '',
	idCarga              int  comment '',
	dsCpfCNPJFornecedor  varchar(20)  comment '',
	dsNomeFornecedor     varchar(120)  comment '',
	dsCodigoInterno      varchar(20)  comment '',
	dtDataCompra         datetime  comment '',
	vlValorTotal         decimal(20,2)  comment '',
	vlValor      decimal(20,2)  comment '',
	vlQuantidade         decimal(12,0)  comment '',
	dsProduto            varchar(120)  comment '',
	dsLinhaProduto       varchar(120)  comment '',
	dsUnidadeNegocio     varchar(50)  comment '',
	dsCentroCusto        varchar(50)  comment '',
	primary key (idEstoque)
	);


	INSERT INTO tp_estoque
	SELECT * FROM (

		WITH ftr AS (SELECT 
		JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsUnidadeNegocio'),'[',''),']','')) AS dsUnidadeNegocio
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsFormaPagamento'),'[',''),']','')) AS dsFormaPagamento
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dsCentroCusto'),'[',''),']','')) AS dsCentroCusto
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dtDataEmissaoMin'),'[',''),']','')) AS dtDataEmissaoMin
		, JSON_UNQUOTE(REPLACE(REPLACE(JSON_EXTRACT(jsonParams,'$**.dtDataEmissaoMax'),'[',''),']','')) AS dtDataEmissaoMax
		)

		SELECT t.*
		FROM co_estoque t, ftr WHERE p_cdTipoImp='E'
		AND t.dsUnidadeNegocio LIKE (CASE WHEN ftr.dsUnidadeNegocio IS NULL THEN '%' WHEN ftr.dsUnidadeNegocio = '' THEN '%' ELSE ftr.dsUnidadeNegocio end)
		AND t.dsCentroCusto LIKE (CASE WHEN ftr.dsCentroCusto IS NULL THEN '%' WHEN ftr.dsCentroCusto = '' THEN '%' ELSE ftr.dsCentroCusto end)
		AND t.dtDataCompra
			BETWEEN (CASE WHEN ftr.dtDataEmissaoMin IS NULL THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) WHEN ftr.dtDataEmissaoMin = '' THEN DATE_SUB(curdate(), INTERVAL 2 MONTH) ELSE ftr.dtDataEmissaoMin END)
			AND (CASE WHEN ftr.dtDataEmissaoMax IS NULL THEN curdate() WHEN ftr.dtDataEmissaoMax = '' THEN curdate() ELSE ftr.dtDataEmissaoMax END)

	) as temp;

	WITH tab as (
		SELECT *
		FROM tp_estoque tp
	)
	SELECT JSON_ARRAYAGG(
		json_object(
		'id', idEstoque,
		'idCarga', idCarga,
		'dsCpfCnpjFornecedor', CASE WHEN dsCpfCnpjFornecedor IS NULL OR dsCpfCnpjFornecedor = '' THEN 'Não Informado' ELSE dsCpfCnpjFornecedor END,
		'dsNomeFornecedor', CASE WHEN dsNomeFornecedor IS NULL OR dsNomeFornecedor = '' THEN 'Não Informado' ELSE dsNomeFornecedor END,
		'dsCodigoInterno', CASE WHEN dsCodigoInterno IS NULL OR dsCodigoInterno = '' THEN 'Não Informado' ELSE dsCodigoInterno END,
		'dtDataCompra', CASE WHEN dtDataCompra IS NULL THEN 'Não Informado' ELSE DATE_FORMAT(dtDataCompra, '%d/%m/%Y') END,
		'vlValorTotal', CASE WHEN vlValorTotal IS NULL THEN 'Não Informado' ELSE REPLACE(REPLACE(REPLACE(FORMAT(vlValorTotal,2), '.', '|'), ',', '.'), '|', ',') END,
		'vlValor', CASE WHEN vlValor IS NULL THEN 'Não Informado' ELSE REPLACE(REPLACE(REPLACE(FORMAT(vlValor,2), '.', '|'), ',', '.'), '|', ',') END,
		'vlQuantidade', CASE WHEN vlQuantidade IS NULL OR vlQuantidade = '' THEN 'Não Informado' ELSE vlQuantidade END,
		'dsProduto', CASE WHEN dsProduto IS NULL OR dsProduto = '' THEN 'Não Informado' ELSE dsProduto END,
		'dsLinhaProduto', CASE WHEN dsLinhaProduto IS NULL OR dsLinhaProduto = '' THEN 'Não Informado' ELSE dsLinhaProduto END,
		'dsUnidadeNegocio',CASE WHEN dsUnidadeNegocio IS NULL OR dsUnidadeNegocio = '' THEN 'Não Informado' ELSE dsUnidadeNegocio END ,
		'dsCentroCusto', CASE WHEN dsCentroCusto IS NULL OR dsCentroCusto = '' THEN 'Não Informado' ELSE dsCentroCusto END 
		)
	) into select_result
	FROM tab;

END CASE;

SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
  
END $$ 
delimiter ; 
  
-- Testing 
/*
call  getSituacaoAtualLista('{"dtStart":"01/05/2010","dtEnd": "28/05/2010"}', 'F' @test);
SELECT @test as t;
*/
/*
call  getSituacaoAtualLista(null, 'F', @test);
SELECT @test as t;
*/
