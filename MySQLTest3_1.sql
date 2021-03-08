SELECT ci.name, count(distinct model_id) as 'models count', avg(price) as 'avg price' FROM test.ria_auto
INNER JOIN test.ria_cities ci USING(city_id)
GROUP BY city_id;