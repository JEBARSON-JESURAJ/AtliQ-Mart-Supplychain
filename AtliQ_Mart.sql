SELECT * FROM dim_customers
--Group by actual_delivery_date
LIMIT 5;

--OT, IF, OTIF Metrics on daily basis
 
SELECT actual_delivery_date, (ROUND(AVG("In Full"),2))*100 AS "In_Full",
    (ROUND(AVG("On Time"),2))*100 AS "On_Time",
    (ROUND(AVG("On Time In Full"),2))*100 AS "On Time In_Full"
FROM fact_order_lines
GROUP BY actual_delivery_date;

--Customer wise metrics
SELECT ol.customer_id, c.customer_name,
    (ROUND(AVG(ol."In Full"),2))*100 AS "In_Full",
    (ROUND(AVG(ol."On Time"),2))*100 AS "On_Time",
    (ROUND(AVG(ol."On Time In Full"),2))*100 AS "On Time In_Full"
FROM fact_order_lines AS ol
INNER JOIN dim_customers AS c
USING(customer_id)
GROUP BY ol.customer_id, c.customer_name;

--City wise metrics
SELECT c.city,
    (ROUND(AVG(ol."In Full"),2))*100 AS "In_Full",
    (ROUND(AVG(ol."On Time"),2))*100 AS "On_Time",
    (ROUND(AVG(ol."On Time In Full"),2))*100 AS "On Time In_Full"
FROM fact_order_lines AS ol
INNER JOIN dim_customers AS c
USING(customer_id)
GROUP BY c.city;