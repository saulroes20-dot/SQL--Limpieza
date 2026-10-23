SELECT * 
FROM PortfolioProject..CovidDeaths$
--WHERE continent IS NOT NULL
ORDER BY 3,4;


--SELECT * 
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4;


--SELECT DATA THAT WE ARE GOING TO USING
SELECT location,date,total_cases, new_cases, total_deaths,population
FROM CovidDeaths$
ORDER BY 1,2;

--Looking at total Cases vs Total Deaths 
--Shows likelihood of dying you contract in your country
SELECT location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths$
ORDER BY 1,2;

---Looking at Total Cases vs Population 
--Show what percentage of population got Covid
SELECT location,date, population,total_cases,(total_cases/population)*100 AS CasesPercentage
FROM CovidDeaths$
ORDER BY 1,2;

--Looking at countries with highest Rate compared to population 
SELECT location, population,MAX(total_cases) AS HighestInfectionCountry 
,MAX((total_cases/population))*100 AS PercentagePopulationInfected
FROM CovidDeaths$
GROUP BY location,population
ORDER BY HighestInfectionCountry DESC;

--Showing Countries with Highest Death Count per Population 
--This is a great analyses , because US it was the worst around the world 
SELECT location, MAX(CAST(Total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths$
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC;

