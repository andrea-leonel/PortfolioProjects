/*
SELECT *
FROM PortfolioProject.covidvaccinations
ORDER BY 3, 4
*/

/*
SELECT *
FROM PortfolioProject.coviddeaths
ORDER BY 3, 4
*/

/*
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.coviddeaths
ORDER BY Location, date
*/

-- Total Cases vs Total Deaths: rate of deaths per case.
/*
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS DeathPercentage
FROM PortfolioProject.coviddeaths
WHERE location = 'United Kingdom'
ORDER BY Location, date
*/

-- Total Cases vs Population
/*
SELECT location, date, total_cases, population, ROUND((total_cases/population)*100,2) AS InfectionPercentage
FROM PortfolioProject.coviddeaths
WHERE location = 'Brazil'
ORDER BY Location, date
*/

-- Current infection rate by Country
/*
SELECT location, MAX(Population) AS Population, MAX(total_cases) AS CurrentTotalCases, ROUND((MAX(total_cases)/MAX(population))*100,2) AS InfectionRate
FROM PortfolioProject.coviddeaths
WHERE continent <> ''
GROUP BY location
ORDER BY InfectionRate DESC
*/

-- Current death rate by Country
/*
SELECT location, MAX(Population) AS Population, MAX(CAST(total_deaths AS SIGNED)) AS CurrentTotalDeaths, ROUND((MAX(CAST(total_deaths AS SIGNED))/MAX(population))*100,2) AS DeathRate
FROM PortfolioProject.coviddeaths
WHERE continent <> ''
GROUP BY location
ORDER BY CurrentTotalDeaths DESC
*/

-- Death rate by Continent
/*
SELECT continent, MAX(Population) AS Population, MAX(CAST(total_deaths AS SIGNED)) AS CurrentTotalDeaths, ROUND((MAX(CAST(total_deaths AS SIGNED))/MAX(population))*100,2) AS DeathRate
FROM PortfolioProject.coviddeaths
WHERE continent <> ''
GROUP BY continent
ORDER BY CurrentTotalDeaths DESC
*/

-- GLOBAL NUMBERS
/*
SELECT date, SUM(CAST(new_cases AS SIGNED)) AS NewCases, SUM(CAST(new_deaths AS SIGNED)) AS NewDeaths, ROUND((SUM(CAST(new_deaths AS SIGNED))/SUM(CAST(new_cases AS SIGNED)))*100,2) AS DeathRate
FROM PortfolioProject.coviddeaths
WHERE continent <> ''
GROUP BY date
ORDER BY date
*/

-- Rolling Vaccinations - using CTE
/*
With VacRate (Continent, location, population, date, new_vaccinations, RollingNewVac)
AS
(
SELECT dth.Continent, dth.location, dth.population, dth.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) AS RollingNewVac
FROM PortfolioProject.coviddeaths dth
JOIN PortfolioProject.covidvaccinations vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent = 'Europe'
ORDER BY 2, 3
)

SELECT *, ROUND(((RollingNewVac/CAST(Population AS SIGNED))*100),2) AS VacPercent
FROM VacRate
*/

-- Rolling Vaccinations - using TEMP -- not working
/*
CREATE TEMPORARY TABLE PercentPopulationVaccinated (
Continent TEXT, location TEXT, population BIGINT, date TEXT, new_vaccinations BIGINT, RollingNewVac BIGINT
);

INSERT INTO PercentPopulationVaccinated
SELECT dth.Continent, dth.location, dth.population, dth.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) AS RollingNewVac
FROM PortfolioProject.coviddeaths dth
JOIN PortfolioProject.covidvaccinations vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent = 'Europe';

SELECT *, ROUND(((RollingNewVac/Population)* 100), 2) AS VacPercent
FROM PortfolioProject.PercentPopulationVaccinated

*/

-- Creating view for later visualisations
CREATE VIEW PercentPopVaccinated ASpercentpopvaccinated

SELECT dth.Continent, dth.location, dth.population, dth.date, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) AS RollingNewVac
FROM PortfolioProject.coviddeaths dth
JOIN PortfolioProject.covidvaccinations vac
ON dth.location = vac.location
AND dth.date = vac.date
WHERE dth.continent = 'Europe'
