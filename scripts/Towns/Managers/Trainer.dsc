#= Trainer
TrainerManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Trainer
            - inject ManagerClickEvent
TrainerManagerVoucher:
    type: item
    material: paper
    display name: Trainer Manager Voucher
    lore:
        - Right click to spawn
        - a Trainer manager 
        - for your town.