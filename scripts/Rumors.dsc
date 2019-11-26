CharacterSetupAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
    interact scripts:
        - 1 CharacterSetupInteract
CharacterSetupInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex: Hello/
                    script:
                        - chat "Hello"