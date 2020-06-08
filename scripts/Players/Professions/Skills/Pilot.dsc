PilotTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by flying ships and
        - delivering cargo!

PilotDice:
    type: item
    material: player_head[skull_skin=2c932936-26ba-4d3d-9c7b-4c9392c6717c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZjg4ZmE5NzNlYTQ0NGNjODA4NzY4ZWE0OGJmMjY1N2FlOWE1NmMwYWY2MDI3NWU4NDQ2M2IxOTU2MjliY2UifX19]
    display name: <&a>Pilot Dice
    lore:
        - Roll based on your
        - profession's skill!

PilotSkills:
    type: yaml data
    1:
        skill: AirshipPilotKnowledge1
    2:
        skill: AirshipPilotKnowledge2
        requirements:
            - AirshipPilotKnowledge1
    3:
        skill: AirshipPilotKnowledge3
        requirements:
            - AirshipPilotKnowledge1
    4:
        skill: PilotTools
    5:
        skill: EmergencyFuel
    6:
        skill: Cartographer
    7:
        skill: Rappel
    8:
        skill: Ping

#============================SKILLS
#==============
AirshipPilotKnowledge1:
    type: item
    material: map
    display name: <&7>AirshipPilotKnowledge1
    lore:
        - Cost: 1
        - Learn how to fly
        - Medium-Class ships.
AirshipPilotKnowledge1Learned:
    type: item
    material: filled_map
    display name: <&a>AirshipPilotKnowledge1
    lore:
        - Learned how to fly
        - Medium-Class ships.
AirshipPilotKnowledge1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - execute as_server "pex user <[target].name> group add mediumairships"
#==============
AirshipPilotKnowledge2:
    type: item
    material: map
    display name: <&7>AirshipPilotKnowledge2
    lore:
        - Cost: 1
        - Learn how to fly
        - Heavy-Class ships.
AirshipPilotKnowledge2Learned:
    type: item
    material: filled_map
    display name: <&a>AirshipPilotKnowledge2
    lore:
        - Learned how to fly
        - Heavy-Class ships.
AirshipPilotKnowledge2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - execute as_server "pex user <[target].name> group add HeavyAirships"
#==============
AirshipPilotKnowledge3:
    type: item
    material: map
    display name: <&7>AirshipPilotKnowledge3
    lore:
        - Cost: 1
        - Learn how to fly
        - SuperHeavy-Class ships.
AirshipPilotKnowledge3Learned:
    type: item
    material: filled_map
    display name: <&a>AirshipPilotKnowledge3
    lore:
        - Learned how to fly
        - SuperHeavy-Class ships.
AirshipPilotKnowledge3Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - execute as_server "pex user <[target].name> group add SuperHeavyAirships"
#==============
PilotTools:
    type: item
    material: map
    display name: <&7>PilotTools
    lore:
        - Cost: 1
        - Cast to get a free compass
        - and pilot tool.
PilotToolsLearned:
    type: item
    material: filled_map
    display name: <&a>PilotTools
    lore:
        - Cast to get a free compass
        - and pilot tool.
PilotToolsCast:
    type: task
    definitions: target
    script:
        - give PilotStick
        - give PilotCompass
#==============
EmergencyFuel:
    type: item
    material: map
    display name: <&7>EmergencyFuel
    lore:
        - Cost: 2
        - Cast to convert alcoholic
        - beverages into emergency
        - fuel.
EmergencyFuelLearned:
    type: item
    material: filled_map
    display name: <&a>EmergencyFuel
    lore:
        - Cast to convert alcoholic
        - beverages into emergency
        - fuel.
EmergencyFuelCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Cartographer:
    type: item
    material: map
    display name: <&7>Cartographer
    lore:
        - Cost: 1
        - Learn how to transform
        - a piece of paper into
        - a fillable map.
CartographerLearned:
    type: item
    material: filled_map
    display name: <&a>Cartographer
    lore:
        - Learned how to transform
        - a piece of paper into
        - a fillable map.
CartographerCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - if <[target].item_in_hand> == paper:
            - take paper
            - give map
#==============
Rappel:
    type: item
    material: map
    display name: <&7>Rappel
    lore:
        - Cost: 2
        - Set a waypoint at your
        - ship. When you dive immediately
        - after, using /rescuering will
        - return you to that location.
RappelLearned:
    type: item
    material: filled_map
    display name: <&a>Rappel
    lore:
        - Set a waypoint at your
        - ship. When you dive immediately
        - after, using /rescuering will
        - return you to that location.
RappelCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> ShipRescueRing:<[target].location>
#==============
Ping:
    type: item
    material: map
    display name: <&7>Ping
    lore:
        - Cost: 1
        - Send a signal out
        - into the sky, getting
        - the location of the nearest
        - rescue ring.
PingLearned:
    type: item
    material: filled_map
    display name: <&a>Ping
    lore:
        - Send a signal out
        - into the sky, getting
        - the location of the nearest
        - rescue ring.
PingCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
