--BREVORY M. FOSTER

DROP TABLE trips;
DROP TABLE riders;
DROP TABLE cars;

--This will be the parent table that gets split into 3 tables in order to have more relevant data per table
CREATE TABLE trips(
id integer ,
date date, 
pickup text,
dropoff text, 
rider_id integer,
car_id integer, 
type text,
cost integer,
first text, 
last text,
username text, 
rating integer,
total_trips integer, 
referred integer,
model text, 
OS text,
status text, 
trips_completed integer
);

INSERT INTO trips
VALUES (1001, '2017-12-05', '06:45', '07:10', 102,1, 'X', 28.66, 'Laura', 'Breiman', '@lauracle', 4.99, 687, 101, 'Ada', 'Ryzac', 'active', 82),
(1002, '2017-12-05', '08:00', '08:15', 101, 3, 'POOL', 9.11, 'Sonny', 'Li', '@sonnynomnom', 4.66, 352, null, 'Turing XL', 'Ryzac', 'active', 164),
(1003, '2017-12-05', '09:30', '09:50', 104,	4, 'X', 24.98, 'Yakov', 'Kagan', '@yakovkagan',	4.52, 1910, 103, 'Akira', 'Finux', 'maintenance', 22),
(1004, '2017-12-05', '13:40', '14:05', 105, 1, 'X', 31.27, null, null, null, null, null, null, 'Ada', 'Ryzac', 'active', 82),
(1005, '2017-12-05', '15:15', '16:00', 103, 2, 'POOL', 18.95, 'Kassa', 'Korley', '@kassablanca', 4.63, 42, null, 'Ada', 'Ryzac', 'active', 30),
(1006, '2017-12-05', '18:20', '18:55', 101, 3, 'XL', 78.52, 'Sonny', 'Li', '@sonnynomnom', 4.66, 352, null, 'Turing XL', 'Ryzac', 'active', 164);

--2nd table that will be used
CREATE TABLE riders(
	id integer,
	first text, 
	last text,
	username text, 
	rating integer,
	total_trips integer, 
	referred integer
);

INSERT INTO riders
SELECT DISTINCT rider_id, first, last, username, rating, total_trips, referred
FROM trips;

--3rd table that will be used
CREATE TABLE cars(
	id integer,
	model text, 
	OS text,
	status text, 
	trips_completed integer
);

INSERT INTO cars
SELECT DISTINCT car_id, model, OS, status, trips_completed
FROM trips;

--Adjusts the first table to have relevant data
ALTER TABLE trips
DROP COLUMN first,
DROP COLUMN last,
DROP COLUMN username,
DROP COLUMN rating,
DROP COLUMN total_trips,
DROP COLUMN referred,
DROP COLUMN model,
DROP COLUMN OS,
DROP COLUMN status,
DROP COLUMN trips_completed;

ALTER TABLE riders ADD PRIMARY KEY (id);

ALTER TABLE cars ADD PRIMARY KEY (id);

ALTER TABLE trips ADD PRIMARY KEY(id);
ALTER TABLE trips ADD FOREIGN KEY (rider_id) REFERENCES riders(id);
ALTER TABLE trips ADD FOREIGN KEY (car_id) REFERENCES cars(id);

--This Query will produce a trip log that will have columns of the trip and its user
SELECT trips.date, 
   trips.pickup, 
   trips.dropoff, 
   trips.type, 
   trips.cost,
   riders.first, 
   riders.last,
   riders.username
FROM trips
LEFT JOIN riders 
  ON trips.rider_id = riders.id;

--This Query will link the trips and cars used during the trips
SELECT *
FROM trips
JOIN cars
  ON trips.car_id = cars.id;
  
--Average cost of the trip  
SELECT AVG(cost)
FROM trips;

--REBU wants to email the irregular users of the app. This Query produces the users who have completed less than 500 trips
SELECT *
FROM riders
WHERE total_trips < 500;

--Cars thats integrity needs to be checked because they have been on the road for a while. This Query produces the top 2 cars with the most trips completed
SELECT *
FROM cars
ORDER BY trips_completed DESC
LIMIT 2;



