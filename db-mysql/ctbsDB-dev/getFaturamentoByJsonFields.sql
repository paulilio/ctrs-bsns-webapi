use ctbsdb_dev;
delimiter $$ 
drop procedure if exists getFaturamentoByJsonFields$$ 
create procedure getFaturamentoByJsonFields(fields JSON, OUT result longtext) 
BEGIN 
DECLARE _dtStart VARCHAR(10) default null; 
DECLARE _dtEnd  VARCHAR(10) default null; 
DECLARE select_result  longtext default null; 
  
set _dtStart = JSON_UNQUOTE(JSON_EXTRACT(fields,'$.dtStart')); 
set _dtEnd = JSON_UNQUOTE(JSON_EXTRACT(fields,'$.dtEnd')); 
  
if (_dtStart is not null) AND (_dtEnd is not null) then 
	SELECT JSON_ARRAYAGG(
		json_object(
		'id', id,
		'region', region,
		'country', country,
		'itemType', itemType,
		'salesChannel', salesChannel,
		'orderPriority', orderPriority,
		'orderDate', orderDate,
		'orderID', orderID,
		'shipDate', shipDate,
		'unitsSold', unitsSold,
		'unitPrice', unitPrice,
		'unitCost', unitCost,
		'totalRevenue', totalRevenue,
		'totalCost', totalCost,
		'totalProfit', totalProfit,
		'filename', filename,
		'importDate', importDate
		)
        ) into select_result
	FROM `ctbsdb_dev`.`sales_import`
	where date_format(str_to_date(orderDate,'%m/%d/%Y'),'%d/%m/%Y') between date_format(str_to_date(_dtStart,'%d/%m/%Y'),'%d/%m/%Y') AND date_format(str_to_date(_dtEnd,'%d/%m/%Y'),'%d/%m/%Y')
	order by id desc;
/*elseif (i_year is not null) AND (i_month is not null) then */
else 
   select null as 'no input'; 
end if;  

-- IF `_rollback` THEN
-- 	SET result := (select JSON_OBJECT("status", 500, "result", @full_error));    
-- ELSE
	SET result := (select JSON_OBJECT("status", 200, "result", select_result));    
-- END IF;
  
END $$ 
delimiter ; 
  
-- Testing 
-- call  getFaturamentoByJsonFields('{"dtStart":"01/05/2010","dtEnd": "28/05/2010"}', @test);
-- SELECT @test as t;