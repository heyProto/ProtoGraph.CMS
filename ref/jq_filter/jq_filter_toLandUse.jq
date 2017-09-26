. | {"data":
        {
            "language": .language,
            "district":.district,
            "forest_score":.forest_score | tonumber,
            "land_score":.land_score | tonumber,
            "population_score": .population_score | tonumber,
            "area_under_forest": {
                "number": (if .area_under_forest == null then -1 else .area_under_forest | tonumber end),
                "percent": (if .forest_area == null then -1 else .forest_area | tonumber end),
            },
            "area_under_concrete": {
                "number": (if .area_under_concrete == null then -1 else .area_under_concrete | tonumber end),
                "percent": (if .concrete_area == null then -1 else .concrete_area | tonumber end)
            }
        }
    }