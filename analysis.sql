
SELECT *
FROM rental_market; -- Check all data from toronto_rental

SELECT year, avg_rent_2br
FROM rental_market
ORDER BY year;

SELECT year, rent_growth
FROM rental_market
ORDER BY rent_growth DESC
limit 1;-- Find fastest growth among these years

SELECT year,avg_rent_2br,
    LAG(avg_rent_2br) OVER (ORDER BY year) AS previous_year_rent,
    avg_rent_2br - LAG(avg_rent_2br) OVER (ORDER BY year) AS rent_increase
FROM rental_market
ORDER BY year; -- “2-bedroom" price changing compare to last year

SELECT
    year,
    avg_rent_2br,
    LAG(avg_rent_2br) OVER (ORDER BY year) AS previous_year_rent,
    ROUND(
            (
                avg_rent_2br
                    - LAG(avg_rent_2br) OVER (ORDER BY year)
                )
                / LAG(avg_rent_2br) OVER (ORDER BY year)
                * 100,
            2
    ) AS calculated_growth
FROM rental_market
ORDER BY year; -- "2-bedroom" price changing in percentage

SELECT
    year,
    rent_growth AS reported_growth,
    ROUND(
            (
                avg_rent_2br
                    - LAG(avg_rent_2br) OVER (ORDER BY year)
                )
                / LAG(avg_rent_2br) OVER (ORDER BY year)
                * 100,
            2
    ) AS calculated_growth,
    ROUND(
            ABS(
                    rent_growth -
                    (
                        (
                            avg_rent_2br
                                - LAG(avg_rent_2br) OVER (ORDER BY year)
                            )
                            / LAG(avg_rent_2br) OVER (ORDER BY year)
                            * 100
                        )
            ),
            2
    ) AS growth_difference
FROM rental_market
ORDER BY year; -- Difference between CMHC growth rate and manually calculated grwoth rate

-- Use CTE to get growth rate

WITH rent_data AS (
    SELECT
        year,
        avg_rent_2br,
        rent_growth,
        LAG(avg_rent_2br) OVER (ORDER BY year) AS previous_year_rent
    FROM rental_market
),

     growth_analysis AS (
         SELECT
             year,
             rent_growth AS reported_growth,

             ROUND(
                     (avg_rent_2br - previous_year_rent)
                         / previous_year_rent * 100,
                     2
             ) AS calculated_growth,

             ROUND(
                     ABS(
                             rent_growth -
                             (
                                 (avg_rent_2br - previous_year_rent)
                                     / previous_year_rent * 100
                                 )
                     ),
                     2
             ) AS growth_difference_pp
         FROM rent_data
     )

SELECT *
FROM growth_analysis
WHERE growth_difference_pp IS NOT NULL
ORDER BY growth_difference_pp DESC
LIMIT 1;

--

WITH vacancy_data AS (
    SELECT
        year,
        vacancy_rate,
        rent_growth,
        ROUND(
                vacancy_rate - LAG(vacancy_rate) OVER (ORDER BY year),
                2
        ) AS vacancy_change
    FROM rental_market
)

SELECT
    year,
    vacancy_rate,
    vacancy_change,
    rent_growth
FROM vacancy_data
ORDER BY year; -- Compare vacancy rate changes with rent growth

WITH vacancy_data AS (
    SELECT
        year,
        rent_growth,
        ROUND(
                vacancy_rate - LAG(vacancy_rate) OVER (ORDER BY year),
                2
        ) AS vacancy_change
    FROM rental_market
),

     clean_data AS (
         SELECT *
         FROM vacancy_data
         WHERE vacancy_change IS NOT NULL
     )

SELECT
    SUM(
            (vacancy_change - avg_vacancy_change) *
            (rent_growth - avg_rent_growth)
    )
        /
    SQRT(
            SUM(POW(vacancy_change - avg_vacancy_change, 2)) *
            SUM(POW(rent_growth - avg_rent_growth, 2))
    ) AS correlation
FROM (
         SELECT
             *,
             AVG(vacancy_change) OVER () AS avg_vacancy_change,
             AVG(rent_growth) OVER () AS avg_rent_growth
         FROM clean_data
     ) t;
/* From 2022 to 2025, vacancy rate changes and rent growth showed a moderate negative correlation of approximately
   -0.52. This suggests that years with rising vacancy rates tended to experience slower rent growth. However, the
   result should be interpreted cautiously because the analysis is based on only four annual observations.
*/

CREATE OR REPLACE VIEW rental_market_analysis AS

WITH base AS (
    SELECT
        year,
        city,
        vacancy_rate,
        turnover_rate,
        avg_rent_2br,
        rent_growth AS reported_growth,
        LAG(avg_rent_2br) OVER (ORDER BY year) AS previous_year_rent,
        LAG(vacancy_rate) OVER (ORDER BY year) AS previous_year_vacancy
    FROM rental_market
)

SELECT
    year,
    city,
    vacancy_rate,
    turnover_rate,
    avg_rent_2br,
    reported_growth,

    avg_rent_2br - previous_year_rent AS rent_increase,

    ROUND(
            (avg_rent_2br - previous_year_rent)
                / previous_year_rent * 100,
            2
    ) AS calculated_growth,

    ROUND(
            vacancy_rate - previous_year_vacancy,
            2
    ) AS vacancy_change

FROM base;
