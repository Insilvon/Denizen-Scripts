#= Trainer
TrainerManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Trainer
            - inject ManagerClickEvent
    interact scripts:
    - 1 TrainerManagerInteract
TrainerManagerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello|Hi|Hey/.
                    script:
                        - chat "Greetings there. *They wipe off their dirty hands.*"
                        - wait 1.5s
                        - chat "I'm your trainer! I'm incomplete!"
                # 2:
                #     trigger: I'd like to send you to a /Regex:Node/.
                #     script:
                #         - chat "Where would you like me to go?"
                #         - wait 2s
                #         - inventory open d:DiscoveredNodeInventory
                # 3:
                #     trigger: I'd like you to come /Regex:Home/.
                #     script:
                #         - chat "Sure thing - see you there."
                #         - inject RemoveNodeManager
TrainerManagerVoucher:
    type: item
    material: paper
    display name: Trainer Manager Voucher
    lore:
        - Right click to spawn
        - a Trainer manager 
        - for your town.