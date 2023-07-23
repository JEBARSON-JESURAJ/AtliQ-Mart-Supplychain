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

-- Getting metrics customerwise (Target Vs Actual)
SELECT tar.customer_id, sq.customer_name,
    tar."infull_target%" AS "Target_Infull", sq."Actual_InFull",
    tar."ontime_target%" AS "Target_OnTime", sq."Actual_OnTime",
    tar."ontime_target%" AS "Target_OnTime_InFull",sq."Actual_OnTime_InFull"
FROM dim_targets_orders AS tar
INNER JOIN (
    SELECT ol.customer_id, c.customer_name,
        (ROUND(AVG(ol."In Full"),2))*100 AS "Actual_InFull",
        (ROUND(AVG(ol."On Time"),2))*100 AS "Actual_OnTime",
        (ROUND(AVG(ol."On Time In Full"),2))*100 AS "Actual_OnTime_InFull"
    FROM fact_order_lines AS ol
    INNER JOIN dim_customers AS c
    USING(customer_id) 
    GROUP BY ol.customer_id, c.customer_name) AS sq
USING (customer_id);

-- Getting metrics city wise (Target Vs Actual)
SELECT sq.city,
    ROUND(AVG(tar."infull_target%"),2) AS "Target_Infull",
    ROUND(AVG(sq."Actual_InFull"),2) AS "Actual_InFull",
    ROUND(AVG(tar."ontime_target%"),2)AS "Target_OnTime",
    ROUND(AVG(sq."Actual_OnTime"),2) AS "Actual_OnTime",
    ROUND(AVG(tar."ontime_target%"),2) AS "Target_OnTime_InFull",
    ROUND(AVG(sq."Actual_OnTime_InFull"),2) AS "Actual_OnTime_InFull"
FROM dim_targets_orders AS tar
INNER JOIN (
    SELECT ol.customer_id, c.city,
        (ROUND(AVG(ol."In Full"),2))*100 AS "Actual_InFull",
        (ROUND(AVG(ol."On Time"),2))*100 AS "Actual_OnTime",
        (ROUND(AVG(ol."On Time In Full"),2))*100 AS "Actual_OnTime_InFull"
    FROM fact_order_lines AS ol
    INNER JOIN dim_customers AS c
    USING(customer_id) 
    GROUP BY ol.customer_id,c.city) AS sq
USING (customer_id)
GROUP BY sq.city;