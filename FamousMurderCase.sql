--Firstly, after importing the Police department database into the SQLite relational database system (RDBMS), 
--I began by analyzing the key clues: "murder", "SQL City", and the date ''Jan.15, 2018''. Using these keywords, I queried the relevant tables to 
--uncover initial details about the crime. Each accurate query led me deeper into the case that reveals more information about 
--the witnesses (Annabel Miller and Morty Schapiro), the killer’s last known location, and even the car model linked to the suspect.

--Step 1: Examine the Crime Scene Report
SELECT *
FROM crime_scene_report
WHERE type= 'murder' and city = 'SQL City'
--Security footage shows that there were 2 witnesses. The first witness lives at the last house on "Northwestern Dr". The second witness, named Annabel, lives somewhere on "Franklin Ave".

--Step 2: Retrieve the First Witness Statement
SELECT person.id,person.name,person.address_number,person.address_street_name,interview.transcript
FROM person 
JOIN interview
ON person.ID = interview.person_id
WHERE address_street_name LIKE 'Northwestern Dr'
ORDER BY address_number DESC;
--First witness statement: I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. The membership number on the bag started with "48Z". 
--Only gold members have those bags. The man got into a car with a plate that included "H42W".

--Step 3: Analyze the Second Witness Clue
SELECT person.id,person.name,person.address_number,person.address_street_name,interview.transcript
FROM person
JOIN interview
ON person.ID = interview.person_id
WHERE name like 'Annabel%';
--Second witness statement: I saw the murder happen, and I recognized the killer from my gym when I was working out last week on January the 9th.

--Step 4: Analyze the First Witness Clue
SELECT get_fit_now_check_in.membership_id,get_fit_now_check_in.check_in_time,get_fit_now_check_in.check_out_time,get_fit_now_member.person_id,get_fit_now_member.name,get_fit_now_member.membership_status
FROM get_fit_now_check_in
JOIN get_fit_now_member
ON get_fit_now_check_in.membership_id = get_fit_now_member.id
WHERE get_fit_now_check_in.membership_id LIKE '48Z%'AND get_fit_now_member.membership_status = 'gold';
--From the analysis, we could only obtain details on two membership ID, Person ID, check in and check out time.

--Step 5: Analyze the First Witness’s Second Clue – Vehicle Details
SELECT drivers_license.id,person.license_id,person.name,drivers_license.gender,drivers_license.plate_number,interview.transcript
FROM drivers_license
join person
on drivers_license.id = person.license_id
JOIN interview on person.id = interview.person_id
WHERE drivers_license.plate_number LIKe '%H42W%';
--From the analysis, it reveals the details of Jeremy Bowers(License ID and Gender). He is identified as the killer. He leaves a clue on who hired 
--him to execute the murder.

--Step 6: Analyze the Second Witness Clue; Gym Activities
SELECT get_fit_now_check_in.membership_id,get_fit_now_check_in.check_in_date,get_fit_now_check_in.check_out_time,get_fit_now_member.person_id,get_fit_now_member.name,get_fit_now_member.membership_status
FROM get_fit_now_check_in
JOIN get_fit_now_member
ON get_fit_now_check_in.membership_id = get_fit_now_member.id
WHERE get_fit_now_check_in.check_in_date = 20180109 and get_fit_now_member.membership_status = 'gold'and get_fit_now_check_in.membership_id LIKE '48Z%';
--From the analysis, it reveals the same details in Step 4. 

--Step 7: Analyze the Hired Killer(Jeremy Bower's Clue) – Final Identification
SELECT drivers_license.id,drivers_license.height,drivers_license.hair_color,drivers_license.gender,drivers_license.car_make,person.id,person.name,facebook_event_checkin.event_name,facebook_event_checkin.date
FROM drivers_license
JOIN person
on drivers_license.id = person.license_id
JOIN facebook_event_checkin
ON person.id= facebook_event_checkin.person_id
WHERE height BETWEEN 65 and 67 AND hair_color='red'AND car_make = 'Tesla'
--After a thorough investigation involving multiple SQL queries across the crime scene, witness interviews, personal records, and
--activity logs, all evidence pointed to a single individual.Jeremy Bowers as the Killer,However, further investigations on the clue submitted by Jeremy Bowers revealed
--that he was hired by Miranda Priestly.