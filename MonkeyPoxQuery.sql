--Death Percentage

Select SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..monkeypox
order by 1,2


--Death Count by location

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..monkeypox
Where location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--Infected Count by Continent

Select pop.continent, SUM(mp.new_cases) as TotalCases
From PortfolioProject..populations pop
left join PortfolioProject..monkeypox mp on pop.location = mp.location
			and pop.date = mp.date
Where pop.continent is not null
Group by pop.continent
order by TotalCases desc


--Percent of Population Infected by country

select 
	mp.location,
	pop.population,
	MAX(mp.total_cases) as HighestInfectionCount, MAX((mp.total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where population is not null and continent is not null
Group by mp.location, population
order by PercentPopulationInfected desc


--Time series population infection

Select mp.Location, pop.Population, mp.date, MAX(mp.total_cases) as HighestInfectionCount,  Max((mp.total_cases/pop.population))*100 as PercentPopulationInfected
From PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location
			and mp.date = pop.date
--Where location like '%states%'
Group by mp.location, pop.population, mp.date
order by PercentPopulationInfected desc


-----------------------Unused in Tableau-----------------------


--Percent of Global Population Infected

select 
	MAX(mp.total_cases) as TotalWorldCases,
	MAX(pop.population) as TotalWorldPopulation,
	MAX(mp.total_cases)/MAX(pop.population) as PercentPopulationInfected
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where mp.location LIKE '%world%'


--Total Cases by continent (old)


select 
	pop.continent,
	MAX(mp.total_cases) as TotalCases
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where population is not null and continent is not null
Group by pop.continent
order by TotalCases desc


--New Cases by Day across the world

select 
	mp.date,
	SUM(mp.new_cases)
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where pop.continent is not null
Group by mp.date
order by 1,2 


--Rolling sum of new cases per country daily

select 
	pop.continent, mp.location, mp.date, pop.population, mp.new_cases,
	SUM(mp.new_cases) OVER (Partition by mp.location Order by mp.location, mp.date) as RollingSumCases
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where pop.continent is not null
order by 2,3 


--Creating Views

Create View PercentPopulationInfected as
select 
	mp.location,
	pop.population,
	MAX(mp.total_cases) as HighestInfectionCount, MAX((mp.total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where population is not null and continent is not null
Group by mp.location, population
