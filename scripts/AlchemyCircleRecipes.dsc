# Alchemy Circle Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.1
# Allows players to place custom items to summon an alchemy circle
# This version supports 4 node input, order important, quantity important utilities

# These are all recipes which can be made within an Alchemy Circle
TransmutationSwordCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == gold_ingot && <[GoldQuantity]> == 1:
      - if <[LapisNode]> == lapis_lazuli && <[LapisQuantity]> == 1:
        - if <[IronNode]> == iron_ingot && <[IronQuantity]> == 1:
          - if <[EmeraldNode]> == emerald && <[EmeraldQuantity]> == 1:
            - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
            - spawn e@dropped_item[item=TransmutationSword;gravity=false;velocity=0,0,0] <[pos]>
            - stop
DeadBrainCoralCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == salmon:
      - if <[LapisNode]> == pufferfish:
        - if <[IronNode]> == tropical_fish:
          - if <[EmeraldNode]> == cod:
            - if <[DiamondNode]> == cobblestone:
              - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
              - spawn e@dropped_item[item=dead_brain_coral_block;gravity=false;velocity=0,0,0] <[pos]>
              - stop
SpongeCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == bucket:
      - if <[LapisNode]> == yellow_wool:
        - if <[IronNode]> == dead_brain_coral_block:
          - if <[EmeraldNode]> == hay_block:
            - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
            - spawn e@dropped_item[item=sponge;gravity=false;velocity=0,0,0] <[pos]>
            - stop
DoubleTransSwordCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == gold_ingot && <[GoldQuantity]> == 2:
      - if <[LapisNode]> == lapis_lazuli && <[LapisQuantity]> == 2:
        - if <[IronNode]> == iron_ingot && <[IronQuantity]> == 2:
          - if <[EmeraldNode]> == emerald && <[EmeraldQuantity]> == 2:
            - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
            - spawn e@dropped_item[item=TransmutationSword;gravity=false;velocity=0,0,0] <[pos]>
            - spawn e@dropped_item[item=TransmutationSword;gravity=false;velocity=0,0,0] <[pos]>
            - stop
TransmutationAxeCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == emerald:
      - if <[LapisNode]> == gold_ingot:
        - if <[IronNode]> == lapis_lazuli:
          - if <[EmeraldNode]> == iron_ingot:
            - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
            - spawn e@dropped_item[item=TransmutationAxe;gravity=false;velocity=0,0,0] <[pos]>
            - stop
WitherSkeletonCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == flint_and_steel:
      - if <[LapisNode]> == nether_brick:
        - if <[IronNode]> == coal:
          - if <[EmeraldNode]> == glowstone_dust:
            - if <[DiamondNode]> = skeleton_skull:
              - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
              #- spawn e@dropped_item[item=wither_skeleton_skull;gravity=false;velocity=0,0,0] <[pos]>
              - spawn Wither_skeleton <[pos]>
              - stop
TreeCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == oak_sapling:
      - if <[LapisNode]> == podzol:
        - if <[IronNode]> == bone_meal:
          - if <[EmeraldNode]> == grass_block:
            - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
            # - spawn e@dropped_item[item=wither_skeleton_skull;gravity=false;velocity=0,0,0] <[pos]>
            - schematic load name:TreeTest
            - schematic paste name:TreeTest <[pos]> noair
            - narrate "Schematic TreeTest pasted!"
            - stop
DaeronsInstantFortressCircleRecipe:
  type: task
  script:
    - if <[GoldNode]> == iron_block && <[GoldQuantity]> == 2:
      - if <[LapisNode]> == stone_bricks && <[LapisQuantity]> == 10:
        - if <[IronNode]> == anvil:
          - if <[EmeraldNode]> == stone && <[EmeraldQuantity]> == 10:
            - narrate "<&4>Dark Alchemy<&co> Transmutation Complete"
            - schematic load name:FortressTest
            - schematic paste name:FortressTest <[pos].relative[0,-1,0]> noair
            - stop
