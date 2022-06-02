-- Explore data
Select
    *
FROM
    `unique-result-230022.covid_data.covid_deaths`
WHERE 
    location = "Vietnam" 
ORDER BY 
    date; 

Select
    *
FROM
    `unique-result-230022.covid_data.covid_vaccination`
WHERE 
    location = "Vietnam"
ORDER BY 
    date; 
-- What is the total death, total infection and total population of vietnam
SELECT
    population, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths
FROM
    `unique-result-230022.covid_data.covid_deaths`
WHERE 
    location = "Vietnam" 
GROUP BY
    population;

-- What is the infection rate, death rate and vaccination rate
WITH cte AS (
    SELECT
        dea.date,
        dea.population,
        dea.new_cases,
        SUM(dea.new_cases) OVER(PARTITION BY dea.location ORDER BY dea.date) as total_cases,
        dea.new_deaths,
        SUM(dea.new_deaths) OVER(PARTITION BY dea.location ORDER BY dea.date) as total_deaths,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.date) as total_vaccination,
    FROM
        covid_data.covid_deaths dea
        LEFT JOIN covid_data.covid_vaccination vac
        ON dea.date = vac.date AND dea.location = vac.location
    WHERE 
        dea.location = "Vietnam" 
)
SELECT
    date,
    population,
    new_cases,
    total_cases,
    ROUND((total_cases / population) * 100, 2) as infection_rate,
    new_deaths,
    total_deaths,
    ROUND((total_deaths / total_cases) * 100, 2) as death_rate,
    new_vaccinations,
    total_vaccination,
    ROUND((total_vaccination / population), 2) * 100 as vaccination_rate
FROM
    cte;
