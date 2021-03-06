Select 
    JSON_EXTRACT:gameData:game:pk::string as game_id,
    player.value:id::string as player_id, 
    player.value:active::boolean as active_status,
    player.value:captain::boolean as captain,
    player.value:alternateCaptain::string as alt_captain,
    player.value:birthCity::string as birth_city,
    player.value:birthCountry::string as birth_country,
    player.value:birthDate::date as birth_date,
    player.value:birthStateProvince::string as birth_state_province,
    player.value:currentAge::int as current_age,
    player.value:currentTeam:id::string as current_team_id,
    player.value:firstName::string as first_name,
    player.value:lastName::string as last_name,
    (trim(split_part(player.value:height::string, '''', 1))::int * 12) + trim(split_part(split_part(player.value:height::string, '''', 2)::string, '"', 1))::int as height_inches,
    player.value:nationality::string as nationality,
    player.value:primaryNumber::string as jersey_number,
    player.value:primaryPosition:abbreviation::string as position,
    player.value:rookie::boolean as rookie_status,
    player.value:rosterStatus::string as roster_status,
    player.value:shootsCatches::string as handedness,
    player.value:weight::int as weight
        

from {{source('NHL_DB_RAW', 'RAW_GAME_DATA')}}, table(flatten(JSON_EXTRACT:gameData:players)) player

{% if is_incremental() %}
where game_id > (select max(game_id) from {{ this }})
{% endif %}