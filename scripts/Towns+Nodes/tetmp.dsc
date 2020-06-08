TestAssignment2:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment successfully set"
        on click:
            - narrate "Hello!"
GenerateMapNotables:
    type: task
    script:
        - foreach li@CrimsonDelta.png|Centrecrest.png|Lapidas.png|Brewhaven.png|SteelDragon.png|GeezerGarage.png|CrimsonSun.png|Genevah.png|MiasmyynCove.png as:locale:
            - map new:world image:<[locale]> resize save:map
            - give filled_map[map=<entry[map].created_map>]