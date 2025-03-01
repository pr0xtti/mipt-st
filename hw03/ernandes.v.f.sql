------------------------------------------------------------------------------
-- 1. Вывести распределение (количество) клиентов по сферам деятельности, 
-- отсортировав результат по убыванию количества.
------------------------------------------------------------------------------

select
	c.job_industry_category
	, count(c.customer_id) as count
from customer c
group by c.job_industry_category
order by 2 desc
;

--job_industry_category|count|
-----------------------+-----+
--Manufacturing        |  799|
--Financial Services   |  774|
--n/a                  |  656|
--Health               |  602|
--Retail               |  358|
--Property             |  267|
--IT                   |  223|
--Entertainment        |  136|
--Argiculture          |  113|
--Telecommunications   |   72|


------------------------------------------------------------------------------
-- 2. Найти сумму транзакций за каждый месяц по сферам деятельности, 
-- отсортировав по месяцам и по сфере деятельности.
------------------------------------------------------------------------------

select
    -- date_trunc('month', t.transaction_date::date) as month
    to_char(t.transaction_date, 'YYYY-MM') as month
	, c.job_industry_category
	, sum(t.list_price)
from "transaction" t 
join customer c on t.customer_id  = c.customer_id
group by 1, 2
order by 1, 2
;

--month  |job_industry_category|sum      |
---------+---------------------+---------+
--2017-01|Argiculture          |3918068.0|
--2017-01|Entertainment        |5212721.0|
--2017-01|Financial Services   | 30309562|
--2017-01|Health               | 25680506|
--2017-01|IT                   |8821143.0|
--2017-01|Manufacturing        | 32373363|
--2017-01|n/a                  | 26525200|
--2017-01|Property             |8267860.0|
--2017-01|Retail               | 15283424|
--2017-01|Telecommunications   |2903175.0|
--2017-02|Argiculture          |4956052.0|
--2017-02|Entertainment        |5967127.0|
--2017-02|Financial Services   | 31235544|
--...



------------------------------------------------------------------------------
-- 3. Вывести количество онлайн-заказов для всех брендов в рамках 
-- подтвержденных заказов клиентов из сферы IT.
------------------------------------------------------------------------------

select
    t.brand
    , count(*)
from "transaction" t 
join customer c on t.customer_id  = c.customer_id
where 
    t.online_order is true and t.order_status = 'Approved'
    and c.job_industry_category = 'IT'
group by 1
order by 2 desc
;

--brand         |count|
----------------+-----+
--Solex         |  101|
--Norco Bicycles|   92|
--WeareA2B      |   90|
--Giant Bicycles|   89|
--Trek Bicycles |   82|
--OHM Cycles    |   78|
--              |    8|


------------------------------------------------------------------------------
-- 4. Найти по всем клиентам сумму всех транзакций (list_price), максимум, 
-- минимум и количество транзакций, отсортировав результат по убыванию 
-- суммы транзакций и количества клиентов. 
-- Выполните двумя способами: 
--   - 4.1. используя только group by 
--   - 4.2. и используя только оконные функции. 
-- Сравните результат.
------------------------------------------------------------------------------

-- 4.1. используя только group by
--select count(*) from (
select
    c.customer_id
    , sum(t.list_price) as total_price
    , count(t.transaction_id) as count
    , max(t.list_price) as max_price
    , min(t.list_price) as min_price
from "transaction" t 
join customer c on t.customer_id  = c.customer_id
group by 1
order by 2 desc, 3 desc
; --) as r;

--customer_id|total_price|count|max_price|min_price|
-------------+-----------+-----+---------+---------+
--        941|  1789846.0|   10| 209147.0| 105751.0|
--       1887|  1713393.0|   11| 209147.0|  68863.0|
--       1129|  1676050.0|   13| 199293.0|  17653.0|
--       2788|  1565892.0|   11| 208394.0|  17778.0|
--       1302|  1548720.0|   13| 197736.0|   7116.0|

--count|
-------+
-- 3493|

-- 4.2. и используя только оконные функции.
select 
    r.customer_id
    , r.total_price
    , r.count
    , r.max_price
    , r.min_price
--    count(*)
from (
    select
        c.customer_id
        , sum(t.list_price) over (partition by c.customer_id) as total_price
        , count(t.transaction_id) over (partition by c.customer_id) as count
        , max(t.list_price) over (partition by c.customer_id) as max_price
        , min(t.list_price) over (partition by c.customer_id) as min_price
        , row_number() over (partition by c.customer_id) as row_num
    from "transaction" t 
    join customer c on t.customer_id  = c.customer_id
    order by 2 desc, 3 desc
) as r
where r.row_num = 1
;

--customer_id|total_price|count|max_price|min_price|
-------------+-----------+-----+---------+---------+
--        941|  1789846.0|   10| 209147.0| 105751.0|
--       1887|  1713393.0|   11| 209147.0|  68863.0|
--       1129|  1676050.0|   13| 199293.0|  17653.0|
--       2788|  1565892.0|   11| 208394.0|  17778.0|
--       1302|  1548720.0|   13| 197736.0|   7116.0|

