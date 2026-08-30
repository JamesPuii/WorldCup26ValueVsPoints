# Did money predicts World Cup results.
Squad market value ranged from €38m to €2.13bn across the 48 teams. Did the gap show up on the pitch?

[View the interactive dashboard on Tableau Public](https://public.tableau.com/views/WorldCup2026Moneyboughtresults/Dashboard1)

**FINDINGS**

**Money predicts results.** Squad market value correlates with points per match at 0.74. No team valued above €600m finished with fewer than 1.0 points per match.

**Returns diminish sharply**. Each value tier bought roughly half a point per match more than the tier below it, but each tier cost about double. The cheapest quartile paid €184m per point per match; the most expensive paid €566m.

**It is money, not experience**. Squad average age correlates with points per match at −0.13 and caps per player at 0.08. Both are noise. Value is the variable that matters.

**A few teams beat their price tag.** Switzerland returned 11 points on a €357m squad, 0.86 points per match above its tier average. Mexico took 12 points on €412m. Panama spent €174m for zero points, the worst return in the field.

**Spending at the top was not wasted.** Spain carried the most expensive squad in the tournament at €2.13bn and still beat its tier average by 0.58 points per match.

**DATA**

[FIFA World Cup 2026 Dataset](https://www.kaggle.com/datasets/mominullptr/fifa-world-cup-2026-dataset)

**LIMITATIONS**

Squad valuations are partly estimated. The dataset combines verified Transfermarkt figures for star players with rank-calibrated estimates for the rest of each roster. The broad pattern is reliable;

Correlation is not causation, and squad value is probably a proxy. 

48 teams is a small sample, and quartiles are 8 to 15 teams each.

Points per match compresses the knockout rounds. 

**Written in SQLite. Visualized in Tableau Public.**

James Puii | [Linkedin](https://www.linkedin.com/in/james-puii-md/) | [Tableau Public](https://public.tableau.com/app/profile/james.puii/vizzes)
