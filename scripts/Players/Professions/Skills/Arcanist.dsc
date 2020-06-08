ArcanistTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by performing carefully
        - calculated alchemical
        - reactions!

ArcanistDice:
    type: item
    material: player_head[skull_skin=64040bcc-1db6-4f5b-9aad-838fdce9d0a6|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTMzOTgzODEzOTI2NGRlMjY2NjVmYzFjNWI4NWQ2NTg5ODkyNjI2OTJkMzg1YTJlNWFmN2I4YWVhMmJkYzYifX19]
    display name: <&a>Arcanist Dice
    lore:
        - Roll based on your
        - profession's skill!
ArcanistSkills:
    type: yaml data
    1:
        skill: CircleCreation
    2:
        skill: Chemistry
    3:
        skill: Summoning
    4:
        skill: Construction
    5:
        skill: Transcription
    6:
        skill: Enchanting1
    7:
        skill: Enchanting2
        requirements:
            - Enchanting1
    8:
        skill: Enchanting3
        requirements:
            - Enchanting2
    9:
        skill: Enchanting4
        requirements:
            - Enchanting3
    10:
        skill: Transmutation


#==============SKILLS
#==============
CircleCreation:
    type: item
    material: map
    display name: <&7>CircleCreation
    lore:
        - Cost: 1
CircleCreationLearned:
    type: item
    material: filled_map
    display name: <&a>CircleCreation
    lore:

CircleCreationCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Chemistry:
    type: item
    material: map
    display name: <&7>Chemistry
    lore:
        - Cost: 1
ChemistryLearned:
    type: item
    material: filled_map
    display name: <&a>Chemistry
    lore:

ChemistryCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Summoning:
    type: item
    material: map
    display name: <&7>Summoning
    lore:
        - Cost: 1
SummoningLearned:
    type: item
    material: filled_map
    display name: <&a>Summoning
    lore:

SummoningCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Construction:
    type: item
    material: map
    display name: <&7>Construction
    lore:
        - Cost: 1
ConstructionLearned:
    type: item
    material: filled_map
    display name: <&a>Construction
    lore:

ConstructionCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Transcription:
    type: item
    material: map
    display name: <&7>Transcription
    lore:
        - Cost: 1
TranscriptionLearned:
    type: item
    material: filled_map
    display name: <&a>Transcription
    lore:

TranscriptionCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Enchanting1:
    type: item
    material: map
    display name: <&7>Enchanting1
    lore:
        - Cost: 1
Enchanting1Learned:
    type: item
    material: filled_map
    display name: <&a>Enchanting1
    lore:

Enchanting1Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Enchanting2:
    type: item
    material: map
    display name: <&7>Enchanting2
    lore:
        - Cost: 1
Enchanting2Learned:
    type: item
    material: filled_map
    display name: <&a>Enchanting2
    lore:

Enchanting2Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Enchanting3:
    type: item
    material: map
    display name: <&7>Enchanting3
    lore:
        - Cost: 1
Enchanting3Learned:
    type: item
    material: filled_map
    display name: <&a>Enchanting3
    lore:

Enchanting3Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Enchanting4:
    type: item
    material: map
    display name: <&7>Enchanting4
    lore:
        - Cost: 1
Enchanting4Learned:
    type: item
    material: filled_map
    display name: <&a>Enchanting4
    lore:

Enchanting4Cast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Transmutation:
    type: item
    material: map
    display name: <&7>Transmutation
    lore:
        - Cost: 1
TransmutationLearned:
    type: item
    material: filled_map
    display name: <&a>Transmutation
    lore:

TransmutationCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
