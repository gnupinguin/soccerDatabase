1. --Вывести таблицу игроков, получивших  предупреждения в матчах, и колличество этих предупреждений
	SELECT pl.player_id, pl.last_name, pl.first_name, COUNT(pl.player_id) AS cnt 
	FROM warnings AS w 
	INNER JOIN players AS pl ON w.player_id = pl.player_id
	GROUP BY pl.player_id
	ORDER BY cnt DESC;
	
	
2. --Выбрать дату рождения самого молодого игрока, отдавшего голевую передачу.

	SELECT MAX(tb1.birth_date) FROM
	(SELECT pl.player_id, pl.last_name, pl.first_name, pl.birth_date FROM players AS pl
	INNER JOIN assists ON (assists.player_id = pl.player_id)) AS tb1;
	
	

3. --Вывести таблицу(идентификатор, имя, фамилия, количество голов) бомбардиров чемпионата России по футболу 2014/2015.

	SELECT pl.player_id, pl.last_name, pl.first_name, COUNT(pl.player_id) AS cnt 
	FROM players AS pl 
	INNER JOIN goals AS g ON (pl.player_id = g.player_id)AND( g.player_id IS NOT NULL) 
	INNER JOIN matchs AS m ON (m.match_id = g.match_id)
	INNER JOIN tournament AS t ON (t.tournament_id = m.tournament_id) AND (t.name = 'Chempionat Rossii 2014/2015')
	GROUP BY pl.player_id
	ORDER BY cnt DESC;
	
	
4. --Bывести средний возраст(округленный до сотых) каждой комманды. Команды разместить в порядке старшинства
	SELECT t.team_id, t.name, round(AVG((current_date - p.birth_date)/365), 2)  AS age
	FROM team AS t 
	INNER JOIN players AS p ON t.team_id = p.team_id
	GROUP BY t.team_id ORDER BY age DESC;
	

5. --Вывести статистику по количеству травм на определённом покрытии стадиона
	SELECT s.type_lawn, COUNT(s.type_lawn)
	FROM matchs AS m 
	INNER JOIN stadium AS s ON m.stadium_id = s.stadium_id
	INNER JOIN trauma AS t ON t.match_id = m.match_id
	GROUP BY s.type_lawn;
