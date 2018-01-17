. | {"data":
        {
            "publishedat": .publishedat,
            "byline": (if .byline == null then "" else .byline end),
            "genre": (if .genre == null then "" else .genre end),
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
            "series": (if .series == null then "" else .series end),
            "subgenre": (if .subgenre == null then "" else .subgenre end),
            "summary": (if .summary == null then "" else .summary end),
            "url": .url,
            "country": (if .country == null then "" else .country end),
            "state": (if .state == null then "" else .state end),
            "city": (if .city == null then "" else .city end),
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
