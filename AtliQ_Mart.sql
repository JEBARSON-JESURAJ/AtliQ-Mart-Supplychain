--OT, IF, OTIF Metrics on daily basis
 
SELECT order_placement_date, (ROUND(AVG(in_full),2))*100 AS "Actual_In_Full",
    (ROUND(AVG("on_time"),2))*100 AS "Actual_On_Time",
    (ROUND(AVG("on_time_in_full"),2))*100 AS "On_Time_In_Full"
FROM fact_orders_aggregate
GROUP BY order_placement_date;

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
        AVG(ol."In Full")*100 AS "Actual_InFull",
        AVG(ol."On Time")*100 AS "Actual_OnTime",
        AVG(ol."On Time In Full")*100 AS "Actual_OnTime_InFull"
    FROM fact_order_lines AS ol
    INNER JOIN dim_customers AS c
    USING(customer_id) 
    GROUP BY ol.customer_id,c.city) AS sq
USING (customer_id)
GROUP BY sq.city;