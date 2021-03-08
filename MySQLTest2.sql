SELECT ci.name, count(*) as count FROM test.ria_auto
INNER JOIN test.ria_cities ci USING(city_id)
GROUP BY city_id;