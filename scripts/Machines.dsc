# Machines Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.1
# Placeable Schematics which serve a purpose, similar to popular Spigot Plugins which exist
# Last Change: added general world subscripts
# TODO://

MachineController:
  type: world
  events:
    on player places TestMachine:
      # - narrate "<&c>[Machines]<&co> You are placing a machine."
      # - narrate "<&c>[Machines]<&co> Block location is <context.location>"
      - note cu@<context.location>|<context.location> as:testmachine_<context.location.simple>
      - execute as_server "denizen save"
    on player places YellowCore:
      - determine passively cancelled
      - wait 1t
      - take YellowCore
      - define locale:<context.location>
      - schematic load name:AlchemyStation
      - schematic paste name:AlchemyStation <[locale].relative[0,1,0]> noair
      - define pos1:<[locale].relative[1,0,1]>
      - define pos2:<[locale].relative[-1,0,-1]>
      # - modifyblock <[pos1]> sea_lantern
      # - modifyblock <[pos2]> gold_block
      - note cu@<[pos1]>|<[pos2]> as:AlchemyStation_<[locale].simple>
      - narrate "<&c>[Machines]<&co> An Alchemy Station has been created!"
      - execute as_server "denizen save"

    on player right clicks Composter:
      # - narrate <context.location>
      # - narrate <context.location.cuboids>
      # - narrate <context.location.cuboids.contains_text[AlchemyStation]>
      - if <context.location.cuboids.contains_text[AlchemyStation]>:
        - define locale <context.location.cuboids.filter[notable_name.starts_with[AlchemyStation]].get[1]>
        - narrate "<&a>*You peer into the Alchemy Station*"
        - inventory open d:in@TempInventory
    on player right clicks with BLAZE_ROD:
      - narrate <context.location.cuboids>
TestMachine:
  type: item
  material: cobblestone
  display name: TestMachine

AlchemyStationCore:
  type: item
  material: Stone
  display name: Alchemy Station Core
  lore:
    - A component for an
    - Alchemy Station.
TransmutationCircle:
  type: item
  material: redstone_block
  display name: Transmutation Circle

CustomItemFrame:
  type: item
  material: item_frame
  mechanisms:
    - block_facing:UP

TransmutationSword:
  type: item
  material: diamond_sword
  display name: <&c>Sword of Transmutation
  lore:
    - A sword which proves that through
    - faith and pseudoscience,
    - all things are possible.
TransmutationAxe:
  type: item
  material: diamond_axe
  display name: <&c>Axe of Transmutation
  lore:
    - An Axe which proves that through
    - faith and pseudoscience,
    - all things are possible.
MachineOnPlayerBreaksBlock:
  type: task
  script:
      - define cubes:<context.location.cuboids>
      - define theCuboid <context.location.cuboids.filter[notable_name.starts_with[testmachine]].get[1]||null>
      - run MachineCheck def:<[cubes]>|<[theCuboid]>