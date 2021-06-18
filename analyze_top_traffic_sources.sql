USE mavenfuzzyfactory;

-- TASK 1: Find top traffic sources
SELECT  DISTINCT 
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(website_session_id) AS sessions
FROM 
	website_sessions 
WHERE created_at < '2012-04-12'
GROUP BY utm_source, utm_campaign, http_referer
ORDER BY sessions DESC;
-- Top traffic source by far is gsearch nonbrand

-- TASK 2: What are the gsearch nonbrand conversion rate
SELECT * FROM orders;

SELECT 
	utm_source,
    utm_campaign,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS CVR
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2012-04-13' AND
    utm_source = 'gsearch' AND
    utm_campaign = 'nonbrand';
-- 3% of session covert to sale and revenue

-- TASK 3: PULL gsearch nonbrand trended session volume, by week, to see if the bid changes have caused colume to drop
SELECT
	MIN(DATE(website_sessions.created_at)) as week_created,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS CVR    
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-05-10'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY WEEK(website_sessions.created_at)
;
-- we can see a drop since gsearch was bid down on '2012-04-15', that indicates gsearch nonbrand is fairly sensitive to change

-- TASK 4: pull conversion rates from session to order by device type

SELECT
	device_type,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS cvr
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at < '2012-05-11'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY device_type;

SELECT 
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mob_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS dtop_sessions
FROM 
	website_sessions
WHERE created_at BETWEEN '2012-04-15' AND '2012-06-09'
	AND utm_source = 'gsearch' 
    AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at)

-- desktop has increased thanks to the big changes made based on the conversion analysis