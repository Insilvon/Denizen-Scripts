# # Custom Smithing


# CustomSmithingController:
#   type: world
#   events:
#     # Add events here
#     on player right clicks with SharpeningTool:
#       - if <EntityTag.item_in_offhand> == "i@air":
#         - narrate "<&c>[Crafting]<&co> You must be holding an item in your offhand!"
#       - if <EntityTag.item_in_offhand> == SharpeningTool:
#         - narrate "<&c>[Crafting]<&ca> You cannot sharpen this item!"
#       - else:
#         - run SharpenItem


# # Add attribute Tasks:
# SharpenItem:
#   type: task
#   script:
#     - define currentSharpness:<player.item_in_offhand.enchantments.level[DAMAGE_ALL]>
#     # If this item has already been refined
#     - if <player.item_in_offhand.has_nbt[Refined]>:
#       - if <player.item_in_offhand.nbt[Refined]> < 5:
#         # Increase the thing
#       - else:
#         - narrate "<&c>[Crafting]<&ca> This item can no longer be enhanced!"
#     # If the custom item hasn't been refined already...
#     - else:
#       - nbt <player.item_in_offhand> "Refined:1" "save:edited"
#       - inventory set "slot:<player.item_in_offhand.slot" "o:<entry[edited].new_item>"
# # Items


SharpeningTool:
  type: item
  material: iron_nugget
  display name: Sharpen
