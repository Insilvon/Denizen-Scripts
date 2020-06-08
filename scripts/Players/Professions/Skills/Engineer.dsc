EngineerTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by tinkering, crafting
        - airship components,
        - and making telegraphs.

EngineerDice:
    type: item
    material: player_head[skull_skin=cf07a28a-e71c-4621-9936-fa673eeab41c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTRlZmIzNDQxN2Q5NWZhYTk0ZjI1NzY5YTIxNjc2YTAyMmQyNjMzNDZjODU1M2ViNTUyNTY1OGIzNDI2OSJ9fX0=]
    display name: <&a>Engineer Dice
    lore:
        - Roll based on your
        - profession's skill!
# EngineerController:
#     type: world
#     events:
#         # Balloons
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_AirshipKnowledgeBalloon]>:
#                 - determine cancelled
#         # Engines
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_AirshipKnowledgeEngine]>:
#                 - determine cancelled
#         # Components
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_AirshipKnowledgeComponents]>:
#                 - determine cancelled
#         # Clockwork Tinkering
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_ClockworkTinkering1]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_ClockworkTinkering2]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_ClockworkTinkering3]>:
#                 - determine cancelled
#         # prismatech knowledge
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_PrismatechKnowledge]>:
#                 - determine cancelled
#         # transmission
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Transmission]>:
#                 - determine cancelled

EngineerSkills:
    type: yaml data
    1:
        skill: AirshipKnowledgeBalloon
    2:
        skill: AirshipKnowledgeEngine
    3:
        skill: AirshipKnowledgeComponent
    4:
        skill: ClockworkTinkering1
    5:
        skill: ClockworkTinkering2
        requirements:
            - ClockworkTinkering1
    6:
        skill: ClockworkTinkering3
        requirements:
            - ClockworkTinkering2
    7:
        skill: PrismatechKnowledge
    8:
        skill: Transmission

#============================SKILLS
#==============
AirshipKnowledgeBalloon:
    type: item
    material: map
    display name: <&7>AirshipKnowledgeBalloon
    lore:
        - Cost: 1
        - Learn how to craft
        - stencils for airship
        - balloons.
AirshipKnowledgeBalloonLearned:
    type: item
    material: filled_map
    display name: <&a>AirshipKnowledgeBalloon
    lore:
        - Learned how to craft
        - stencils for airship
        - balloons.
AirshipKnowledgeBalloonCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_AirshipKnowledgeBalloon
#==============
AirshipKnowledgeEngine:
    type: item
    material: map
    display name: <&7>AirshipKnowledgeEngine
    lore:
        - Cost: 1
        - Learn how to craft
        - stencils for airship
        - engines.
AirshipKnowledgeEngineLearned:
    type: item
    material: filled_map
    display name: <&a>AirshipKnowledgeEngine
    lore:
        - Learned how to craft
        - stencils for airship
        - engines.
AirshipKnowledgeEngineCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_AirshipKnowledgeEngine
#==============
AirshipKnowledgeComponent:
    type: item
    material: map
    display name: <&7>AirshipKnowledgeComponent
    lore:
        - Cost: 1
        - Learn how to craft
        - stencils for airship
        - components.
AirshipKnowledgeComponentLearned:
    type: item
    material: filled_map
    display name: <&a>AirshipKnowledgeComponent
    lore:
        - Learned how to craft
        - stencils for airship
        - components.
AirshipKnowledgeComponentCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_AirshipKnowledgeComponent
#==============
ClockworkTinkering1:
    type: item
    material: map
    display name: <&7>ClockworkTinkering1
    lore:
        - Cost: 1
        - Gain new recipes
        - for clockwork componenets.
ClockworkTinkering1Learned:
    type: item
    material: filled_map
    display name: <&a>ClockworkTinkering1
    lore:
        - Gained new recipes
        - for clockwork componenets.

ClockworkTinkering1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_ClockworkTinkering1
#==============
ClockworkTinkering2:
    type: item
    material: map
    display name: <&7>ClockworkTinkering2
    lore:
        - Cost: 1
        - Gain more new recipes
        - for clockwork componenets.
ClockworkTinkering2Learned:
    type: item
    material: filled_map
    display name: <&a>ClockworkTinkering2
    lore:
        - Gained more new recipes
        - for clockwork componenets.
ClockworkTinkering2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_ClockworkTinkering2
#==============
ClockworkTinkering3:
    type: item
    material: map
    display name: <&7>ClockworkTinkering3
    lore:
        - Cost: 1
        - Gain even more new recipes
        - for clockwork componenets.
ClockworkTinkering3Learned:
    type: item
    material: filled_map
    display name: <&a>ClockworkTinkering3
    lore:
        - Gained even more new recipes
        - for clockwork componenets.
ClockworkTinkering3Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_ClockworkTinkering3
#==============
PrismatechKnowledge:
    type: item
    material: map
    display name: <&7>PrismatechKnowledge
    lore:
        - Cost: 1
        - Learn how to create
        - devices and mechanisms
        - to use prismatech.
PrismatechKnowledgeLearned:
    type: item
    material: filled_map
    display name: <&a>PrismatechKnowledge
    lore:
        - Learned how to create
        - devices and mechanisms
        - to use prismatech.
PrismatechKnowledgeCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_PrismatechKnowledge
#==============
Transmission:
    type: item
    material: map
    display name: <&7>Transmission
    lore:
        - Cost: 1
        - Learn how to craft
        - Telegraph kits.
TransmissionLearned:
    type: item
    material: filled_map
    display name: <&a>Transmission
    lore:
        - Learned how to craft
        - Telegraph kits.
TransmissionCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Transmission
