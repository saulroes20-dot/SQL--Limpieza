--LET'S BREAK THINGS DOWN BY CONTINENT 

SELECT continent, location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
WHERE continent = 'North America'
GROUP BY continent, location
ORDER BY TotalDeathCount DESC;

SELECT continent, location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
WHERE continent = 'South America'
GROUP BY continent, location
ORDER BY TotalDeathCount DESC;

--Showing continents with the highest death count per population 

SELECT continent, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--GLOBAL NUMBERS

SELECT SUM(new_cases) AS Total_Cases,SUM(CAST(new_deaths as int)) AS Total_Deaths, 
SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 AS DeathPercentage
FROM CovidDeaths$
WHERE continent IS NOT NULL
--GROUP BY date, location
ORDER BY 1,2

--Loking at total Population VS Vaccinations 
SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location,
dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths$ dea
JOIN 
CovidVaccinations$ vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
ORDER BY 2,3;



--USE CTE

WITH PopvsVac (Continent, Location,Date, Population,new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location,
dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths$ dea
JOIN 
CovidVaccinations$ vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac



--TEMP TABLE 

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime, 
	Population numeric, 
	New_Vaccinations numeric,
	RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated

SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.location,
dea.Date) AS RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
FROM CovidDeaths$ dea
JOIN 
CovidVaccinations$ vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL 
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population) * 100 AS PercentagePeopleVaccinated
FROM #PercentPopulationVaccinated