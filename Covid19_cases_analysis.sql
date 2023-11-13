--Using DEATHS table--
SELECT * FROM covid_case.dbo.deaths;

SELECT location FROM covid_case.dbo.deaths;

--Finding the total cases and total deaths in the state of Georgia
SELECT location,date,total_cases, new_cases, total_deaths, population
FROM covid_case.dbo.deaths
WHERE location = 'Georgia' and total_cases IS NOT NULL AND total_deaths IS NOT NULL
ORDER BY 1, 2;

--Finding death rate in % = (deaths/cases)*100--. location in Colombia
SELECT location,date,total_cases,total_deaths, ROUND((total_deaths/CAST(total_cases AS FLOAT))*100, 2) "Percent Death Rate"
FROM covid_case.dbo.deaths
WHERE location = 'Colombia' and total_cases IS NOT NULL AND total_deaths IS NOT NULL
Order by 2;

--Cases per population in % = (total cases/population)*100
SELECT location,date,total_cases,total_deaths, ROUND((CAST(total_cases AS FLOAT)/population)*100, 2) "Infection Rate", ROUND((total_deaths/CAST(total_cases AS FLOAT))*100, 2) "Death Rate"
FROM covid_case.dbo.deaths
WHERE location like '%india%' AND total_deaths IS NOT NULL 
Order by 1,2;

--Highest infection rate
SELECT location,population,MAX(CAST(total_cases AS FLOAT)) as HighestCase,ROUND(MAX(CAST(total_cases AS FLOAT)/population)*100, 2) AS infection_rate
FROM covid_case.dbo.deaths WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY population DESC;

--Highest death per population
SELECT location,population, MAX(total_deaths) as TotalDeath, ROUND(MAX((total_deaths/population)*100), 2) "Death Perpopulation" 
FROM covid_case.dbo.deaths WHERE continent IS NOT NULL 
GROUP BY location,population 
ORDER BY TotalDeath DESC;

--Continentwise data death data
SELECT location,population,MAX(total_deaths) "Total Death"
FROM covid_case.dbo.deaths WHERE continent IS NULL 
GROUP BY location,population 
ORDER BY "Total Death" DESC;

--Exploring Countries with their total cases, total deaths, PercentOfthePopulationInfected, PercentPopulationDead
SELECT location,sum(CAST(new_cases as float)) as TotalCases, sum(CAST(new_deaths as float)) as TotalDeaths, population,
sum(CAST(new_cases as float))/population*100 as PercentPopulationInfected,
sum(CAST(new_deaths as float))/population*100 as PercentPopulationDead
FROM covid_case.dbo.deaths 
WHERE continent is not null
GROUP BY location, population
ORDER BY PercentPopulationInfected desc

--Looking Countries and their Population, HighestInfectionCount, HighestDeathCount, PercentDeathRatePerPopulation,PercentPopulationInfected 
SELECT SUM(new_cases) as Total_Cases, SUM(CONVERT(FLOAT, new_deaths)) as Total_Deaths, 
SUM(CONVERT(FLOAT, new_deaths))/SUM(new_cases)*100 as WorldsDeathPercentage, 
SUM(new_cases)/sum(population)*100 as WorldsCasesPercentage, 
sum(population) as Total_Population
FROM covid_case.dbo.deaths 
WHERE continent is not null
GROUP BY DATE
ORDER BY 1,2;

--Using VACCINATION table--

Select * FROM covid_case.dbo.vaccination 
WHERE continent IS NOT NULL;

--Percentage vaccinated
SELECT D.location, SUM(D.population) as Population, SUM(cast(V.new_vaccinations as float)) as vaccinated, 
ROUND(MAX(cast(V.people_fully_vaccinated as float))/MAX(D.population)*100, 2) "Vaccine percent"
From covid_case.dbo.deaths D
Join covid_case.dbo.vaccination  V
ON D.location=V.location AND D.date=V.date
WHERE D.continent IS NOT NULL AND D.continent like '%asia%'
Group by D.location
Order by "Vaccine percent" DESC;
