# Alchemy Circle Proof of Concept
# Made and designed for AETHERIA
# @author Insilvon
# @version 2.0.4
# Allows players to place custom items to summon an alchemy circle
# This version supports 4 node input, order important, quantity important utilities

AlchemyCircleController:
    type: world
    events:
        on player places TransmutationCircle:
            - determine passively cancelled
            - wait 1t
            - take TransmutationCircle
            - define origin:<context.location.add[0,-1,0]>
            - define pos1:<[origin].add[4,-1,4]>
            - define pos2:<[origin].add[-4,1,-4]>
            - schematic load name:TransCircle
            - schematic paste name:TransCircle <[origin]>
            - note cu@<[pos1]>|<[pos2]> as:TransmutationCircle_<[origin].simple>
            - execute as_server "denizen save"
            - narrate "<&4>Dark Alchemy<&co> *The Alchemy Circle whirls to life under your feet.*"

        # Node Handler
        on player right clicks gold_block|lapis_block|iron_block|emerald_block|diamond_block:
            - if !<context.location.cuboids.contains_text[TransmutationCircle]>:
                - stop
            - determine passively cancelled
            - define pos:<context.location.center.add[0,1,0]>
            - define ingredient:<player.item_in_hand.scriptname||<player.item_in_hand.material.name>>
            - define circle:<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>
            - define node:<context.location.material.name>
            - if <[node]> == diamond_block && <[ingredient]> == air:
                - run AlchemyCircleTransmute instantly def:<[ingredient]>|<[circle]>|<[pos]>
                - stop
            - if <[ingredient]> != air:
                - run AlchemyCircleNodeController instantly def:<[pos]>|<[ingredient]>|<[circle]>|<[node]>

AlchemyCircleTransmute:
    type: task
    definitions: ingredient|circle|pos
    script:
        # Define the item and quantity of items present at each node
        # Clear flags to allow the circle to be reused
        - foreach li@Gold|Lapis|Iron|Emerald|Diamond as:node:
            - define <[node]>Node:<server.flag[<[circle].notable_name>_<[node]>_block]||air>
            - define <[node]>Quantity:<server.flag[<[circle].notable_name>_<[node]>_block_quantity]||0>
            - flag server <[circle].notable_name>_<[node]>_block:!
            - flag server <[circle].notable_name>_<[node]>_block_quantity:!

        # Clear all dropped item entities to "empty" the circle
        - remove <player.location.find.entities.within[50].exclude[<player>]>
        - if <player.has_flag[dev]>:
            - run AddToAlchemyFile def:<player.chat_history[1]>|<[GoldNode]>|<[LapisNode]>|<[IronNode]>|<[EmeraldNode]>|<[DiamondNode]>|<[GoldQuantity]>|<[LapisQuantity]>|<[IronQuantity]>|<[EmeraldQuantity]>|<[DiamondQuantity]>
            - narrate "Recipe Created"
            - stop
        # TODO: Turn this into a procedure to determine what to drop instead
        - inject AlchemyCircleRecipeChecks
        # If everything fails, you can run these commands.
        # TODO: Create a task script which does RNG damage/death/Cthulhu spawning.
        - narrate "<&4>Dark Alchemy<&co> Your transmutation has failed"
# Accessory script which actually handles the item dropping
# And memory of each node. If the server acknowledges your node is active, you can add
# Duplicate materials to a node. Otherwise, it will activate the node and assign your
# item to it.
AlchemyCircleNodeController:
    type: task
    definitions: pos|ingredient|circle|node
    script:
        - if !<server.has_flag[<[circle].notable_name>_<[node]>]>:
            - spawn e@dropped_item[item=<[ingredient]>;gravity=false;velocity=0,0,0;pickup_delay=1d] <[pos]>
            # Example server flag: TransmutationCircle_1,1,1,buildworld_lapis_block_DiamondSword
            - flag server <[circle].notable_name>_<[node]>:<[ingredient]>
            - flag server <[circle].notable_name>_<[node]>_quantity:1
            - take <[ingredient]>
            - narrate "<&4>Dark Alchemy<&co> You feel <[ingredient]> float from your hand into the circle."
        - else:
            - if <server.flag[<[circle].notable_name>_<[node]>]> == <[ingredient]>:
                - spawn e@dropped_item[item=<[ingredient]>;gravity=false;velocity=0,0,0;pickup_delay=1d] <[pos]>
                - flag server <[circle].notable_name>_<[node]>_quantity:++
                - take <[ingredient]>

# TODO: Turn this into a procedure
AlchemyCircleRecipeChecks:
    type: task
    script:
        - foreach TransmutationSwordCircleRecipe|DeadBrainCoralCircleRecipe|SpongeCircleRecipe|DoubleTransSwordCircleRecipe|TransmutationAxeCircleRecipe|WitherSkeletonCircleRecipe|TreeCircleRecipe|DaeronsInstantFortressCircleRecipe as:check:
            - inject <[check]>