--count|
-------+
-- 3493|
 
-- Сравните результат.

-- Ответ: кол-во записей в результате одинаковое:
--
--count|
-------+
-- 3493|
--count|
-------+
-- 3493|


------------------------------------------------------------------------------
-- 5. Найти имена и фамилии клиентов с минимальной/максимальной суммой 
-- транзакций за весь период (сумма транзакций не может быть null). 
-- Напишите отдельные запросы для минимальной и максимальной суммы.
------------------------------------------------------------------------------

-- 5.1a. min без СТЕ
select
    c.customer_id
    , c.first_name
    , c.last_name
    , t.total_price
from customer c
join (
    select
        customer_id
        , sum(list_price) as total_price
    from transaction
    where list_price is not null
    group by customer_id
) t on c.customer_id = t.customer_id
where t.total_price = (
    select min(total_price)
    from (
        select
            customer_id,
            sum(list_price) as total_price
        from transaction
        where list_price is not null
        group by customer_id
    ) subquery
);

--customer_id|first_name|last_name|total_price|
-------------+----------+---------+-----------+
--       1529|Tansy     |Beltzner |     1810.0|

-- 5.1b. min с СТЕ
with transaction_total as (
    select
        c.customer_id
        , c.first_name
        , c.last_name
        , sum(t.list_price) as total_price
    from transaction t, customer c
    where list_price is not null and c.customer_id = t.customer_id
    group by 1, 2, 3
)
select 
    tt.customer_id
    , tt.first_name
    , tt.last_name
    , tt.total_price
from transaction_total tt
where tt.total_price = (
    select min(total_price)
    from transaction_total 
);


-- 5.2a. max без СТЕ
select
    c.customer_id
    , c.first_name
    , c.last_name
    , t.total_price
from customer c
join (
    select
        customer_id
        , sum(list_price) as total_price
    from transaction
    where list_price is not null
    group by customer_id
) t on c.customer_id = t.customer_id
where t.total_price = (
    select max(total_price)
    from (
        select
            customer_id,
            sum(list_price) as total_price
        from transaction
        where list_price is not null
        group by customer_id
    ) subquery
);

--customer_id|first_name|last_name|total_price|
-------------+----------+---------+-----------+
--        941|Tye       |Doohan   |  1789846.0|

-- 5.2b. max с СТЕ
with transaction_total as (
    select
        c.customer_id
        , c.first_name
        , c.last_name
        , sum(t.list_price) as total_price
    from transaction t, customer c
    where list_price is not null and c.customer_id = t.customer_id
    group by 1, 2, 3
)
select 
    tt.customer_id
    , tt.first_name
    , tt.last_name
    , tt.total_price
from transaction_total tt
where tt.total_price = (
    select max(total_price)
    from transaction_total 
);

--customer_id|first_name|last_name|total_price|
-------------+----------+---------+-----------+
--        941|Tye       |Doohan   |  1789846.0|
        
        
------------------------------------------------------------------------------
-- 6. Вывести только самые первые транзакции клиентов. Решить с помощью 
-- оконных функций.
------------------------------------------------------------------------------

select
    r.customer_id
    , r.first_name 
    , r.last_name
    , r.transaction_id
    , r.list_price
from (
    select 
        c.customer_id
        , c.first_name 
        , c.last_name
        , t.transaction_id
        , t.transaction_date
        , t.list_price
        , row_number() over (partition by c.customer_id order by t.transaction_date) as rn
    from customer c
    join transaction t on c.customer_id = t.customer_id
) r
where rn = 1;

--customer_id|first_name    |last_name    |transaction_id|list_price|
-------------+--------------+-------------+--------------+----------+
--          1|Laraine       |Medendorp    |          9785|    3604.0|
--          2|Eli           |Bockman      |          2261|   14035.0|
--          3|Arlin         |Dearle       |         10302|  131144.0|
--          4|Talbot        |             |         12441|   56956.0|
--          5|Sheila-kathryn|Calton       |          2291|   68863.0|
--...


------------------------------------------------------------------------------
-- 7. Вывести имена, фамилии и профессии клиентов, между транзакциями которых 
-- был максимальный интервал (интервал вычисляется в днях)
------------------------------------------------------------------------------

select 
	c.first_name
	, c.last_name
	, c.job_title 
	, t_max.max_gap
from customer c
join (
    select 
		customer_id
		, max(transaction_gap) as max_gap
    from (
        select 
            customer_id
            , transaction_date - lag(transaction_date) over (
                partition by customer_id order by transaction_date
            ) as transaction_gap
        from transaction
    ) subquery
    where transaction_gap is not null
    group by customer_id
    order by max_gap desc
    limit 1
) t_max on c.customer_id = t_max.customer_id;

--first_name|last_name|job_title      |max_gap|
------------+---------+---------------+-------+
--Susanetta |         |Legal Assistant|    357|

