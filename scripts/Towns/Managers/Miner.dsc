#= Miner
MinerManagerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
        on click:
            - define npcType:Miner
            - inject ManagerClickEvent
MinerManagerVoucher:
    type: item
    material: paper
    display name: Miner Manager Voucher
    lore:
        - Right click to spawn
        - a Miner manager 
        - for your town.