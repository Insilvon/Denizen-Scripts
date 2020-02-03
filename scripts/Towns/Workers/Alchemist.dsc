AlchemistWorkerVoucher:
    type: item
    material: paper
    display name: Alchemist Voucher
    lore:
        - Right click to spawn
        - a Alchemist
        - for your town.
AlchemistWorkerAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
    - 1 AlchemistWorkerInteract
AlchemistWorkerInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                    - chat "Hello"