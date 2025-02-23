------------------------------------------------------------------------------
-- 1. Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.

select 
	distinct (t.brand)
from "transaction" t 
where t.standard_cost > 1500
order by 1;
	
--brand         |
----------------+
--Giant Bicycles|
--Norco Bicycles|
--OHM Cycles    |
--Solex         |
--Trek Bicycles |
--WeareA2B      |


------------------------------------------------------------------------------
-- 2. Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' 
-- включительно.

select
	*
from "transaction" t 
where t.transaction_date >= '2017-04-01'
	and t.transaction_date <= '2017-04-09'
	and t.order_status = 'Approved'
order by t.transaction_date
;

--transaction_id|product_id|customer_id|transaction_date|online_order|order_sta
----------------+----------+-----------+----------------+------------+---------
--         15576|        68|       2820|      2017-04-01|true        |Approved 
--         16621|        90|       2072|      2017-04-01|false       |Approved 
--          2146|         8|       3096|      2017-04-01|true        |Approved 
--         15488|        64|        906|      2017-04-01|true        |Approved 
--...


------------------------------------------------------------------------------
-- 3. Вывести все профессии у клиентов из сферы IT или Financial Services, 
-- которые начинаются с фразы 'Senior'.

select 
	distinct (c.job_title)
from customer c 
where 
	c.job_industry_category in ('IT', 'Financial Services')
	and c.job_title like 'Senior%'
order by 1
;

--job_title               |
--------------------------+
--Senior Cost Accountant  |
--Senior Developer        |
--Senior Editor           |
--Senior Financial Analyst|
--Senior Quality Engineer |
--Senior Sales Associate  |


------------------------------------------------------------------------------
-- 4. Вывести все бренды, которые закупают клиенты, работающие в сфере 
-- Financial Services

select
	distinct (t.brand)
from customer c 
join "transaction" t on c.customer_id  = t.customer_id 
where 
	c.job_industry_category  = 'Financial Services'
order by 1
;

--brand         |
----------------+
--              |
--Giant Bicycles|
--Norco Bicycles|
--OHM Cycles    |
--Solex         |
--Trek Bicycles |
--WeareA2B      |


------------------------------------------------------------------------------
-- 5. Вывести 10 клиентов, которые оформили онлайн-заказ продукции из 
-- брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.

select
	distinct (c.customer_id)
	, c.first_name 
	, c.last_name 
from customer c 
join "transaction" t on c.customer_id  = t.customer_id 
where 
	t.brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
order by 1
limit 10
;

--customer_id|first_name    |last_name|
-------------+--------------+---------+
--          1|Laraine       |Medendorp|
--          2|Eli           |Bockman  |
--          3|Arlin         |Dearle   |
--          4|Talbot        |         |
--          5|Sheila-kathryn|Calton   |
--          6|Curr          |Duckhouse|
--          7|Fina          |Merali   |
--          8|Rod           |Inder    |
--          9|Mala          |Lind     |
--         10|Fiorenze      |Birdall  |


------------------------------------------------------------------------------
-- 6. Вывести всех клиентов, у которых нет транзакций.

select 
	c.customer_id
	, c.first_name 
	, c.last_name 
--	count(c.customer_id)
from customer c 
left join "transaction" t on c.customer_id = t.customer_id 
where t.customer_id is null
;

--customer_id|first_name|last_name   |
-------------+----------+------------+
--        852|Andie     |Bonney      |
--        869|Addia     |Abels       |
--       1373|Shaylynn  |Epsley      |
--...

--count|
-------+
--  507|


------------------------------------------------------------------------------
-- 7. Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.

select 
	c.customer_id 
	, c.first_name 
	, c.last_name 
	, t.standard_cost 
--	count(*)
from customer c 
join "transaction" t on c.customer_id = t.customer_id 
where t.standard_cost  = (
	select 
		max(tsc.standard_cost) as max_cost
	from "transaction" tsc
)
order by 2, 3, 1
;

--customer_id|first_name|last_name          |standard_cost|
-------------+----------+-------------------+-------------+
--       3473|Sanderson |Alloway            |     175985.0|
--       2135|Teador    |Laurant            |     175985.0|
--       3380|Abe       |Ealam              |     175985.0|
--...

--count|
-------+
--  195|


------------------------------------------------------------------------------
-- 8. Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные 
-- транзакции за период '2017-07-07' по '2017-07-17'.

select 
	c.customer_id 
	, c.first_name 
	, c.last_name 
--	count(*)
from customer c
join (
	select
		t.customer_id 
		, t.transaction_date 
		, t.order_status
	from "transaction" t 
	where t.transaction_date >= '2017-07-07'
		and t.transaction_date < '2017-07-18'
		and t.order_status = 'Approved'
) as n on c.customer_id = n.customer_id
where c.job_industry_category in ('IT', 'Health')
order by 2, 3, 1
;

--customer_id|first_name   |last_name  |
-------------+-------------+-----------+
--       1538|Ahmed        |Edmondson  |
--        320|Aldous       |Cubin      |
--       1231|Aloisia      |Shawel     |
--...

--count|
-------+
--  124|

