-- Left Join POC

select 
	mp.location,
    pop.population
from PortfolioProject..monkeypox mp
left join PortfolioProject..populations pop on mp.location = pop.location 
           and mp.date = pop.date
Where population is not null and continent is not null
Group by mp.location, population
	
	
--Percent of Population Infected

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


--Total Infections by Continent

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
--order by PercentPopulationInfected desc
