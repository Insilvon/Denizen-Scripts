RegionController:
  type: world
  events:
    # Replace stone with player head I guess
    on player right clicks player_head:
      # What type of player head is it
      - define chunkID:<context.location.chunk>
      - define locale:<context.location.block>
      - define customItem:<proc[CustomItemRead].context[<[chunkID]>|<[locale]>]>
      # Is it a candle?
      - if <[customItem].contains_text[Candle]>:
        # Do we have a flag for this candle?
        - if <server.has_flag[<[customItem]>_<context.location.simple>]>:
          # Yes? Okay, activate it.
          - if <server.flag[<[customItem]>_<context.location.simple>]> == lit:
            # Remove the thing
            - flag server <[customItem]>_<context.location.simple>:snuffed
            - narrate "Your candle has flickered out."
            - define theThing <context.location.cuboids.filter[notable_name.starts_with[<[customItem]>]].get[1]||null>
            - note remove as:<[theThing].notable_name>
            - execute as_server "denizen save"
          - else:
            - flag server <[customItem]>_<context.location.simple>:lit
            - define origin:<context.location.add[0,-1,0]>
            - define pos1:<[origin].add[4,-1,4]>
            - define pos2:<[origin].add[-4,1,-4]>
            - note cu@<[pos1]>|<[pos2]> as:<[customItem]>_<[origin].simple>
            - execute as_server "denizen save"
            - narrate "*You light the candle. Its aroma fills the air.*"
    # Watch for a player entering a candle-lit area
    on player enters notable cuboid:
      - if <context.cuboids.contains_text[Candle]>:
        - run CandleHandler def:<context.cuboids>
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
CandleHandler:
  type: task
  definitions: cuboid
  script:
    - if <[cuboid].contains_text[sweet]>:
      - narrate "<&a>*A satisfying sweet smell fills the air*"
      - stop
    - if <[cuboid].contains[foul]>:
      - narrate "<&c>*Your nostrils are also appalled with the scent of guck*"
      - stop

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
