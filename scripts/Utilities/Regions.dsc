# Region Controller
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1
# All scripts which manage Custom Regions, as well as events relating to
# Aetheria notable cuboids/locations
GenerateMaps:
    type: task
    script:
        - map new:skyworld_v2 image:SunTeahouse.png resize save:map
        - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:Brewhaven.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:CrimsonSun.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:CrimsonDelta.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:GeezerGarage.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:Lapidas.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:MiasmyynCove.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:Genevah.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
        # - map new:skyworld_v2 image:Centrecrest.png resize save:map
        # - give filled_map[map=<entry[map].created_map>]
BrewhavenMap:
    type: item
    material: filled_map[map=839]
    display name: <&a>Brewhaven
CrimsonSunMap:
    type: item
    material: filled_map[map=840]
    display name: <&c>Crimson Sun
CrimsonDeltaMap:
    type: item
    material: filled_map[map=841]
    display name: <&c>Crimson Delta
GeezerGarageMap:
    type: item
    material: filled_map[map=842]
    display name: <&b>Geezer Garage
LapidasMap:
    type: item
    material: filled_map[map=843]
    display name: <&a>Lapidas
MiasmyynCoveMap:
    type: item
    material: filled_map[map=844]
    display name: <&3>Miasmyyn Cove
GenevahMap:
    type: item
    material: filled_map[map=845]
    display name: <&a>Genevah
CentrecrestMap:
    type: item
    material: filled_map[map=846]
    display name: <&e>Centrecrest
SunTeahouseMap:
    type: item
    material: filled_map[map=852]
    display name: <&e>The Sun Teahouse

RegionController:
    type: world
    debug: false
    events:
        # Watch for a player entering a candle-lit area
        on player enters Picody:
            - title title:<&6>Picody "subtitle:<&c>Skyborne Settlement" targets:<player>
        on player enters SunTeahouse:
            - title "title:<&e>The Sun Teahouse" "subtitle:日 茶店" targets:<player>
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[SunTeahouse]>:
                - flag player Discoveries:->:SunTeahouse
                - narrate "<&a>You have discovered the Sun Teahouse."
        on player enters CrimsonDeltaDiscovery:
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[CrimsonDelta]>:
                - flag player Discoveries:->:CrimsonDelta
                - narrate "<&a>You have discovered the Crimson Delta."
        on player enters CrimsonSunDiscovery:
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[CrimsonSun]>:
                - flag player Discoveries:->:CrimsonSun
                - narrate "<&a>You have discovered the Crimson Sun."
        on player enters LapidasDiscovery:
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[Lapidas]>:
                - flag player Discoveries:->:Lapidas
                - narrate "<&a>You have discovered Lapidas."
        on player enters MiasmyynCoveDiscovery:
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[MiasmyynCove]>:
                - flag player Discoveries:->:MiasmyynCove
                - narrate "<&a>You have discovered Miasmyyn Cove."
        on player enters GenevahDiscovery:
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[Genevah]>:
                - flag player Discoveries:->:Genevah
                - narrate "<&a>You have discovered Genevah."
        on player enters centrecrest_173:
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[Centrecrest]>:
                - flag player Discoveries:->:Centrecrest
                - narrate "<&a>You have discovered Centrecrest."

        on player enters notable cuboid:
            - if <context.cuboids.contains_text[Candle]>:
              - run CandleScentText def:<context.cuboids>
        on player enters Brewhaven:
            - title "title:<&a>Brewhaven" "subtitle:Safety in the Sky" targets:<player>
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[Brewhaven]>:
                - flag player Discoveries:->:Brewhaven
                - narrate "<&a>You have discovered Brewhaven."
        on player enters BrewhavenInn:
            - title "title:<&8>Steel Dragon Tavern" "subtitle:The Hidden Gem" targets:<player>
        on player enters GeezerGarage:
            - title "title:<&6>The Old Geezer Garage" "subtitle:~ * Premium Airships, Premium Prices * ~" targets:<player>
            - if !<player.has_flag[Discoveries]> || !<player.flag[Discoveries].contains[GeezerGarage]>:
                - flag player Discoveries:->:GeezerGarage
                - narrate "<&a>You have discovered the Geezer Garage."
        on player enters KamiShrine:
            - title "title:<&c>Kami Shrine" "subtitle:"
            - narrate "<&8>*You feel an overwhelming presence here.*"
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
    debug: off
    script:
        - while <player.flag[SnowRes].is[LESS].than[1].AND[<player.location.is_within[ColdRegion]>]>:
            - hurt 10
            - wait 10

# TODO: Individual Item Scripts - MOVE THESE!
SnowBoots:
    type: Item
    material: leather_boots
    display name: TEST SNOW BOOTS
