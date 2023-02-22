select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths$
order by 1,2

select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from PortfolioProject..CovidDeaths$
where location like '%states%'
order by 1,2

select location,population,max(total_cases),max((total_cases/population)*100) as percentagepopulationinfected
from PortfolioProject..CovidDeaths$
--where location like '%states%'
group by location,population
order by 1,2


select Dea.continent,Dea.date,Dea.population,Dea.location,Vac.new_vaccinations,
 SUM(Vac.new_vaccinations) over (partition by Dea.location order by Dea.location,Dea.date) as RollingpeopleVaccinated
 from PortfolioProject..CovidDeaths$ as Dea
 join PortfolioProject..CovidVaccinations$ as Vac on Dea.date=Vac.date and Dea.location=Vac.location
 where Dea.continent is not null
 order by 2,3


 with PopvsVac (continent,date,population,location,new_vaccinations,RollingpeopleVaccinated)
 as
 (
 select Dea.continent,Dea.date,Dea.population,Dea.location,Vac.new_vaccinations,
 SUM(cast (Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location,Dea.date) as RollingpeopleVaccinated
 from PortfolioProject..CovidDeaths$ as Dea
 join PortfolioProject..CovidVaccinations$ as Vac on Dea.date=Vac.date and Dea.location=Vac.location
 where Dea.continent is not null
 --order by 2,3
 )
 select *, (RollingpeopleVaccinated/population)*100 
 from PopvsVac

 --temp
 Drop table if exists #Percentpopulationvaccinated
 create table #Percentpopulationvaccinated
 ( continent nvarchar(255),
   date datetime,
   population numeric,
   location nvarchar(255),
   new_vaccinations numeric,
   RollingpeopleVaccinated numeric
   )
 Insert into #Percentpopulationvaccinated
 select Dea.continent,Dea.date,Dea.population,Dea.location,Vac.new_vaccinations,
 SUM(cast (Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location,Dea.date) as RollingpeopleVaccinated
 from PortfolioProject..CovidDeaths$ as Dea
 join PortfolioProject..CovidVaccinations$ as Vac on Dea.date=Vac.date and Dea.location=Vac.location
 select *
 from #Percentpopulationvaccinated


 --view
 
 create view Percentpopulationvaccinated as
 select Dea.continent,Dea.date,Dea.population,Dea.location,Vac.new_vaccinations,
 SUM(cast (Vac.new_vaccinations as int)) over (partition by Dea.location order by Dea.location,Dea.date) as RollingpeopleVaccinated
 from PortfolioProject..CovidDeaths$ as Dea
 join PortfolioProject..CovidVaccinations$ as Vac on Dea.date=Vac.date and Dea.location=Vac.location
 where Dea.continent is not null

 Select * from Percentpopulationvaccinated