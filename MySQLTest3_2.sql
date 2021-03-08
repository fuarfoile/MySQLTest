SELECT ci.name, mo.name, count(*) as count, avg(price) as 'avg price' FROM test.ria_auto
INNER JOIN test.ria_cities ci USING(city_id)
INNER JOIN test.ria_models mo USING(model_id)
GROUP BY city_id, model_id;