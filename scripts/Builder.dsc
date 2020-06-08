BuilderTest1:
    type: assignment
    interact scripts:
    - 1 BuilderTest
BuilderTest:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Want me to build a house here?"
                        - narrate "Yes/No"
                2:
                    trigger: /Regex:Yes/
                    script:
                        - chat "Okay!"
                        - execute as_server "npc select <npc.id>"
                        - execute as_server "builder load RHZHouse1"
                        - execute as_server "builder build"