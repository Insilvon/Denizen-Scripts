# Region Controller
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# All scripts which manage Custom Regions, as well as events relating to
# Aetheria notable cuboids/locations

RegionController:
  type: world
  events:
    # Watch for a player entering a candle-lit area
    on player enters notable cuboid:
      - if <context.cuboids.contains_text[Candle]>:
        - run CandleScentText def:<context.cuboids>
    on player enters ColdRegion:
      - if !<player.has_flag[Cold]>:
        - flag player Cold
        - narrate "You enter the tundra and feel the icy tendrils of frost grip at your bones."
        - if <player.flag[SnowRes].is[LESS].than[1]>:
          - narrate "You are unprotected against the wilds, and so you shiver."
        - if !<player.has_flag[SnowRes]>:
          - flag player SnowRes:0
        - run ColdController
    on player exits ColdRegion:
      - narrate "You feel the warmth of the sun hit you as you exit the cold."
      - wait 5s
      - flag player Cold:!
  # Item Events
    on player equips SnowBoots:
      - flag player SnowRes:+:1
    on player unequips SnowBoots:
      - flag player SnowRes:-:1

# Redirect Script which determines which flavortext to narrate

# Individual Controller Scripts
# Template:
# YourController:
#   type: task
#   script:
#     - while <player.flag[RegionResistance].is[LESS].than[1].AND[<player.location.is_within[YourRegion]>]>:
#       - hurt 10
#       - wait 10

ColdController:
  type: task
  script:
    - while <player.flag[SnowRes].is[LESS].than[1].AND[<player.location.is_within[ColdRegion]>]>:
      - hurt 10
      - wait 10

# TODO: Individual Item Scripts - MOVE THESE!
SnowBoots:
  type: Item
  material: leather_boots
  display name: TEST SNOW BOOTS
