# Реляционные базы данных. Проектирование баз данных MySQL. Задание 1

Реализовать:
1. Цену и валюту (доллар, евро, грн)
2. Города
3. Типы транспорта: легковые, мото, грузовики и т.д.
 
Решение: [MySQLTest.sql](https://github.com/fuarfoile/MySQLTest/blob/main/MySQLTest.sql)

1. Цена реализована изначально. Валюта сделана по аналогии с марками, но вместо имени здесь служит трёхбуквенный алфавитный (alfa-3) ISO код валюты, что отлично подходит под char с неизменной длинной.
```sql
CREATE TABLE `ria_currencies` (
  `currency_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `iso` char(3) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`currency_id`),
  UNIQUE KEY `iso_UNIQUE` (`iso`)
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;
```

2. Города реализованы полностью по аналогии с марками.
```sql
CREATE TABLE `ria_cities` (
  `city_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`city_id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) 
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;
```

3. Типы транспорта реализованы как отношение «многие ко многим», так как одна машина может запросто подходить в несколько категорий. Скажем, Jaguar I-PACE можно занести как в категорию "SUV", так и в категорию "Электромобиль".
```sql
CREATE TABLE `ria_types` (
  `type_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(45) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE `ria_model_types` (
  `model_type_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `model_id` INT UNSIGNED NOT NULL,
  `type_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`model_type_id`),
  CONSTRAINT `model_id` FOREIGN KEY (`model_id`) REFERENCES `ria_models` (`model_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `type_id` FOREIGN KEY (`type_id`) REFERENCES `ria_types` (`type_id`) ON DELETE CASCADE ON UPDATE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
```
Диаграмма базы:  

![Diagram](https://user-images.githubusercontent.com/13166188/110364860-fdde3480-804c-11eb-915b-aeba22a37922.png)


# Реляционные базы данных. Работа с базами данных MySQL. Задание 2

Найти:
1. Все авто из Винницы
2. Количество авто по каждому городу
3. Количество различных моделей по каждому городу и среднюю цену  

Решение:
1. [MySQLTest1.sql](https://github.com/fuarfoile/MySQLTest/blob/main/MySQLTest1.sql)  
Присоединяем таблицу городов к авто и фильтруем нужные по названию города:
```sql
SELECT auto_id, user_id, mark_id, model_id, version, price, ci.name AS city
FROM test.ria_auto
INNER JOIN test.ria_cities ci USING (city_id)
WHERE `name`='Vinnytsia'
```
Если знаем id искомого города, то можно сразу вывести без присоединений (в моем случае id для Винницы = 2):
```sql
SELECT * FROM test.ria_auto WHERE `city_id`=2
```

2. [MySQLTest2.sql](https://github.com/fuarfoile/MySQLTest/blob/main/MySQLTest2.sql)  
Группируем авто по городам и подсчитываем количество вхождений через count():
```sql
SELECT ci.name, count(*) as count FROM test.ria_auto
INNER JOIN test.ria_cities ci USING(city_id)
GROUP BY city_id;
```  

3. [MySQLTest3_1.sql](https://github.com/fuarfoile/MySQLTest/blob/main/MySQLTest3_1.sql)  
Если трактовать условие как "количество различных моделей по каждому городу и среднюю цену авто по каждому городу":  
Аналогично заданию №2, группируем авто по городам, но считаем только уникальные значение моделей, что даст нам "количество различных моделей по каждому городу". Среднюю цену считаем через avg(price):
```sql
SELECT ci.name, count(distinct model_id) as 'models count', avg(price) as 'avg price' FROM test.ria_auto
INNER JOIN test.ria_cities ci USING(city_id)
GROUP BY city_id;
```  
[MySQLTest3_2.sql](https://github.com/fuarfoile/MySQLTest/blob/main/MySQLTest3_2.sql)  
Если же трактовать как "количество авто каждой марки по каждому городу и среднюю цену авто по марке в каждом городе":  
Группируем по городу и по модели, считаем количество вхождений. Среднюю цену, аналогично, считаем через avg(price):
```sql
SELECT ci.name, mo.name, count(*) as count, avg(price) as 'avg price' FROM test.ria_auto
INNER JOIN test.ria_cities ci USING(city_id)
INNER JOIN test.ria_models mo USING(model_id)
GROUP BY city_id, model_id;
```  
