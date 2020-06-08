ApothecaryTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by growing herbs, making
        - salves, and brewing potions!

ApothecaryDice:
    type: item
    material: player_head[skull_skin=b9999bb0-e46c-49cc-b02d-249110eabac2|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWMzY2VjNjg3NjlmZTljOTcxMjkxZWRiN2VmOTZhNGUzYjYwNDYyY2ZkNWZiNWJhYTFjYmIzYTcxNTEzZTdiIn19fQ==]
    display name: <&a>Apothecary Dice
    lore:
        - Roll based on your
        - profession's skill!

# ApothecaryController:
#     type: world
#     events:
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Healing1]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Healing2]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Healing3]>:
#                 - determine cancelled
#         #----
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Poison1]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Poison2]>:
#                 - determine cancelled
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Poison3]>:
#                 - determine cancelled
#         #candles
#         on x|x|x recipe formed:
#             - define character:<proc[GetCharacterName].context[<player>]||null>
#             - if !<player.has_flag[<[character]>_Apothecary]>:
#                 - determine cancelled
#             - if !<player.has_flag[<[character]>_Profession_Candlemaker]>:
#                 - determine cancelled
        
                
ApothecarySkills:
    type: yaml data
    1:
        skill: Herbalism1
    2:
        skill: Herbalism2
        requirements:
            - Herbalism1
    3:
        skill: Herbalism3
        requirements:
            - Herbalism2
    4:
        skill: Healing1
    5:
        skill: Healing2
        requirements:
            - Healing1
    6:
        skill: Poison1
    7:
        skill: Poison2
        requirements:
            - Poison1
    8:
        skill: Potions1
    9:
        skill: Potions2
        requirements:
            - Potions1
    10:
        skill: Candlemaker

ApothecaryLevels:
    type: yaml data
    1:
        exp: 5
    2:
        exp: 10
    3:
        exp: 20
    4:
        exp: 25

#============================= SKILLS
Herbalism1:
    type: item
    material: map
    display name: <&7>Herbalism1
    lore:
        - Cost: 1
        - Learn how to grow the first
        - tier of custom herbs.
Herbalism1Learned:
    type: item
    material: filled_map
    display name: <&a>Herbalism1
    lore:
        - Learned how to grow the first
        - tier of custom herbs.
Herbalism1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Herbalism1
#==============
Herbalism2:
    type: item
    material: map
    display name: <&7>Herbalism2
    lore:
        - Cost: 1
        - Learn how to grow the second
        - tier of custom herbs.
Herbalism2Learned:
    type: item
    material: filled_map
    display name: <&a>Herbalism2
    lore:
        - Learned how to grow the second
        - tier of custom herbs.
Herbalism2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Herbalism2
#==============
Herbalism3:
    type: item
    material: map
    display name: <&7>Herbalism3
    lore:
        - Cost: 1
        - Learn how to grow the third
        - tier of custom herbs.
Herbalism3Learned:
    type: item
    material: filled_map
    display name: <&a>Herbalism3
    lore:
        - Learned how to grow the
        - third tier of custom herbs.
Herbalism3Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Herbalism3
#==============
Healing1:
    type: item
    material: map
    display name: <&7>Healing1
    lore:
        - Cost: 1
        - Learn how to convert
        - custom herbs into
        - basic salves.
Healing1Learned:
    type: item
    material: filled_map
    display name: <&a>Healing1
    lore:
        - Learned how to convert
        - custom herbs into
        - basic salves.
Healing1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Healing1
#==============
Healing2:
    type: item
    material: map
    display name: <&7>Healing2
    lore:
        - Cost: 1
        - Learn how to convert
        - custom herbs and
        - ingredients into
        - remedies.
Healing2Learned:
    type: item
    material: filled_map
    display name: <&a>Healing2
    lore:
        - Learned how to convert
        - custom herbs and
        - ingredients into
        - remedies.

Healing2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Healing2
#==============
Poison1:
    type: item
    material: map
    display name: <&7>Poison1
    lore:
        - Cost: 1
        - Learn how to create
        - a basic tier of poisons
        - with inconveinent effects.
Poison1Learned:
    type: item
    material: filled_map
    display name: <&a>Poison1
    lore:
        - Learned how to create
        - a basic tier of poisons
        - with inconveinent effects.
Poison1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Poison1
#==============
Poison2:
    type: item
    material: map
    display name: <&7>Poison2
    lore:
        - Cost: 1
        - Learn how to create
        - an intermediate tier of poisons
        - with dangerous effects.
Poison2Learned:
    type: item
    material: filled_map
    display name: <&a>Poison2
    lore:
        - Learned how to create
        - an intermediate tier of poisons
        - with dangerous effects.
Poison2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Poison2
#==============
Healing1:
    type: item
    material: map
    display name: <&7>Healing1
    lore:
        - Cost: 1
        - Learn how to create
        - various items to help
        - in curing wounds.
Healing1Learned:
    type: item
    material: filled_map
    display name: <&a>Healing1
    lore:
        - Learned how to create
        - various items to help
        - in curing wounds.
Healing1Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Healing1
#==============
Healing2:
    type: item
    material: map
    display name: <&7>Healing2
    lore:
        - Cost: 1
        - Learn how to create
        - an intermediate tier of
        - items to remedy illness.
Healing2Learned:
    type: item
    material: filled_map
    display name: <&a>Healing2
    lore:
        - Learned how to create
        - an intermediate tier of
        - items to remedy illness.
Healing2Cast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Healing2
#==============
Candlemaker:
    type: item
    material: map
    display name: <&7>Candlemaker
    lore:
        - Cost: 1
        - Learn how to use
        - ingredients and wax
        - to create your own candles
        - and essential oils.
CandlemakerLearned:
    type: item
    material: filled_map
    display name: <&a>Candlemaker
    lore:
        - Learned how to use
        - ingredients and wax
        - to create your own candles
        - and essential oils.
CandlemakerCast:
    type: task
    definitions: target
    script:
        - define character:<player.flag[CharacterSheet_CurrentCharacter]>
        - if <[character]> == null:
            - narrate "You need a character to do this!"
            - stop
        - flag <[target]> <[character]>_Profession_Candlemaker
