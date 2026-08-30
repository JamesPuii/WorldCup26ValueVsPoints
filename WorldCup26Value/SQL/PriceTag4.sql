WITH squad_values AS (
    SELECT home_team_id AS team_id, home_squad_total_value_eur AS squad_value_eur
    FROM match_prediction_features
    UNION
    SELECT away_team_id, away_squad_total_value_eur
    FROM match_prediction_features
),
team_matches AS (
    SELECT home_team_id AS team_id, home_score AS gf, away_score AS ga
    FROM matches WHERE status = 'Completed'
    UNION ALL
    SELECT away_team_id, away_score, home_score
    FROM matches WHERE status = 'Completed'
),
team_points AS (
    SELECT team_id,
           COUNT(*) AS matches_played,
           SUM(CASE WHEN gf > ga THEN 3 WHEN gf = ga THEN 1 ELSE 0 END) AS points
    FROM team_matches
    GROUP BY team_id
),
tiered AS (
    SELECT tp.team_id, tp.matches_played, tp.points,
           sv.squad_value_eur / 1000000.0        AS squad_value_m,
           tp.points * 1.0 / tp.matches_played   AS points_per_match,
           CASE WHEN sv.squad_value_eur / 1000000.0 <= 145.4 THEN '1. Under EUR145m'
                WHEN sv.squad_value_eur / 1000000.0 <= 357.2 THEN '2. EUR145-357m'
                WHEN sv.squad_value_eur / 1000000.0 <= 634.1 THEN '3. EUR357-634m'
                ELSE '4. Over EUR634m' END       AS value_tier
    FROM team_points tp
    JOIN squad_values sv ON sv.team_id = tp.team_id
),
tier_average AS (
    SELECT value_tier,
           AVG(points_per_match) AS tier_expected_ppm
    FROM tiered
    GROUP BY value_tier
)
SELECT t.team_name,
       td.value_tier,
       ROUND(td.squad_value_m, 1)                              AS squad_value_m,
       td.matches_played,
       td.points,
       ROUND(td.points_per_match, 3)                           AS actual_ppm,
       ROUND(ta.tier_expected_ppm, 3)                          AS expected_ppm,
       ROUND(td.points_per_match - ta.tier_expected_ppm, 3)    AS ppm_above_price_tag
FROM tiered td
JOIN tier_average ta ON ta.value_tier = td.value_tier
JOIN teams t         ON t.team_id     = td.team_id
ORDER BY ppm_above_price_tag DESC;