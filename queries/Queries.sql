
SELECT  
    Location.location_name AS Country_Name,
    '2021-01-01' AS Date_1, 
    COALESCE(
        MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
        MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END)
    ) AS Vaccine_OD1,
    '2021-06-01' AS Date_2, 
    COALESCE(
        MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
        MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END)
    ) AS Vaccine_OD2,
    '2022-01-01' AS Date_3, 
    COALESCE(
        MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2022-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
        MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END)
    ) AS Vaccine_OD3,
    -- Calculate absolute percentage change between dates, ensuring result is always positive
    ABS(
        (
            (COALESCE(MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
            MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END)) - 
        COALESCE(MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
            MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END))) / 
        COALESCE(MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
            MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END))
        ) - 
        (
            (COALESCE(MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2022-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
            MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END)) - 
        COALESCE(MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
            MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END))) / 
        COALESCE(MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-06-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END),
            MAX(CASE WHEN Daily_Vaccination_Record.record_date = '2021-01-01' THEN Daily_Vaccination_Record.total_vaccinations ELSE NULL END))
        )
    ) AS Percentage_Change
FROM 
    Location
JOIN 
    Daily_Vaccination_Record ON Location.iso_code = Daily_Vaccination_Record.iso_code
WHERE 
    Daily_Vaccination_Record.record_date IN ('2021-01-01', '2021-06-01', '2022-01-01')
    AND Location.location_type = 'country'  -- Added filter for countries only
GROUP BY 
    Location.location_name
ORDER BY 
    Percentage_Change DESC;







--2

WITH MonthlyGrowth AS (
    SELECT
        L.location_name AS country_name,
        strftime('%Y-%m', D.record_date) AS month_year,
        MAX(D.total_vaccinations) AS total_vaccinations,
        MAX(D.total_vaccinations) - 
        COALESCE(
            (SELECT MAX(D2.total_vaccinations)
             FROM Daily_Vaccination_Record D2
             WHERE D2.iso_code = D.iso_code
             AND strftime('%Y-%m', D2.record_date) = strftime('%Y-%m', DATE(D.record_date, '-1 month'))), 
            0) AS growth_rate
    FROM Daily_Vaccination_Record D
    JOIN Location L ON D.iso_code = L.iso_code
    WHERE L.location_type = 'country'
    GROUP BY L.location_name, month_year
),
GlobalGrowth AS (
    SELECT
        month_year,
        AVG(growth_rate) AS global_avg_growth_rate
    FROM MonthlyGrowth
    GROUP BY month_year
)
SELECT
    MG.country_name,
    MG.month_year,
    MG.growth_rate,
    (MG.growth_rate - GG.global_avg_growth_rate) AS growth_rate_diff_to_global
FROM MonthlyGrowth MG
JOIN GlobalGrowth GG
    ON MG.month_year = GG.month_year
WHERE MG.growth_rate > GG.global_avg_growth_rate
ORDER BY MG.month_year, MG.country_name;


--3

SELECT 
    v.vaccine_name AS Vaccine_Type,
    l.location_name AS Country,
    (SUM(vup.total_vaccinations) * 100.0 / (SELECT SUM(total_vaccinations) FROM Daily_Vaccination_Record dvr WHERE dvr.iso_code = vup.iso_code)) AS Percentage_of_vaccine_type
FROM 
    Vaccinetype_used_per_day vup
JOIN 
    Vaccine v ON vup.vaccine_id = v.vaccine_id
JOIN 
    Location l ON vup.iso_code = l.iso_code
GROUP BY 
    v.vaccine_name, l.location_name, vup.iso_code
ORDER BY 
    l.location_name, Percentage_of_vaccine_type DESC;


--4
SELECT  
    loc.location_name AS "Country Name",
    strftime('%Y-%m', dvr.record_date) AS "Month",
    src.source_website AS "Source Name (URL)",
    SUM(dvr.total_vaccinations) AS "Total Administered Vaccines"
FROM 
    Daily_Vaccination_Record dvr
JOIN 
    Location loc ON dvr.iso_code = loc.iso_code
JOIN 
    Information_Source src ON dvr.source_id = src.source_id
GROUP BY 
    loc.location_name,
    strftime('%Y-%m', dvr.record_date),
    src.source_website
ORDER BY 
    "Total Administered Vaccines" DESC,
    loc.location_name ASC,
    strftime('%Y-%m', dvr.record_date) ASC;

--5
SELECT 
    dvr1.record_date AS "Dates",
    -- United States (USA)
    COALESCE(
        NULLIF(dvr1.people_fully_vaccinated, 0), 
        LAG(NULLIF(dvr1.people_fully_vaccinated, 0)) 
        OVER (PARTITION BY dvr1.iso_code ORDER BY dvr1.record_date)
    ) AS "United States",
    -- China (CHN)
    COALESCE(
        NULLIF(dvr2.people_fully_vaccinated, 0), 
        LAG(NULLIF(dvr2.people_fully_vaccinated, 0)) 
        OVER (PARTITION BY dvr2.iso_code ORDER BY dvr2.record_date)
    ) AS "China",
    -- Ireland (IRL)
    COALESCE(
        NULLIF(dvr3.people_fully_vaccinated, 0), 
        LAG(NULLIF(dvr3.people_fully_vaccinated, 0)) 
        OVER (PARTITION BY dvr3.iso_code ORDER BY dvr3.record_date)
    ) AS "Ireland",
    -- India (IND)
    COALESCE(
        NULLIF(dvr4.people_fully_vaccinated, 0), 
        LAG(NULLIF(dvr4.people_fully_vaccinated, 0)) 
        OVER (PARTITION BY dvr4.iso_code ORDER BY dvr4.record_date)
    ) AS "India"
FROM 
    Daily_Vaccination_Record dvr1
LEFT JOIN 
    Daily_Vaccination_Record dvr2 ON dvr1.record_date = dvr2.record_date AND dvr2.iso_code = 'CHN'
LEFT JOIN 
    Daily_Vaccination_Record dvr3 ON dvr1.record_date = dvr3.record_date AND dvr3.iso_code = 'IRL'
LEFT JOIN 
    Daily_Vaccination_Record dvr4 ON dvr1.record_date = dvr4.record_date AND dvr4.iso_code = 'IND'
WHERE 
    dvr1.iso_code = 'USA'  -- Filter for United States data
    AND strftime('%Y', dvr1.record_date) IN ('2022', '2023')  -- Filter for 2022 and 2023
ORDER BY 
    dvr1.record_date;
