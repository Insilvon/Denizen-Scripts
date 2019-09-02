# # Alchemy Circle Proof of Concept
# # Made and designed for AETHERIA
# # @author Insilvon
# # @version 1.2.1
# # Allows players to place custom items to summon an alchemy circle
# # This version supports 4 node input, order important, quantity important utilities


# # - if <context.location.cuboids.contains_text[TransmutationCircle]>:
#         # - determine passively cancelled
#         # - run AlchemyCircleNodeController instantly def:<context.location.center.relative[0,1,0]>|<player.item_in_hand.scriptname||<player.item_in_hand.simple>>|<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>|gold_block
# # replace .relative with .add or .below
# # create procedure for recipe checks
# # clean up definitions for runs
# # drop note l@
# # - if <[theItem]> != i@air:
#   # NEVER EVER EVER
#   # compare object form
#   # swap - define theItem:<player.item_in_hand.scriptname||<player.item_in_hand.simple>>
#   # for
#   # - define theItem:<player.item_in_hand.scriptname||<player.item_in_hand.material.name>>
#   # and compare != air
#   # - flag server <[theCuboid].notable_name>_diamond_block_quantity:+:1
#   # just ++
#   # increment

# # aaand
# # for longer events like the diamond one
# # instead of
# # - if <context.location.cuboids.contains_text[TransmutationCircle]>:
# # with all that code inside it
# # just do
# # - if !<context.location.cuboids.contains_text[TransmutationCircle]>:
# #           - stop
# # and then have all the remaining script at the normal level of the section


# # Main controller script
# # Listens for players interacting with Key Nodes, as well as
# # Determining what to drop when the circle is complete.
# AlchemyCircleController:
#   type: world
#   events:
#     on player places TransmutationCircle:
#       - determine passively cancelled
#       - wait 1t
#       - take TransmutationCircle
#       - define locale:<context.location>
#       - schematic load name:TransCircle
#       - define origin:<[locale].relative[0,-1,0]>
#       - schematic paste name:TransCircle <[origin]>
#       - note l@<[origin]> as:TransmutationCircleOrigin_<[origin].simple>
#       - define pos1:<[origin].relative[4,-1,4]>
#       - define pos2:<[origin].relative[-4,1,-4]>
#       - note cu@<[pos1]>|<[pos2]> as:TransmutationCircle_<[origin].simple>
#       - narrate "<&4>Dark Alchemy<&co> Transmutation Circle Created"
#       - execute as_server "denizen save"
#     # North Node

