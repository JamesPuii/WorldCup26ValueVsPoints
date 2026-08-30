WITH squad_profile AS (
    SELECT home_team_id AS team_id,
           home_squad_total_value_eur AS squad_value_eur,
           home_squad_avg_age         AS avg_age,
           home_squad_total_caps      AS total_caps
    FROM match_prediction_features
    UNION
    SELECT away_team_id, away_squad_total_value_eur,
           away_squad_avg_age, away_squad_total_caps
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
)
SELECT t.team_name,
       ROUND(sp.squad_value_eur / 1000000.0, 1)      AS squad_value_m,
       sp.avg_age,
       sp.total_caps,
       ROUND(sp.total_caps * 1.0 / 26, 1)            AS caps_per_player,
       tp.matches_played,
       ROUND(tp.points * 1.0 / tp.matches_played, 3) AS points_per_match
FROM team_points tp
JOIN squad_profile sp ON sp.team_id = tp.team_id
JOIN teams t          ON t.team_id  = tp.team_id
ORDER BY points_per_match DESC;