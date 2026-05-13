-- 1. Вывести все товары
SELECT *
FROM products;

-- 2. Вывести названия всех категорий
SELECT name
FROM categories;

-- 3. Найти самый дорогой товар
SELECT *
FROM products
ORDER BY price DESC
LIMIT 1;

-- 4. Найти самый дешевый товар
SELECT *
FROM products
ORDER BY price ASC
LIMIT 1;

-- 5. Вывести товары стоимостью дороже 50000
SELECT *
FROM products
WHERE price > 50000;

-- 6. Вывести первые 10 продаж (по дате сортировки)
SELECT *
FROM sales
ORDER BY sale_date
LIMIT 10;

-- 7. Вывести продажи, где количество купленного товара больше 3
SELECT *
FROM sales
WHERE quantity > 3;

-- 8. Найти все чеки на сумму свыше 100000
SELECT *
FROM sales
WHERE total_amount > 100000;

-- 9. Вывести товары, в названии которых есть слово "Книга"
SELECT *
FROM products
WHERE name ILIKE '%Книга%';

-- 10. Вывести продажи за определенную дату
SELECT *
FROM sales
WHERE DATE(sale_date) = '2023-05-15';



-- 11. Посчитать общее количество категорий
SELECT COUNT(*) AS total_categories
FROM categories;

-- 12. Посчитать общее количество товаров в базе
SELECT COUNT(*) AS total_products
FROM products;

-- 13. Найти среднюю цену всех товаров
SELECT AVG(price) AS average_price
FROM products;

-- 14. Посчитать общую сумму всей выручки за всё время
SELECT SUM(total_amount) AS total_revenue
FROM sales;

-- 15. Найти максимальную сумму одного чека
SELECT MAX(total_amount) AS max_check
FROM sales;

-- 16. Найти минимальную сумму одного чека
SELECT MIN(total_amount) AS min_check FROM sales;

-- 17. Посчитать общее количество проданных штук за всё время
SELECT SUM(quantity) AS total_quantity_sold FROM sales;

-- 18. Вывести ID товара и количество его продаж (в штуках)
SELECT product_id, SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_id
ORDER BY total_quantity DESC;

-- 19. Вывести ID товара и общую сумму выручки по нему
SELECT product_id, SUM(total_amount) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC;

-- 20. Вывести ID товаров, общая выручка которых превысила 1 000 000
SELECT product_id, SUM(total_amount) AS total_revenue
FROM sales
GROUP BY product_id
HAVING SUM(total_amount) > 1000000
ORDER BY total_revenue DESC;

-- 21. Посчитать количество продаж по дням
SELECT DATE(sale_date) AS sale_day, COUNT(*) AS sales_count
FROM sales
GROUP BY sale_day
ORDER BY sale_day;

-- 22. Найти день с максимальной выручкой
SELECT DATE(sale_date) AS sale_day, SUM(total_amount) AS daily_revenue
FROM sales
GROUP BY sale_day
ORDER BY daily_revenue DESC
LIMIT 1;

-- 23. Вывести название товара и название его категории
SELECT p.name AS product_name, c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- 24. Вывести список продаж с указанием названия товара
SELECT s.sale_id, s.sale_date, p.name AS product_name, s.quantity, s.total_amount
FROM sales s
JOIN products p ON s.product_id = p.product_id
ORDER BY s.sale_date;

-- 25. Вывести названия категорий и общую сумму выручки по каждой
SELECT c.name AS category_name, SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY total_revenue DESC;

-- 26. Вывести категорию с самым дорогим средним чеком
SELECT c.name AS category_name, ROUND(AVG(s.total_amount), 2) AS avg_check
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_check DESC
LIMIT 1;

-- 27. Вывести информацию о продажах (Дата, Товар, Категория, Сумма)
SELECT
    s.sale_date  AS "Дата",
    p.name       AS "Товар",
    c.name       AS "Категория",
    s.total_amount AS "Сумма"
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
ORDER BY s.sale_date;

-- 28. Найти товары, которые ни разу не продавались (LEFT JOIN)
SELECT p.product_id, p.name
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL;

-- 29. Товары, цена которых выше средней цены всех товаров
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 30. Топ-3 самых продаваемых товара по выручке (с названием и категорией)
SELECT
    p.name AS product_name,
    c.name AS category_name,
    SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY p.name, c.name
ORDER BY total_revenue DESC
LIMIT 3;