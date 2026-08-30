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
)
SELECT t.team_name,
       t.confederation,
       ROUND(sv.squad_value_eur / 1000000.0, 1)              AS squad_value_m,
       tp.matches_played,
       tp.points,
       ROUND(tp.points * 1.0 / tp.matches_played, 3)         AS points_per_match
FROM team_points tp
JOIN squad_values sv ON sv.team_id = tp.team_id
JOIN teams t         ON t.team_id  = tp.team_id
ORDER BY squad_value_m DESC;