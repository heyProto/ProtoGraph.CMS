. | {"data":
        {
            "publishedat": .publishedat,
            "byline": .byline,
            "genre": .genre,
            "hasdata": (
                if .hasdata | ascii_downcase == "yes"
                    then true
                else false
            end),
            "hasimage": (
                if .hasimage | ascii_downcase == "yes"
                    then true
                else false
            end),
            "hasvideo": (
                if .hasvideo | ascii_downcase == "yes"
                    then true
                else false
            end),
            "headline": .headline,
            "imageurl": .imageurl,
            "series": .series,
            "subgenre": .subgenre,
            "summary": .summary,
            "url": .url,
            "isinteractive": (
                if .hasdata | ascii_downcase == "yes"
                    then true
                elif .hasimage | ascii_downcase == "yes"
                    then true
                elif .hasvideo | ascii_downcase == "yes"
                    then true
                else false
            end)
        }
    }
