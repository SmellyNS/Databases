-- Базы данных
-- РК №1
-- Лумбунов Д.В. ИУ7-54Б

-- ЗАДАНИЕ 1

-- 1)

select ID, FirstName, LastName from (
select T.ID, T.FirstName, T.LastName, Country from
Sights S join Cities C on S.CityID = C.CityID as SC 
	join ST on ST.SightID = SC.ID as STSC
		join Tourists T on STSC.TouristID = T.ID
	group by T.ID, T.FirstName, T.LastName, Country)
group by T.ID, T.FirstName, T.LastName having count(*) > 1

-- 2)

select ammount from (
select C.CityID, C.Name, count(*) as amount from
Cities C join Sights S on C.CityID = S.CityID 
group by C.CityID, C.Name) as CS
where CS.Name = 'Milan'

-- 3)

select T.ID, T.FirstName, T.LastName from (
select * from
	Sights S join Cities C on S.CityID = C.CityID
	where C.Name = 'Paris') as P
	join ST on P.ID = ST.SightID as PST
	join Tourists T on PST.TouristID = T.ID


-- ЗАДАНИЕ 2

/*
F{A->BC, A->D, CD->E}
G{A->BCE, A->BD, CD->E}
R{A,B,C,D,E}

1){A}+ = {A,B,C,D,E} 		A -> BCE, A -> BD
  {CD}+ = {C,D,E}           CD -> E

2){A}+ = {A,B,C,D,E} 		A -> BC, A -> D, CD -> E
  {CD}+ = {C,D,E}           CD -> E
  
			НЕ ЭКВИВАЛЕНТНЫ
*/

