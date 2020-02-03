#= Blacksmith
BlacksmithManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Blacksmith
            - inject ManagerClickEvent
BlacksmithManagerVoucher:
    type: item
    material: paper
    display name: Blacksmith Manager Voucher
    lore:
        - Right click to spawn
        - a blacksmith manager
        - for your town.