. | {"data":
         {"details_about_journalist": {
             "name": ."name" | tostring,
             "age": (if ."age" == null then "" else ."age" end),
             "gender": ."gender" | tostring,
             "image_url": (if ."image_url" == null then "" else ."image_url" end),
             "is_freelancer": ."is_freelancer" | tostring,
             "organisation": (if ."organisation" == null then "" else ."organisation" end),
             "organisation_type": ."organisation_type" | tostring,
             "beat": (if ."beat" == null then "" else ."beat" end),
             "journalist_body_of_work": (if ."journalist_body_of_work" == null then "" else ."journalist_body_of_work" end)
         },
          "when_and_where_it_occur": {
              "date": ."date" | tostring,
              "location": ."location" | tostring,
              "state": ."state" | tostring,
              "lat": ."lat" | tonumber,
              "lng": ."lng" | tonumber,
              "nature_of_assault": ."nature_of_assault" | tostring,
              "accused_names": (if ."accused_names" == null then "" else ."accused_names" end),
              "description_of_attack": (if ."description_of_attack" == null then "" else ."description_of_attack" end),
              "motive_of_attack": (if ."motive_of_attack" == null then "" else ."motive_of_attack" end),
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
