USE `ctbsDB_dev`;

DROP procedure IF EXISTS `ctbsDB_dev`.`salesInsertImportData`;

DELIMITER // 
USE `ctbsDB_dev` // 
CREATE PROCEDURE `salesInsertImportData`(IN JsonPayload LONGTEXT, IN fileName VARCHAR(50), OUT result longtext)
BEGIN
DECLARE nRowsAffected INT; DECLARE `_rollback` BOOL DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;

BEGIN 
	GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
	@errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
END;

-- START TRANSACTION;

insert into
    ctbsDB_dev.sales_import(
        region,
        country,
        itemType,
        salesChannel,
        orderPriority,
        orderDate,
        orderID,
        shipDate,
        unitsSold,
        unitPrice,
        unitCost,
        totalRevenue,
        totalCost,
        totalProfit,
        filename,
        importDate
    )
SELECT
    tt.region,
    tt.country,
    tt.itemType,
    tt.salesChannel,
    tt.orderPriority,
    STR_TO_DATE(tt.orderDate, '%m/%d/%Y'),
    tt.orderID,
    STR_TO_DATE(tt.shipDate, '%m/%d/%Y'),
    tt.unitsSold,
    tt.unitPrice,
    tt.unitCost,
    tt.totalRevenue,
    tt.totalCost,
    tt.totalProfit,
    fileName,
    current_timestamp()
FROM
    JSON_TABLE(
        JsonPayload,
        "$[*]" COLUMNS(
            region VARCHAR(150) PATH '$."Region"',
            country VARCHAR(150) PATH '$."Country"',
            itemType VARCHAR(150) PATH '$."Item Type"',
            salesChannel VARCHAR(150) PATH '$."Sales Channel"',
            orderPriority VARCHAR(150) PATH '$."Order Priority"',
            orderDate VARCHAR(10) PATH '$."Order Date"',
            orderID INT PATH '$."Order ID"',
            shipDate VARCHAR(10) PATH '$."Ship Date"',
            unitsSold INT PATH '$."Units Sold"',
            unitPrice DECIMAL(19, 4) PATH '$."Unit Price"',
            unitCost DECIMAL(19, 4) PATH '$."Unit Cost"',
            totalRevenue DECIMAL(19, 4) PATH '$."Total Revenue"',
            totalCost DECIMAL(19, 4) PATH '$."Total Cost"',
            totalProfit DECIMAL(19, 4) PATH '$."Total Profit"'
        )
    ) AS tt;

IF `_rollback` THEN
	ROLLBACK;
	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));    
ELSE
	GET DIAGNOSTICS nRowsAffected = ROW_COUNT;
    COMMIT;
	SET result := (select JSON_OBJECT("status", 200, "result", CONCAT(nRowsAffected, ' registro(s) inserido(s) com sucesso!')));    
END IF;

END // 
DELIMITER ;



-- debug:
-- CALL `ctbsdb_dev`.`salesInsertImportData`('[{ "region": "Sub-Saharan Africa", "country": "Mozambique", "itemType": "Household", "salesChannel": "Offline", "orderPriority": "L", "orderDate": "2/10/2012", "orderID": "665095412", "shipDate": "2/15/2012", "unitsSold": "5367", "unitPrice": "668.27", "unitCost": "502.54", "totalRevenue": "3586605.09", "totalCost": "2697132.18", "totalProfit": "889472.91" } ]', 'teste.csv');