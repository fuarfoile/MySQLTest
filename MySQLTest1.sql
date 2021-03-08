SELECT auto_id, user_id, mark_id, model_id, version, price, ci.name AS city
FROM test.ria_auto
INNER JOIN test.ria_cities ci USING (city_id)
WHERE `name`='Vinnytsia'

#SELECT * FROM test.ria_auto WHERE `city_id`=2