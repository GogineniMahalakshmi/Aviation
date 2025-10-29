create database Aviation;

use aviation;

select count(*) from flights;

select * from flights;

select * from airlines;

select * from airports;

select * from flights where departure_delay = 0;

show variables like 'secure_file_priv';

show variables like 'local_infile';

set global local_infile =ON;

create table flights(
YEAR int,
MONTH int,
DAY int,
DAY_OF_WEEK tinyint,
AIRLINE varchar (10),
FLIGHT_NUMBER int,
TAIL_NUMBER	varchar (10),
ORIGIN_AIRPORT varchar (10),
DESTINATION_AIRPORT varchar (10),
SCHEDULED_DEPARTURE	int,
DEPARTURE_TIME int,
DEPARTURE_DELAY	int,
TAXI_OUT int,
WHEELS_OFF	int,
SCHEDULED_TIME int,
ELAPSED_TIME int,
AIR_TIME int,
DISTANCE int,
WHEELS_ON int,
TAXI_IN	int,
SCHEDULED_ARRIVAL int,
ARRIVAL_TIME int,
ARRIVAL_DELAY int,
DIVERTED tinyint,
CANCELLED tinyint,
CANCELLATION_REASON	char(1),
AIR_SYSTEM_DELAY int,
SECURITY_DELAY int,
AIRLINE_DELAY int,
LATE_AIRCRAFT_DELAY int,
WEATHER_DELAY int
);

load data local infile 'D:/project/Dataset/DA-P894- Aviation/flights.csv' into table flights fields terminated by ',' enclosed by '"' lines terminated by '\n'
ignore 1 rows;

load data local infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/flights.csv' into table flights fields terminated by ',' enclosed by '"' lines terminated by '\n'
ignore 1 rows;

drop table flights;

select * from flights where distance between 2500 and 3000 and Arrival_delay = 0 and departure_delay = 0;

----------------- 1st KPI -----------------------------------------------------------------

Select
case
when day_of_week in (1,7) then 'Weekend'
Else
'weekday'
END AS WDvsWE, concat(round(count(Flight_Number)/1000000,2),'M') as Total_FLIGHTS from flights group by WDvsWE;

----------------- 2nd KPI -----------------------------------------------------------------
SELECT 
    a.airline AS Airline,
    f.month AS Month,
    COUNT(*) AS Total_Cancelled_Flights
FROM flights f
JOIN airlines a 
    ON f.airline = a.IATA_CODE
WHERE 
    a.airline = 'JetBlue Airways'
    AND f.cancelled = 1
    AND f.day = 1
GROUP BY 
    a.airline, f.month
ORDER BY f.month;

----------------- 3rd KPI -----------------------------------------------------------------

SELECT 
    f.day_of_week AS Week_Day,
    a.state AS State,
    a.city AS City,
    ROUND(AVG(f.arrival_delay), 2) AS Avg_Arrival_Delay,
    ROUND(AVG(f.departure_delay), 2) AS Avg_Departure_Delay,
    COUNT(*) AS Total_Flights
FROM flights f
JOIN airports a 
    ON f.origin_airport = a.IATA_CODE
GROUP BY 
    f.day_of_week, a.state, a.city, a.IATA_CODE
ORDER BY 
    f.day_of_week, a.state, a.city;
    
----------------- 4th KPI -----------------------------------------------------------------
select
a.airline as Airlines,
count(a.airline) as Count_No_Delay,
count(f.arrival_delay) as Arrival_Delay,
count(f.departure_delay) as Departure_Delay
from flights f
join airlines a
on f.airline = a.IATA_CODE
where
f.distance between 2500 and 3000
and f.arrival_delay = 0
and f.departure_delay = 0
group by
a.airline;

----------------- 5th KPI -----------------------------------------------------------------
    
call Top10_Cities_NoDelay('PA');



