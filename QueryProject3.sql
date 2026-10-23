--Creating View to store data for later visualization 

Create View vw_PercentePopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location,
	dea.Date) AS RollingPeopleVaccinated
FROM CovidDeaths$ dea
JOIN 
CovidVaccinations$ vac
ON dea.location = vac.location
		AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 

SELECT * 
FROM vw_PercentePopulationVaccinated


SELECT  location, SUM(CAST(new_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
WHERE continent IS NULL 
AND location NOT IN ('World','European Union', 'International')
GROUP BY continent, location
ORDER BY TotalDeathCount DESC;


SELECT location,Population,date, MAX(total_cases) AS HighestInfectCount, MAX((total_cases/population))*100 AS PercentagePopulations
FROM CovidDeaths$
GROUP BY location, Population,date
ORDER BY PercentagePopulations;
