MonetaMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MobMerchantInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MobMerchantI
MonetaMerchantI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "Hello there... Are you in the game of catching animals?"
                        - wait 1s
                        - chat "May I perhaps interest someone as humble as you to look at my wares?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MobMerchantInventory
                        - inventory open d:NewMerchantInventory
# Moneta Cook
MonetaCookMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MonetaCookInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MonetaCookI
MonetaCookI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "Hello there. You like food!?"
                        - wait 1s
                        - chat "May I perhaps interest someone as humble as you to look at my wares?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MonetaCookInventory
                        - inventory open d:NewMerchantInventory

# Jewler
MonetaJewelerMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MonetaJewelerInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MonetaJewelerI
MonetaJewelerI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "I see you're an individual of fashion..."
                        - wait 1s
                        - chat "May I perhaps interest someone as humble as you to look at my wares?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MonetaJewelerInventory
                        - inventory open d:NewMerchantInventory
# Naturalist 1 Crops
MonetaCropMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MonetaCropInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MonetaCropI
MonetaCropI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "Crops! Crops! Get your newfound special crops here!"
                        - wait 1s
                        - chat "You in!? Man, I have plants!"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MonetaCropInventory
                        - inventory open d:NewMerchantInventory
# Fish Fish
MonetaFishMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MonetaFishInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MonetaFishI
MonetaFishI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "You like fish?"
                        - wait 1s
                        - chat "Well? Do you?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MonetaFishInventory
                        - inventory open d:NewMerchantInventory
# Brewer W/ New Recipes
MonetaBrewerMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MonetaBrewerInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MonetaBrewerI
MonetaBrewerI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "You like Brewing?"
                        - wait 1s
                        - chat "I mean I do. I like recipes too!"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MonetaBrewerInventory
                        - inventory open d:NewMerchantInventory
# Moneta Animal
MonetaAnimalMerchant:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - flag player NPCInventory:MonetaAnimalInventory
            - inventory open d:NewMerchantInventory
        on exit proximity:
            - inject SaveNPCStep
        on enter proximity:
            - inject LoadNPCStep
    interact scripts:
    - 1 MonetaAnimalI
MonetaAnimalI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hey|Hi|Greetings/.
                    script:
                        - chat "Hello there. You like food!?"
                        - wait 1s
                        - chat "May I perhaps interest someone as humble as you to look at my wares?"
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Most excellent..."
                        - wait 1s
                        - flag player NPCInventory:MonetaAnimalInventory
                        - inventory open d:NewMerchantInventory

MonetaArchaeologist:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 MonetaArchaeologistI
MonetaArchaeologistI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hi|Hey|Hello|Greetings/.
                    script:
                        - wait 1s
                        - chat "Hello there. I'm giving away goodies you see... quite! Would you be interested in buying something from me?"
                        - wait 1s
                        - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Hear what they have to say.]<&f><&end_click><&end_hover>"
                2:
                    trigger: /Regex:Yes/, that sounds good.
                    script:
                        - chat "Wonderful! I'm archaeologist, you see. I collect rare artifacts and cool trinkets I find when I'm exploring the world."
                        - wait 2s
                        - chat "*They hold open a bag in front of you, gently swinging it so you can hear the items inside jumble around.*"
                        - wait 2s
                        - chat "I'll sell you one of my artifacts... for 100 emeralds. Seem fair?"
                        - narrate "<&hover[Click Me!]><&click[I'd like an Artifact.]><&f>[Purchase an artifact]<&f><&end_click><&end_hover>"
                3:
                    trigger: Give me an /Regex:Artifact./
                    script:
                        - define cost:100
                        - define continue:<proc[CheckEmeraldBag].context[<player>|<[cost]>]>
                        - narrate "<[continue]>"
                        - if <[continue]> && <player.inventory.can_fit[grass_block].quantity[<[quantity]>]>:
                            - run TakeFromEmeraldBag def:<player>|<[cost]>
                            - random:
                                - give LimestoneFishFossil
                                - give LimestonePalmLeafFossil
                                - give LimestoneDinosaurTrackFossil
                                - give LimestoneShellFossil
                                - give LimestoneDinosaurSkullFossil
                                - give LimestoneTrilobyteFossil
                                - give ShaleFishFossil
                                - give ShalePalmLeafFossil
                                - give ShaleDinosaurTrackFossil
                                - give ShaleShellFossil
                                - give ShaleDinosaurSkullFossil
                                - give ShaleTrilobyteFossil
                                - give SandstoneFishFossil
                                - give SandstonePalmLeafFossil
                                - give SandstoneDinosaurTrackFossil
                                - give SandstoneShellFossil
                                - give SandstoneDinosaurSkullFossil
                                - give SandstoneTrilobyteFossil
                                - give QuartzGeode
                                - give AmethystGeode
                                - give EmeraldGeode
                                - give SapphireGeode
                                - give RoseQuartzGeode
                                - give NetherQuartzGeode
                            - chat "A pleasure doing business with you!"
                        - else:
                            - chat "You don't appear to have enough emeralds for this!"

# # Smith

# # Masterwork
# MonetaMasterworkMerchant:
#     type: assignment
#     actions:
#         on assignment:
#             - narrate "Assignment set!"
#         on click:
#             - flag player NPCInventory:MonetaMasterworkInventory
#             - inventory open d:NewMerchantInventory
#         on exit proximity:
#             - inject SaveNPCStep
#         on enter proximity:
#             - inject LoadNPCStep
#     interact scripts:
#     - 1 MonetaMasterworkI
# MonetaMasterworkI:
#     type: interact
#     steps:
#         1:
#             chat trigger:
#                 1:
#                     trigger: /Regex:Hello|Hey|Hi|Greetings/.
#                     script:
#                         - chat "You like Masterwork?"
#                         - wait 1s
#                         - chat "Well? Do you?"
#                         - narrate "<&hover[Click Me!]><&click[Yes, that sounds good.]><&f>[Offer to trade some goods.]<&f><&end_click><&end_hover>"
#                 2:
#                     trigger: /Regex:Yes/, that sounds good.
#                     script:
#                         - chat "Most excellent..."
#                         - wait 1s
#                         - flag player NPCInventory:MonetaMasterworkInventory
#                         - inventory open d:NewMerchantInventory
# # 