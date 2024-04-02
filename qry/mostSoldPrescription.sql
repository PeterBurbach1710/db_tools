WITH p_total_unranked AS (
        SELECT
                SUM(quantity) total,
                sk_chem_sub
        FROM
                prescriptions_uk.prescriptions
        GROUP BY
                sk_chem_sub
),
p_total AS (
        SELECT
                total,
                sk_chem_sub,
                RANK() OVER (
                        ORDER BY
                                total DESC
                ) rnk
        FROM
                p_total_unranked
),
p_yearly AS (
        SELECT
                SUM(quantity) total_by_year,
                sk_chem_sub,
                YEAR(PERIOD_FIRST_DAY_AS_DATE) year_as_date
        FROM
                prescriptions_uk.prescriptions
        GROUP BY
                sk_chem_sub,
                YEAR(PERIOD_FIRST_DAY_AS_DATE)
),
finale AS (
        SELECT
                p_total.total,
                p_total.sk_chem_sub,
                p_yearly.year_as_date,
                p_yearly.total_by_year,
                RANK() OVER (
                        ORDER BY
                                p_yearly.total_by_year DESC
                ) rank_final
        FROM
                p_total
                INNER JOIN p_yearly ON p_yearly.sk_chem_sub = p_total.sk_chem_sub
        WHERE
                p_total.rnk = 1
        GROUP BY
                p_total.total,
                p_total.sk_chem_sub,
                p_yearly.year_as_date,
                p_yearly.total_by_year
)
SELECT
        sub.sk_chem_sub,
        sub.chemical_name,
        year_as_date,
        to_char(total_by_year, '999,999,999,999') total_by_year,
        to_char(total, '999,999,999,999') total
FROM
        finale
        INNER JOIN prescriptions_uk.chemical_substances sub ON sub.sk_chem_sub = finale.sk_chem_sub
WHERE
        finale.rank_final = 1;
SELECT
        SUM(prs.quantity) total,
        sub.chemical_name
FROM
        prescriptions_uk.prescriptions prs,
        prescriptions_uk.chemical_substances sub
WHERE
        sub.sk_chem_sub = prs.sk_chem_sub
GROUP BY
        sub.chemical_name
LIMIT
        1