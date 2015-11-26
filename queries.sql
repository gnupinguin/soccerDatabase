1. --Вывести идентификатор, фамилию, и имя игроков, получивших  предупреждения в матчах, и колличество этих предупреждений. Вывети игроков в порядке "агрессивности"
	SELECT pl.player_id, pl.last_name, pl.first_name, COUNT(pl.player_id) AS cnt 
	FROM warnings AS w 
	INNER JOIN players AS pl ON w.player_id = pl.player_id
	GROUP BY pl.player_id
	ORDER BY cnt DESC;

Необходимость:
Поиск самых агрессивных игроков и степень их агрессивности(количество предупреждений. Не агрессивные игроки - игроки без предупреждений)

Оптимизация:
Не требуется, так как значения сравниваются по первичным ключам
	
2. --Выбрать дату рождения самого молодого игрока, отдавшего голевую передачу.
	SELECT players.first_name,players.last_name, players.birth_date FROM players 
	INNER JOIN (SELECT MAX(tb1.birth_date) AS mbd FROM
	(SELECT pl.player_id, pl.last_name, pl.first_name, pl.birth_date FROM players AS pl
	INNER JOIN assists ON (assists.player_id = pl.player_id)) AS tb1) AS tb2 ON players.birth_date = tb2.mbd;

Необходимость:
Найти подающего надежды молодого распасовщика

Оптимизация: добавден индекс
CREATE INDEX players_birth_date_idx ON players (birth_date);	
	

3. --Выбрать идентификатор, имя, фамилию игрока, а так же  количество забитых им голов в указаном чемпионате. Вывести в порядке большинства забитых голов

	SELECT pl.player_id, pl.last_name, pl.first_name, COUNT(pl.player_id) AS cnt 
	FROM players AS pl 
	INNER JOIN goals AS g ON (pl.player_id = g.player_id) 
	INNER JOIN matchs AS m ON (m.match_id = g.match_id)
	INNER JOIN tournament AS t ON (t.tournament_id = m.tournament_id) AND (t.name = _CHAMPIONSHIP_)
	GROUP BY pl.player_id
	ORDER BY cnt DESC;

Необходимость:
Просмотреть таблицу бомбардиров указанного чемпионата
Допустимые параметры  _CHAMPIONSHIP_:
('Chempionat Rossii 2014/2015'), ('Kubok Rossii 2014/2015'), ('Kubok Pervogo kanala')
(т. е. значения колонки tournament.name)

Оптимизация: 
не требуется, так как сравнения происходят по первичным и уникальным ключам.




4. --Выбрать идентификатор, название и средний возраст(округленный до сотых) команды. Команды разместить в порядке старшинства
	SELECT t.team_id, t.name, round(AVG((current_date - p.birth_date)/365), 2)  AS age
	FROM team AS t 
	INNER JOIN players AS p ON t.team_id = p.team_id
	GROUP BY t.team_id ORDER BY age DESC;

Необходимость:
Просмотреть соотношения средних возрастов каждой комманды. 
Оптимизация:
не требуется, так как сравнения происходят по первичным ключам	

5. --Выбрать тип покрытия футбольного поля на стадионе и количество травм, произошедших на данном покрытии
	SELECT s.type_lawn, COUNT(s.type_lawn)
	FROM matchs AS m 
	INNER JOIN stadium AS s ON m.stadium_id = s.stadium_id
	INNER JOIN trauma AS t ON t.match_id = m.match_id
	GROUP BY s.type_lawn;

Необходимость:
Определить статистику по количеству травм на определённом покрытии стадиона
Оптимизация:
не требуется, так как сравнения происходят по первичным ключам
