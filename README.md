# Peruvian National Football Team Results

> [Ver en ESPAÑOL](LÉEME.md)

## Description
After an exhaustive data gathering process, I have created this ready-to-use database containing the results of every Peruvian national football match, along with important details for analysis. As a big football fan passionate about its statistics, I initially collected this data to share plots and summaries with my friends. Now, I want to share it with the GitHub community. This repository also includes a Python notebook with usage examples.

## Content
This dataset includes the match results of the Peruvian national football team, starting from their first match against Uruguay on November 1st, 1927, up to the most recent match as of the last update. It covers both official and friendly matches, with three specific exceptions that are not included (see the 'Not considered matches' section below for further details). The file `peru_match_results.csv` contains the following fields:

- `match_id`: Starting with M followed by the match number in chronological order.
- `date`: Date of the match.
- `rival`: Name of the team Peru played against.
- `rival_confederation`: Confederation where the rival belongs.
- `peru_score`: Goals scored by Peru in the match.
- `rival_score`: Goals received by Peru in the match.
- `peru_awarded_score`: Goals scored by Peru after reviews or sanctions (if any).
- `rival_awarded_score`: Goals received by Peru after reviews or sanctions (if any).
- `result`: Match result (W: win, D: draw, L: lose).
- `shootout_result`: Result of penalty shootout (if applicable).
- `awarded_result`: Match result after reviews or sanctions (if any).
- `tournament_name`: Specific name of the tournament (e.g: FIFA World Cup 2018).
- `tournament_type`: Tournament type (e.g: FIFA World Cup).
- `official`: Boolean indicating whether the match was official.
- `stadium`: Name of the stadium where the match was played.
- `city`: City where the match was played.
- `country`: Country where the match was played.
- `elevation`: Elevation (above the sea level) of the city where the match was played.
- `peru_condition`: Indicates if Peru played as home, away or neutral team.
- `coach`: Name of the Peruvian team coach at the time of the match.
- `coach_nationality`: Nationality of the coach.

## Not considered matches
Three specific matches were not considered in this database for the following reasons:

| Match date  | Rival         | Reason                                    |
|-------------|---------------|-------------------------------------------|
| 1988-03-26  | Canada        | Peru played with a U19 team.              |
| 2011-06-28  | Senegal       | Senegal sent an alternative team, possibly U23. |
| 2013-12-28  | Basque Country| Basque Country is not recognized by FIFA. |

## Provenance

The data was gathered from several sources, including but not limited to Sofascore, Google, Wikipedia, FIFA, perufootball.org, Transfermarkt, DeChalaca.com, Facebook, BESOCCER, 11v11.com, Partidos de la Roja, etc.

All data was manually collected via web search.

## License
This project is licensed under CC BY-NC-SA 4.0. See the [LICENSE](LICENSE) file for more details.
