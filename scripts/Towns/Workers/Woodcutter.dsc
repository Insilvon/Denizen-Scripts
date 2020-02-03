WoodcutterWorkerVoucher:
    type: item
    material: paper
    display name: Farmworker Voucher
    lore:
        - Right click to spawn
        - a farm worker 
        - for your town.
WoodcutterWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 WoodcutterWorkerInteract
WoodcutterWorkerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                    - chat "Hello"