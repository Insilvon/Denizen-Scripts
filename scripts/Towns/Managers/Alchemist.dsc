
#= Alchemist
AlchemistManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Alchemist
            - inject ManagerClickEvent
AlchemistManagerVoucher:
    type: item
    material: paper
    display name: Alchemist Manager Voucher
    lore:
        - Right click to spawn
        - a Alchemist manager 
        - for your town.