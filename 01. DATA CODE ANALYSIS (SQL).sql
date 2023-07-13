#Create Table for CSV file

Create table Ph_Covid_data(
	CaseCode varchar,
	Age varchar,
	AgeGroup varchar,
	Sex varchar,
	DateSpecimen varchar,
	DateResultRelease varchar,
	DateRepConf varchar,
	DateDied varchar,
	DateRecover varchar,
	RemovalType varchar,
	Admitted varchar,
	RegionRes varchar,
	ProvRes varchar,
	CityMunRes varchar,
	CityMuniPSGC varchar,
	BarangayRes varchar,
	BarangayPSGC varchar,
	HealthStatus varchar,
	Quarantined varchar,
	DateOnset varchar,
	Pregnanttab varchar,
	ValidationStatus varchar
)



--Covid-19 infection count per province

select
	distinct provres,
	count (healthstatus) over (partition by provres order by provres) infection_count_per_province
from Ph_Covid_data
where healthstatus is not null and provres is not null
order by infection_count_per_province desc

--Covid-19 recovery count per province

select
	distinct provres,
	count (healthstatus) over (partition by provres order by provres) recovery_count_per_province
from Ph_Covid_data
where healthstatus = 'RECOVERED' and provres is not null
order by recovery_count_per_province desc


--Covid-19 death count per province

select
	distinct provres,
	count (healthstatus) over (partition by provres order by provres) death_count_per_province
from Ph_Covid_data
where healthstatus = 'DIED' and provres is not null
order by death_count_per_province desc


--Health status on Bulacan Province

select 
	healthstatus as Health_Status_Bulacan,
	count (healthstatus) as Quantity
from Ph_Covid_data
where provres = 'BULACAN'
group by healthstatus 
order by quantity desc

--Age group breakdown of infected individuals at bulacan
select
	distinct agegroup as agegroup_affected_bulacan,
	count (agegroup) over (partition by agegroup order by agegroup) count_per_group
from Ph_Covid_data
where provres = 'BULACAN' and agegroup is not null
order by agegroup


--Breakdown of covid-19 deaths in Bulacan (Municipality order)
select
	distinct citymunres,
	count (healthstatus) over (partition by citymunres order by citymunres) death_count_per_municipality
from Ph_Covid_data
where healthstatus = 'DIED' and provres = 'BULACAN'
order by death_count_per_municipality desc


--Breakdown of infected people in Bulacan (Municipality order)
select
	distinct citymunres,
	count (healthstatus) over (partition by citymunres order by citymunres) infected_count_per_municipality
from Ph_Covid_data
where provres = 'BULACAN' and citymunres is not null
order by infected_count_per_municipality desc

select*
from Ph_Covid_data


--Breakdown of covid-19 recovery in Bulacan (Municipality order)
select
	distinct citymunres as bulacan_municipalities,
	count (healthstatus) over (partition by citymunres order by citymunres) recovery_count_per_municipality
from Ph_Covid_data
where healthstatus = 'RECOVERED' and provres = 'BULACAN' and citymunres is not null
order by recovery_count_per_municipality desc

--Progression of Covid-19 per month since 2020
select
	provres,
	cast (datespecimen as date),
	count (datespecimen) over (partition by datespecimen order by datespecimen)number_of_cases
from Ph_Covid_data
where provres = 'BULACAN'





