. | {"data":
        {
            "district": .district ,
            "map": .map,
            "population": .population,
            "area": .area,
            "rural": (if .rural == null then -1 else .rural | tonumber end),
            "urban": (if .urban == null then -1 else .urban | tonumber end),
            "description": .description,
        }
    }