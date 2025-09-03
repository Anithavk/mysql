

CREATE DATABASE `ecommerce`;

use ecommerce;

CREATE TABLE `ecommerce`.`customers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `email` VARCHAR(150) NULL,
  `address` VARCHAR(300) NULL,
  PRIMARY KEY (`id`));
CREATE TABLE `customers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `address` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;



INSERT INTO `ecommerce`.`customers`
(`name`,`email`,`address`)VALUES("karthik","karthik@yopmail.com","no.27,north street,chennai");

INSERT INTO `ecommerce`.`customers`
(`name`,`email`,`address`)VALUES("krishika","krishika@yopmail.com","no.18,south street,madurai");

INSERT INTO `ecommerce`.`customers`
(`name`,`email`,`address`)VALUES("ramanan","ramanan@yopmail.com","no.8,new street,thanjavur");

CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `order` varchar(100) DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `order_amount` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `CUST_FK_idx` (`customer_id`),
  CONSTRAINT `cust_fk` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB;

INSERT INTO `ecommerce`.`orders`
(`customer_id`,`order`,`order_date`,`order_amount`)
VALUES(2,'product A','2025-09-03 14:30:00',230.00);

INSERT INTO `ecommerce`.`orders`
(`customer_id`,`order`,`order_date`,`order_amount`)
VALUES(1,'product B','2025-09-01 11:30:00',1299.00);

INSERT INTO `ecommerce`.`orders`
(`customer_id`,`order`,`order_date`,`order_amount`)
VALUES(2,'product C','2025-09-03 12:30:00',489.00);

INSERT INTO `ecommerce`.`orders`
(`customer_id`,`order`,`order_date`,`order_amount`)
VALUES(3,'product B','2025-09-03 10:45:00',1299.00);


CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `ecommerce`.`products`
(`id`,`name`,`price`,`description`)
VALUES("product A",230,"Product A");

INSERT INTO `ecommerce`.`products`
(`id`,`name`,`price`,`description`)
VALUES("product B",1299,"Product B");

INSERT INTO `ecommerce`.`products`
(`id`,`name`,`price`,`description`)
VALUES("product C",489,"Product C");

/*Retrieve all customers who have placed an order in the last 30 days.*/
SELECT distinct(c.name)
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= curdate() - INTERVAL 30 DAY;

/*Get the total amount of all orders placed by each customer.*/
SELECT c.name,sum(order_amount) as total
FROM orders o 
JOIN customers c ON c.id = o.customer_id
group by c.id;

/*Update the price of Product C to 45.00.*/
update  products set price=45.00 where name="product C";

/*Add a new column discount to the products table.*/
ALTER TABLE products
ADD COLUMN discount DECIMAL(5,2) DEFAULT 0;

/*Retrieve the top 3 products with the highest price.*/
SELECT * FROM products ORDER BY price DESC LIMIT 3; 

/*Get the names of customers who have ordered Product A.*/
SELECT c.name FROM  ecommerce.orders o join ecommerce.customers c 
on o.customer_id=c.id where o.order="product A";

/*Join the orders and customers tables to retrieve the customer's name and order date for each order.*/
SELECT o.id as order_id,o.order_date,c.name
FROM  ecommerce.orders o join ecommerce.customers c 
on o.customer_id=c.id order by o.id;
/*Retrieve the orders with a total amount greater than 150.00.*/
SELECT * FROM  ecommerce.orders where order_amount > 150;

/*Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.*/

CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `item_price` decimal(10,0) DEFAULT NULL,
  `item_qty` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_fk_idx` (`order_id`),
  KEY `product_fk_idx` (`item_id`),
  CONSTRAINT `order_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `product_fk` FOREIGN KEY (`item_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB;																																

ALTER TABLE ecommerce.orders DROP COLUMN `order`;
/*Retrieve the average total of all orders.*/
SELECT AVG(order_amount) AS average_order_total
FROM orders;