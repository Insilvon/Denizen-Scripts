MinerWorkerVoucher:
    type: item
    material: paper
    display name: Farmworker Voucher
    lore:
        - Right click to spawn
        - a farm worker 
        - for your town.
MinerWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 MinerWorkerInteract
MinerWorkerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                    - chat "Hello"