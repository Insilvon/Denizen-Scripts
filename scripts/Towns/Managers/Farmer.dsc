#= Farmer
FarmerManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Farmer
            - inject ManagerClickEvent
FarmerManagerVoucher:
    type: item
    material: paper
    display name: Farmer Manager Voucher
    lore:
        - Right click to spawn
        - a farmer manager 
        - for your town.