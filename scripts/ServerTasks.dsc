# =================================================================================
# ==========================="Kernal Core Setup Script"============================
# =================================================================================

# =================================================================================
# ===========================Custom Block YAML Add/Edit============================
# =================================================================================

CreateChunkFile:
  type: task
  definitions: chunkID|locale|theItem
  script:
    - yaml create id:<[chunkID]>
    - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
    - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
    - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
    - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
    - yaml unload id:<[chunkID]>
AddToChunkFile:
  type: task
  definitions: chunkID|locale|theItem
  speed: 3t
  script:
    - yaml "load:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
    - yaml id:<[chunkID]> set info.<[locale]>:<[theItem]>
    - yaml "savefile:/ChunkData/<[chunkID]>.yml" id:<[chunkID]>
    - yaml unload id:<[chunkID]>

# =================================================================================
# ============================Custom File YAML Add/Edit============================
# =================================================================================
AlchemyDevMode:
  type: command
  name: dev
  description: What
  usage: /dev
  script:
    - if <player.has_flag[dev]>:
      - flag player dev:!
    - else:
      - flag player dev
CreateAlchemyFile:
  type: task
  script:
    - yaml create id:recipes
    - yaml "savefile:/Recipes/recipes.yml" id:recipes
    - yaml "load:/Recipes/recipes.yml" id:recipes
    - yaml id:recipes set TestRecipe.GoldNode:stone
    - yaml id:recipes set TestRecipe.LapisNode:stone
    - yaml id:recipes set TestRecipe.IronNode:stone
    - yaml id:recipes set TestRecipe.EmeraldNode:stone
    - yaml "savefile:/Recipes/recipes.yml" id:recipes
    - yaml unload id:recipes
AddToAlchemyFile:
  type: task
  definitions: RecipeName|GoldNode|LapisNode|IronNode|EmeraldNode|DiamondNode|GoldQuantity|LapisQuantity|IronQuantity|EmeraldQuantity|DiamondQuantity
  script:
    - yaml "load:/Recipes/recipes.yml" id:recipes
    - yaml id:recipes set <[RecipeName]>.GoldNode:<[GoldNode]>
    - yaml id:recipes set <[RecipeName]>.LapisNode:<[LapisNode]>
    - yaml id:recipes set <[RecipeName]>.IronNode:<[IronNode]>
    - yaml id:recipes set <[RecipeName]>.EmeraldNode:<[EmeraldNode]>
    - yaml id:recipes set <[RecipeName]>.DiamondNode:<[DiamondNode]>
    - yaml id:recipes set <[RecipeName]>.GoldQuantity:<[GoldQuantity]>
    - yaml id:recipes set <[RecipeName]>.LapisQuantity:<[LapisQuantity]>
    - yaml id:recipes set <[RecipeName]>.IronQuantity:<[IronQuantity]>
    - yaml id:recipes set <[RecipeName]>.EmeraldQuantity:<[EmeraldQuantity]>
    - yaml id:recipes set <[RecipeName]>.DiamondQuantity:<[DiamondQuantity]>
    - yaml "savefile:/Recipes/recipes.yml" id:recipes
ReadAlchemyFile:
  type: task
  definitions: GoldNode|LapisNode|IronNode|EmeraldNode|DiamondNode|GoldQuantity|LapisQuantity|IronQuantity|EmeraldQuantity|DiamondQuantity
  script:
    - yaml "load:/Recipes/recipes.yml" id:recipes
    - define recipes:<yaml[recipes].list_keys[]>
    # Go through all recipes
    - foreach <[recipes]> as:recipe:
      - narrate "<[recipe]>"
      - define components:<yaml[recipes].list_keys[<[recipe]>]>
      # Define all components of the recipe
      - foreach <[components]> as:component:
        # - narrate "<[component]><&co><yaml[recipes].read[<[recipe]>.<[component]>]>"
        - define <[component]>_loaded:<yaml[recipes].read[<[recipe]>.<[component]>]>
      # Loop through them all, checking against the flag counterpart
      - define status:true
      - foreach GoldNode|LapisNode|IronNode|EmeraldNode|DiamondNode|GoldQuantity|LapisQuantity|IronQuantity|EmeraldQuantity|DiamondQuantity as:Node:
        - narrate "Comparing <[<[Node]>_loaded]> and <[<[Node]>]>"
        - if <[<[Node]>_loaded]> != <[<[Node]>]>:
          - define status:false
          - foreach stop
      - if <[status]>:
        - narrate "True! Matched <[recipe]>"
        - give <[recipe]>
        - stop
    - narrate "Failed! No matches found"
TestRecipe1:
  type: item
  material: gold_block
  display name: Test Recipe 1
TestRecipe2:
  type: item
  material: iron_block
  display name: Test Recipe 2
TestRecipe3:
  type: item
  material: diamond_block
  display name: Test Recipe 3
# AddToFile:
#   type: task
#   script:
#     - yaml create id:test
#     - yaml "savefile:/ChunkData/test.yml" id:test
#     - yaml "load:/ChunkData/test.yml" id:test
#     # Set data here
#     - yaml id:test set info.username:<player.name>
#     - yaml id:test set permissions.character_limit:2
#     - yaml "savefile:/ChunkData/test.yml" id:test
#     - yaml unload id:test
#
# AddToFile2:
#   type: task
#   speed: 3t
#   script:
#     - yaml "load:/ChunkData/test.yml" id:test
#     # Set data here
#     - yaml id:test set re.rere:hello
#     - yaml "savefile:/ChunkData/test.yml" id:test
#     - yaml unload id:test
#     - narrate "complete"
