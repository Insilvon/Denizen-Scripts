#= Woodcutter
WoodcutterManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Woodcutter
            - inject ManagerClickEvent
WoodcutterManagerVoucher:
    type: item
    material: paper
    display name: Woodcutter Manager Voucher
    lore:
        - Right click to spawn
        - a Woodcutter manager 
        - for your town.

