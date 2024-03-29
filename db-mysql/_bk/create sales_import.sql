CREATE TABLE IF NOT EXISTS `sales_import` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    region VARCHAR(150),
    country VARCHAR(150),
    itemType VARCHAR(150),
    salesChannel VARCHAR(150),
    orderPriority VARCHAR(150),
    orderDate DATE,
    orderID INT,
    shipDate DATE,
    unitsSold INT,
    unitPrice DECIMAL(19, 4),
    unitCost DECIMAL(19, 4),
    totalRevenue DECIMAL(19, 4),
    totalCost DECIMAL(19, 4),
    totalProfit DECIMAL(19, 4),
    filename VARCHAR(50),
    importDate timestamp,
    PRIMARY KEY `pk_id`(`id`)
) ENGINE = InnoDB;