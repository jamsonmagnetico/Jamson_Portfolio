#Create Table from CSV file
#Uploaded using import tool in Postgre SQL

CREATE TABLE Ph_Covid_data(
	CaseCode VARCHAR,
	Age VARCHAR,
	AgeGroup VARCHAR,
	Sex VARCHAR,
	DateSpecimen VARCHAR,
	DateResultRelease VARCHAR,
	DateRepConf VARCHAR,
	DateDied VARCHAR,
	DateRecover VARCHAR,
	RemovalType VARCHAR,
	Admitted VARCHAR,
	RegionRes VARCHAR,
	ProvRes VARCHAR,
	CityMunRes VARCHAR,
	CityMuniPSGC VARCHAR,
	BarangayRes VARCHAR,
	BarangayPSGC VARCHAR,
	HealthStatus VARCHAR,
	Quarantined VARCHAR,
	DateOnset VARCHAR,
	Pregnanttab VARCHAR,
	ValidationStatus VARCHAR
)



#Covid-19 infection count per province

SELECT
	DISTINCT provres,
	COUNT (healthstatus) OVER (PARTITION BY provres ORDER BY provres) infection_count_per_province
FROM Ph_Covid_data
WHERE healthstatus IS NOT NULL AND provres IS NOT NULL
ORDER BY infection_count_per_province DESC

--Covid-19 recovery count per province

SELECT
	DISTINCT provres,
	COUNT (healthstatus) OVER (PARTITION BY provres ORDER BY provres) recovery_count_per_province
FROM Ph_Covid_data
WHERE healthstatus = 'RECOVERED' AND provres IS NOT NULL
ORDER BY recovery_count_per_province DESC


--Covid-19 death count per province

SELECT
	DISTINCT provres,
	COUNT (healthstatus) OVER (PARTITION BY provres ORDER BY provres) death_count_per_province
FROM Ph_Covid_data
WHERE healthstatus = 'DIED' AND provres IS NOT NULL
ORDER BY death_count_per_province DESC


--Health status on Bulacan Province

SELECT 
	healthstatus AS Health_Status_Bulacan,
	COUNT (healthstatus) AS Quantity
FROM Ph_Covid_data
WHERE provres = 'BULACAN'
GROUP BY healthstatus 
ORDER BY quantity DESC

--Age group breakdown of infected individuals at bulacan
	
SELECT
	DISTINCT agegroup AS agegroup_affected_bulacan,
	COUNT (agegroup) OVER (PARTITION BY agegroup ORDER BY agegroup) count_per_group
FROM Ph_Covid_data
WHERE provres = 'BULACAN' AND agegroup IS NOT NULL
ORDER BY agegroup


--Breakdown of covid-19 deaths in Bulacan (Municipality order)
	
SELECT
	DISTINCT citymunres,
	COUNT (healthstatus) OVER (PARTITION BY citymunres ORDER BY citymunres) death_count_per_municipality
FROM Ph_Covid_data
WHERE healthstatus = 'DIED' AND provres = 'BULACAN'
ORDER BY death_count_per_municipality DESC


--Breakdown of infected people in Bulacan (Municipality order)
	
SELECT
	DISTINCT citymunres,
	COUNT (healthstatus) OVER (PARTITION BY citymunres ORDER BY citymunres) infected_count_per_municipality
FROM Ph_Covid_data
WHERE provres = 'BULACAN' AND citymunres IS NOT NULL
ORDER BY infected_count_per_municipality DESC

	
--Breakdown of covid-19 recovery in Bulacan (Municipality order)
	
SELECT
	DISTINCT citymunres AS bulacan_municipalities,
	COUNT (healthstatus) OVER (PARTITION BY citymunres ORDER BY citymunres) recovery_count_per_municipality
FROM Ph_Covid_data
WHERE healthstatus = 'RECOVERED' AND provres = 'BULACAN' AND citymunres IS NOT NULL
ORDER BY recovery_count_per_municipality DESC

--Progression of Covid-19 per month since 2020
	
SELECT
	provres,
	CAST (datespecimen AS date),
	COUNT (datespecimen) OVER (PARTITION BY datespecimen ORDER BY datespecimen)number_of_cases
FROM Ph_Covid_data
WHERE provres = 'BULACAN'