#     on player right clicks gold_block with item:
#       - if <context.location.cuboids.contains_text[TransmutationCircle]>:
#         - determine passively cancelled
#         - run AlchemyCircleNodeController instantly def:<context.location.center.relative[0,1,0]>|<player.item_in_hand.scriptname||<player.item_in_hand.simple>>|<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>|gold_block
#     # East Node
#     on player right clicks lapis_block with item:
#       - if <context.location.cuboids.contains_text[TransmutationCircle]>:
#         - determine passively cancelled
#         - run AlchemyCircleNodeController instantly def:<context.location.center.relative[0,1,0]>|<player.item_in_hand.scriptname||<player.item_in_hand.simple>>|<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>|lapis_block
#     # South Node
#     on player right clicks iron_block with item:
#       - if <context.location.cuboids.contains_text[TransmutationCircle]>:
#         - determine passively cancelled
#         - run AlchemyCircleNodeController instantly def:<context.location.center.relative[0,1,0]>|<player.item_in_hand.scriptname||<player.item_in_hand.simple>>|<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>|iron_block
#     # West Node
#     on player right clicks emerald_block with item:
#       - if <context.location.cuboids.contains_text[TransmutationCircle]>:
#         - determine passively cancelled
#         - run AlchemyCircleNodeController instantly def:<context.location.center.relative[0,1,0]>|<player.item_in_hand.scriptname||<player.item_in_hand.simple>>|<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>|emerald_block
#     # Center Node
#     on player right clicks diamond_block with item:
#       - if <context.location.cuboids.contains_text[TransmutationCircle]>:
#         - determine passively cancelled
#         # Handle the regular stuff
#         - define locale:<context.location.center.relative[0,1,0]>
#         - define theItem:<player.item_in_hand.scriptname||<player.item_in_hand.simple>>
#         - define theCuboid:<context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>
#         - if <[theItem]> != i@air:
#           - if !<server.has_flag[<[theCuboid].notable_name>_diamond_block]>:
#             - spawn e@dropped_item[item=<[theItem]>;gravity=false;velocity=0,0,0;pickup_delay=1d] <[locale]>
#             # Example server flag: TransmutationCircle_1,1,1,buildworld_lapis_block_DiamondSword
#             - flag server <[theCuboid].notable_name>_diamond_block:<[theItem]>
#             - flag server <[theCuboid].notable_name>_diamond_block_quantity:1
#             - take <[theItem]>
#           - else:
#             - if <server.flag[<[theCuboid].notable_name>_diamond_block]> == <[theItem].simple>:
#               - spawn e@dropped_item[item=<[theItem]>;gravity=false;velocity=0,0,0;pickup_delay=1d] <[locale]>
#               - flag server <[theCuboid].notable_name>_diamond_block_quantity:+:1
#               - take <[theItem]>
#               - stop
#         - else:
#         # Set up your variables
#           - define theItem:<player.item_in_hand.scriptname||<player.item_in_hand.simple>>
#           - define theCuboid <context.location.cuboids.filter[notable_name.starts_with[TransmutationCircle]].get[1]>
#           - define locale:<context.location.center.relative[0,1,0]>
#           # Define the item and quantity of items present at each node
#           - define NorthNode:<server.flag[<[theCuboid].notable_name>_gold_block]||nothing>
#           - define NorthQuantity:<server.flag[<[theCuboid].notable_name>_gold_block_quantity]>
#           - define EastNode:<server.flag[<[theCuboid].notable_name>_lapis_block]||nothing>
#           - define EastQuantity:<server.flag[<[theCuboid].notable_name>_lapis_block_quantity]>
#           - define SouthNode:<server.flag[<[theCuboid].notable_name>_iron_block]||nothing>
#           - define SouthQuantity:<server.flag[<[theCuboid].notable_name>_iron_block_quantity]>
#           - define WestNode:<server.flag[<[theCuboid].notable_name>_emerald_block]||nothing>
#           - define WestQuantity:<server.flag[<[theCuboid].notable_name>_emerald_block_quantity]>
#           - define CenterNode:<server.flag[<[theCuboid].notable_name>_diamond_block]||nothing>
#           - define CenterQuantity:<server.flag[<[theCuboid].notable_name>_diamond_block_quantity]>
#           # Now that the items have been removed, clear the flags so the circle can reset
#           - flag server <[theCuboid].notable_name>_gold_block:!
#           - flag server <[theCuboid].notable_name>_gold_block_quantity:!
#           - flag server <[theCuboid].notable_name>_iron_block:!
#           - flag server <[theCuboid].notable_name>_iron_block_quantity:!
#           - flag server <[theCuboid].notable_name>_lapis_block:!
#           - flag server <[theCuboid].notable_name>_lapis_block_quantity:!
#           - flag server <[theCuboid].notable_name>_emerald_block:!
#           - flag server <[theCuboid].notable_name>_emerald_block_quantity:!
#           - flag server <[theCuboid].notable_name>_diamond_block:!
#           - flag server <[theCuboid].notable_name>_diamond_block_quantity:!
#           # Clear all dropped item entities to "empty" the circle
#           - remove <player.location.find.entities.within[50].exclude[<player>]>

#           # Run logic to determine what to drop
#           # TODO: Find a better way of doing this - minimally repeating through a list, maybe adding sorting by
#           # Nodes at higher levels.
#           - inject TransmutationSwordCircleRecipe
#           - inject DeadBrainCoralCircleRecipe
#           - inject SpongeCircleRecipe
#           - inject DoubleTransSwordCircleRecipe
#           - inject TransmutationAxeCircleRecipe
#           - inject WitherSkeletonCircleRecipe
#           - inject TreeCircleRecipe
#           - inject DaeronsInstantFortressCircleRecipe
#           # If everything fails, you can run these commands.
#           # TODO: Create a task script which does RNG damage/death/Cthulhu spawning.
#           - narrate "<&4>Dark Alchemy<&co> Your transmutation has failed"

# # Accessory script which actually handles the item dropping
# # And memory of each node. If the server acknowledges your node is active, you can add
# # Duplicate materials to a node. Otherwise, it will activate the node and assign your
# # item to it.
# AlchemyCircleNodeController:
#   type: task
#   definitions: locale|theItem|theCuboid|theNode
#   script:
#     - if !<server.has_flag[<[theCuboid].notable_name>_<[theNode]>]>:
#       - spawn e@dropped_item[item=<[theItem]>;gravity=false;velocity=0,0,0;pickup_delay=1d] <[locale]>
#       # Example server flag: TransmutationCircle_1,1,1,buildworld_lapis_block_DiamondSword
#       - flag server <[theCuboid].notable_name>_<[theNode]>:<[theItem]>
#       - flag server <[theCuboid].notable_name>_<[theNode]>_quantity:1
#       - take <[theItem]>
#     - else:
#       - if <server.flag[<[theCuboid].notable_name>_gold_block]> == <[theItem].simple>:
#         - spawn e@dropped_item[item=<[theItem]>;gravity=false;velocity=0,0,0;pickup_delay=1d] <[locale]>
#         - flag server <[theCuboid].notable_name>_<[theNode]>_quantity:+:1
#         - take <[theItem]>
TempScript99:
  type: task
  script:
    - narrate "Hi there!"
