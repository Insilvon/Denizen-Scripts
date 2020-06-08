TradesmanTooltip:
    type: item
    material: player_head[skull_skin=945906b4-6fdc-4b99-9a26-30906befb63a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjM4YzUzZTY2ZjI4Y2YyYzdmYjE1MjNjOWU1ZGUxYWUwY2Y0ZDdhMWZhZjU1M2U3NTI0OTRhOGQ2ZDJlMzIifX19]
    display name: <&a>Help Item
    lore:
        - Gain profession levels
        - by crafting blueprints,
        - building constructions,
        - and reaping rewards.

TradesmanDice:
    type: item
    material: player_head[skull_skin=cf07a28a-e71c-4621-9936-fa673eeab41c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTRlZmIzNDQxN2Q5NWZhYTk0ZjI1NzY5YTIxNjc2YTAyMmQyNjMzNDZjODU1M2ViNTUyNTY1OGIzNDI2OSJ9fX0=]
    display name: <&a>Tradesman Dice
    lore:
        - Roll based on your
        - profession's skill!

TradesmanSkills:
    type: yaml data
    1:
        skill: ArchitectEye
    2:
        skill: AdeptCamper
    3:
        skill: BuilderEfficiency
    4:
        skill: Ringleader
    5:
        skill: ToolsOfTheTrade
    6:
        skill: TradesmanUnion
    7:
        skill: WatchfulEye
#=========================SKILLS
#==============
ArchitectEye:
    type: item
    material: map
    display name: <&7>ArchitectEye
    lore:
        - Cost: 1
        - When you discover a town you
        - haven't seen before, unlock
        - a stencil for a home in that
        - style.
ArchitectEyeLearned:
    type: item
    material: filled_map
    display name: <&a>ArchitectEye
    lore:
        - When you discover a town you
        - haven't seen before, unlock
        - a stencil for a home in that
        - style.
ArchitectEyeCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
AdeptCamper:
    type: item
    material: map
    display name: <&7>AdeptCamper
    lore:
        - Cost: 1
        - Unlock stencils
        - and schematics to
        - rapidly build campground
        - items like tents and campfires.
AdeptCamperLearned:
    type: item
    material: filled_map
    display name: <&a>AdeptCamper
    lore:
        - Learned stencils
        - and schematics to
        - rapidly build campground
        - items like tents and campfires.
AdeptCamperCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
BuilderEfficiency:
    type: item
    material: map
    display name: <&7>BuilderEfficiency
    lore:
        - Cost: 1
        - When placing some construction
        - driven blocks, sometimes you do
        - not lose the material.
BuilderEfficiencyLearned:
    type: item
    material: filled_map
    display name: <&a>BuilderEfficiency
    lore:
        - When placing some construction
        - driven blocks, sometimes you do
        - not lose the material.
BuilderEfficiencyCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
Ringleader:
    type: item
    material: map
    display name: <&7>Ringleader
    lore:
        - Cost: 2
        - Once a week,
        - get a randomized free
        - manager or worker.
RingleaderLearned:
    type: item
    material: filled_map
    display name: <&a>Ringleader
    lore:
        - Once a week,
        - get a randomized free
        - manager or worker.
RingleaderCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
ToolsOfTheTrade:
    type: item
    material: map
    display name: <&7>ToolsOfTheTrade
    lore:
        - Cost: 1
        - Learn crafting recipes
        - for various construction
        - custom items.
ToolsOfTheTradeLearned:
    type: item
    material: filled_map
    display name: <&a>ToolsOfTheTrade
    lore:
        - Learned crafting recipes
        - for various construction
        - custom items.
ToolsOfTheTradeCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
TradesmanUnion:
    type: item
    material: map
    display name: <&7>TradesmanUnion
    lore:
        - Cost: 2
        - Once a day, place a stack
        - of building materials into
        - a special inventory and
        - double your investment.
TradesmanUnionLearned:
    type: item
    material: filled_map
    display name: <&a>TradesmanUnion
    lore:
        - Once a day, place a stack
        - of building materials into
        - a special inventory and
        - double your investment.
TradesmanUnionCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
#==============
WatchfulEye:
    type: item
    material: map
    display name: <&7>WatchfulEye
    lore:
        - Cost: 2
        - An active ability which
        - prevents all fall damage
        - for 3 minutes.
WatchfulEyeLearned:
    type: item
    material: filled_map
    display name: <&a>WatchfulEye
    lore:
        - An active ability which
        - prevents all fall damage
        - for 3 minutes.
WatchfulEyeCast:
    type: task
    definitions: target
    script:
        - narrate "WIP"
