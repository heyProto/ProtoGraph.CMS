[group_by(.district)[] | {"data": {"district": .[0].district, "details": [.[] | {"assembly": .constituency_name, "name": .name, "party": .party}]}}]