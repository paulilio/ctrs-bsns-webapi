DELIMITER $$

DROP FUNCTION IF EXISTS `ExtractDecimal`$$

CREATE FUNCTION `ExtractDecimal`(in_string VARCHAR(50)) 
RETURNS DECIMAL(16,2)
NO SQL
BEGIN

    IF LENGTH(in_string) > 0 THEN
        RETURN CONVERT(REPLACE(REPLACE(REPLACE(in_string,'R$',''),'.',''),',','.'), DECIMAL(16,2));
    ELSE
        RETURN 0;
    END IF;    
END$$

DELIMITER ;