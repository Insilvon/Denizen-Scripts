# Lootbox controller script - listens for the events and runs the tasks
test:
  type: world
  events:
    on player picks up diamond:
      - narrate "Working"
    on player right clicks with lootbox_voucher:
      - give lootbox_item
      - take lootbox_voucher
      - narrate "Enjoy your box!"
    on player places common_lootbox:
      - determine passively cancelled
      - take common_lootbox
      - explode power:2 <player.location.cursor_on[]>
      - playeffect effect:FIREWORKS_SPARK at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HAPPY_VILLAGER at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HEART at <player.location.cursor_on[]> quantity:10
      - playeffect effect:lava at <player.location.cursor_on[]> quantity:10
      - run common_drops
    on player places rare_lootbox:
      - determine passively cancelled
      - take rare_lootbox
      - explode power:2 <player.location.cursor_on[]>
      - playeffect effect:FIREWORKS_SPARK at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HAPPY_VILLAGER at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HEART at <player.location.cursor_on[]> quantity:10
      - playeffect effect:lava at <player.location.cursor_on[]> quantity:10
      - run rare_drops
    on player places epic_lootbox:
      - determine passively cancelled
      - take epic_lootbox
      - explode power:2 <player.location.cursor_on[]>
      - playeffect effect:FIREWORKS_SPARK at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HAPPY_VILLAGER at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HEART at <player.location.cursor_on[]> quantity:10
      - playeffect effect:lava at <player.location.cursor_on[]> quantity:10
      - run epic_drops
    on player places legendary_lootbox:
      - determine passively cancelled
      - take legendary_lootbox
      - explode power:2 <player.location.cursor_on[]>
      - playeffect effect:FIREWORKS_SPARK at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HAPPY_VILLAGER at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HEART at <player.location.cursor_on[]> quantity:10
      - playeffect effect:lava at <player.location.cursor_on[]> quantity:10
      - run legendary_drops
    on player picks up common_preview:
      - wait 0.05
      - take common_preview
      - run common_rewards
    on player picks up rare_preview:
      - wait 0.05
      - take rare_preview
      - run rare_rewards
    on player picks up epic_preview:
      - wait 0.05
      - take epic_preview
      - run epic_rewards
    on player picks up legendary_preview:
      - wait 0.05
      - take legendary_preview
      - run legendary_rewards
    on player places lootbag:
      - determine passively cancelled
      - take lootbag
      - explode power:2 <player.location.cursor_on[]>
      - playeffect effect:FIREWORKS_SPARK at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HAPPY_VILLAGER at <player.location.cursor_on[]> quantity:10
      - playeffect effect:HEART at <player.location.cursor_on[]> quantity:10
      - playeffect effect:lava at <player.location.cursor_on[]> quantity:10
      - run legendary_drops
    on common_preview merges:
      - determine cancelled
    on rare_preview merges:
      - determine cancelled
    on epic_preview merges:
      - determine cancelled
    on legendary_preview merges:
      - determine cancelled

lootbox_task:
  type: task
  script:
    - define randomNumber "<util.random.int[1].to[100]>"
    - if <def[randomNumber]> <= 1:
      - run give_legendary_rewards
    - else if <def[randomNumber]> <= 3:
      - run epic_rewards
    - else if <def[randomNumber]> <= 25:
      - run rare_rewards
    - else:
      - run common_rewards
#===============================#
#==========Item Scripts=========#
#===============================#

