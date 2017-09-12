. | {"data":
         {"details_about_journalist": {
             "name": ."name" | tostring,
             "age": (if ."age" == null then ."age" else ."age" | tonumber end),
             "gender": ."gender" | tostring,
             "image_url": ."image_url" | tostring,
             "is_freelancer": ."is_freelancer" | tostring,
             "organisation": ."organisation" | tostring,
             "organisation_type": ."organisation_type" | tostring,
             "beat": ."beat" | tostring,
             "journalist_body_of_work": ."journalist_body_of_work" | tostring
         },
          "when_and_where_it_occur": {
              "date": ."date" | tostring,
              "location": ."location" | tostring,
              "state": ."state" | tostring,
              "lat": ."lat" | tonumber,
              "lng": ."lng" | tonumber,
              "nature_of_assault": ."nature_of_assault" | tostring,
              "accused_names": ."accused_names" | tostring,
              "description_of_attack": ."description_of_attack" | tostring,
              "motive_of_attack": ."motive_of_attack" | tostring,
              "party": ."party" | tostring,
              "is_case_registered": ."is_case_registered" | tostring,
          },
          "addendum": {
              "referral_link_1": (if ."referral_link_1" == null then "" else ."referral_link_1" end),
              "referral_link_2": (if ."referral_link_2" == null then "" else ."referral_link_2" end),
              "referral_link_3": (if ."referral_link_3" == null then "" else ."referral_link_3" end),
          }
         }
      }
