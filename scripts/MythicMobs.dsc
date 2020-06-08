RobonoidRebellion1:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 RobonoidRebellionI1
RobonoidRebellionI1:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hey|Hello|Hi|Greetings|Help/
                    script:
                        - chat "I can take you to the fuel station! Would you like to go?"
                2:
                    trigger: /Regex:Yes|Yeah|Okay/.
                    script:
                        - chat "Alright, let's go."
                        - teleport <player.location.find.players.within[8]> l@-1320,220,-2598,skyworld_v2
RobonoidRebellion:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 RobonoidRebellionI
RobonoidRebellionI:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hey|Hello|Hi|Greetings|Help/
                    script:
                        - chat "I can take you back to brewhaven! Would you like to go?"
                2:
                    trigger: /Regex:Yes|Yeah|Okay/.
                    script:
                        - chat "Alright, let's go."
                        - teleport <player.location.find.players.within[8]> l@-876,224,-712,skyworld_v2
MythicMobsController:
    type: world
    events:
        on mythicmob Robonoid1 death:
            - random:
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidBlade <context.entity.location>
                - drop RobonoidSoulStone <context.entity.location>
        on mythicmob Robonoid2 death:
            - random:
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidBlade <context.entity.location>
                - drop RobonoidSoulStone <context.entity.location>
        on mythicmob Robonoid3 death:
            - random:
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidBlade <context.entity.location>
                - drop RobonoidSoulStone <context.entity.location>
        on mythicmob Robonoid4 death:
            - random:
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidPlating <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidChestCavity <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidLeg <context.entity.location>
                - drop RobonoidBlade <context.entity.location>
                - drop RobonoidSoulStone <context.entity.location>
RobonoidChestCavity:
    type: item
    material: gold_ingot
    display name: <&e>Robonoid Chest Component
    lore:
        - The chest cavity
        - of a robonoid shell.
        - A small slot for a 
        - stone or crystal is set
        - in the opening.
RobonoidLeg:
    type: item
    material: gold_ingot
    display name: <&e>Robonoid Leg
    lore:
        - The leg component of
        - a robonoid exoskeleton.
        - The intricate system of steam
        - based pistons allows for incredible
        - strength and durability.
RobonoidPlating:
    type: item
    material: gold_nugget
    display name: <&e>Robonoid Plating
    lore:
        - The armor plating from
        - a robonoid husk. Strong,
        - durable, and shiny, this
        - plating is used in many
        - industrial projects.
RobonoidBlade:
    type: item
    material: gold_sword[flags=HIDE_ENCHANTS]
    display name: <&e>Robonoid Armblade
    lore:
        - The arm blade torn from a
        - Robonoid Arm. With the ability
        - to unfold into a larger blade,
        - this shining copper structure
        - is incredibly sharp.
    enchantments:
        - DURABILITY:5
        - DAMAGE_ALL:6
RobonoidSoulStone:
    type: item
    material: diamond[flags=hide_enchants]
    display name: <&b>Robonoid Heartstone
    lore:
        - A small, compact, glittering
        - crystal which sits inside of
        - the robonoid chest cavity.
        - It is said that this crystal
        - contains the power that fuels
        - the Robonoid<&sq>s AI systems.