# Preview Blocks that will change into the actual rewards
lootbag:
  type: Item
  material: player_head[skull_skin=914e68b0-4550-4c2c-bbee-dc903e8485f5|"eyJ0aW1lc3RhbXAiOjE1NjM2MzE3NTA0ODksInByb2ZpbGVJZCI6ImIwZDRiMjhiYzFkNzQ4ODlhZjBlODY2MWNlZTk2YWFiIiwicHJvZmlsZU5hbWUiOiJ4RmFpaUxlUiIsInNpZ25hdHVyZVJlcXVpcmVkIjp0cnVlLCJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzYwYTA4ZGE4ZDNlNzNjNWFkZGNjMTAzODk1NjU2YWM0MDRmZjQyZjJkNWI1Yjc0NmNjZGU2MDdjZTkwNDQzYyJ9fX0=]
  display name: Lootbag

common_preview:
  type: item
  material: white_stained_glass
  display name: "Common Preview Item"
rare_preview:
  type: item
  material: green_stained_glass

epic_preview:
  type: item
  material: cyan_stained_glass

legendary_preview:
  type: item
  material: yellow_stained_glass

divine_preview:
  type: item
  material: pink_stained_glass

untiered_preview:
  type: item
  material: purple_stained_glass

# Voucher which gives the user a test lootbox

lootbox_voucher:
  type: item
  material: paper
  display name: "Lootbox Voucher"
  enchantments:
  - LURE:1

# Common Variant
common_lootbox:
  type: item
  material: light_gray_shulker_box
  display name: "<&7>Common Lootbox"


# Rare Variant

rare_lootbox:
  type: item
  material: green_shulker_box
  display name: "<&a>Rare Lootbox"


# Epic Variant

epic_lootbox:
  type: item
  material: cyan_shulker_box
  display name: "<&3>Epic Lootbox"


# Legendary Variant

legendary_lootbox:
  type: item
  material: yellow_shulker_box
  display name: "<&e>Legendary Lootbox"

# Divine Variant

divine_lootbox:
  type: item
  material: pink_shulker_box
  display name: "<&d>Divine Lootbox"

# Untiered Variant

untiered_lootbox:
  type: item
  material: purple_shulker_box
  display name: "<&5>Untiered Lootbox"


#===============================#
#============Rewards============#
#===============================#

test_rewards:
  type: task
  script:
    - drop common_preview <player.location.cursor_on[5]>
    - drop common_preview <player.location.cursor_on[5]>
    - drop common_preview <player.location.cursor_on[5]>
    - define randomNumber "<util.random.int[1].to[100]>"
    - if <def[randomNumber]> <= 25:
      - drop rare_preview <player.location.cursor_on[5]>

common_drops:
  type: task
  script:
    - drop common_preview <player.location.cursor_on[5]>
    - drop common_preview <player.location.cursor_on[5]>
    - drop common_preview <player.location.cursor_on[5]>
    - define randomNumber "<util.random.int[1].to[100]>"
    - if <def[randomNumber]> <= 25:
      - drop rare_preview <player.location.cursor_on[5]>

rare_drops:
  type: task
  script:
    - drop common_preview <player.location.cursor_on[5]>
    - drop rare_preview <player.location.cursor_on[5]>
    - drop rare_preview <player.location.cursor_on[5]>
    - define randomNumber "<util.random.int[1].to[100]>"
    - if <def[randomNumber]> <= 25:
      - drop rare_preview <player.location.cursor_on[5]>

epic_drops:
  type: task
  script:
    - drop common_preview <player.location.cursor_on[5]>
    - drop rare_preview <player.location.cursor_on[5]>
    - drop epic_preview <player.location.cursor_on[5]>
    - define randomNumber "<util.random.int[1].to[100]>"
    - if <def[randomNumber]> <= 5:
      - drop epic_preview <player.location.cursor_on[5]>
    - else if <def[randomNumber]> <=25:
      - drop rare_preview <player.location.cursor_on[5]>

legendary_drops:
  type: task
  script:
    - drop rare_preview <player.location.cursor_on[5]>
    - drop epic_preview <player.location.cursor_on[5]>
    - drop legendary_preview <player.location.cursor_on[5]>
    - define randomNumber "<util.random.int[1].to[100]>"
    - if <def[randomNumber]> <= 5:
      - drop epic_preview <player.location.cursor_on[5]>
    - else if <def[randomNumber]> <=25:
      - drop rare_preview <player.location.cursor_on[5]>


#===============================#
#======Actual Item Rewards======#
#===============================#

common_rewards:
  type: task
  script:
    - random
    {
      - give wooden_sword
      - give wooden_axe
      - give wooden_pickaxe
    }
rare_rewards:
  type: task
  script:
    - random
    {
      - give stone_sword
      - give stone_axe
      - give stone_pickaxe
    }
epic_rewards:
  type: task
  script:
    - random
    {
      - give iron_sword
      - give iron_axe
      - give iron_pickaxe
    }
legendary_rewards:
  type: task
  script:
    - random
    {
      - give gold_sword
      - give gold_axe
      - give gold_pickaxe
    }
