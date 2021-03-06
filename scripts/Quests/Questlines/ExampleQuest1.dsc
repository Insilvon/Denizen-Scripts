# Quest Template
# Made and designed for AETHERIA
# @author Insilvon
# @version 1.0.0
# Quest Template Prototype
# Allows for quick and easy setup of Quests

#====================================================#
#======================NPC Container=================#
#====================================================#
Example1Assignment:
    type: assignment
    actions:
        on assignment:
        - narrate "Assignment set!"
        - trigger name:proximity state:true
        on click:
        - narrate "Hello!" targets:<server.match_player[Insilvon]>
        on enter proximity:
        - narrate "See you! Your character is <proc[GetCharacterName].context[<player>]>" targets:<server.match_player[Insilvon]>
        - define step:<player.flag[<proc[GetCharacterName].context[<player>]>_<npc>]||1>
        - narrate "Zapping to step <[step]>"
        - zap step:<[step]> s@Example1Interact player:<player>
    interact scripts:
    - 1 Example1Interact

Example1Interact:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Greetings. I'm the Example 1 npc. I have a quest for you, if you're interested."
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                2:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "See ya"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                3:
                    trigger: /Regex:Quest/
                    script:
                        - chat "All I want you to do is to come say hello!"
                        - chat "Accept/Decline"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                        - zap 2
        2:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Say Accept/Decline"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2
                2:
                    trigger: /Regex:Accept/
                    script:
                        - chat "Ok cool thanks"
                        - run AddActiveQuest def:<player>|Example1GuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                        - zap 3
                3:
                    trigger: /Regex:Decline/
                    script:
                        - chat "Whatever okay"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                4:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "Bye"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:2

        3:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - chat "Hey thanks for coming to say hello - I appreciate it!"
                        - run AddCompletedQuest def:<player>|Example1QuestCompleted
                        - run RemoveActiveQuest def:<player>|Example1GuideBook
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:1
                        - zap 1
                2:
                    trigger: /Regex:Remind/
                    script:
                        - chat "All I want you to do is to come say hello!"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
                3:
                    trigger: /Regex:Goodbye/
                    script:
                        - chat "See ya"
                        - flag player <proc[GetCharacterName].context[<player>]>_<npc>:3
#====================================================#
#======================QuestItems====================#
#====================================================#
Example1GuideBook:
    type: book
    author: Active Quest
    title: <&a>Example Quest 1
    signed: yes
    text:
        - "This is what you were asked to do"
        - "Should be the same as your quest remind"
Example1QuestCompleted:
    type: book
    author: Completed Quest
    title: <&a>Example Quest 1
    signed: yes
    text:
        - "This is a one-page description of the quest. Do not exceed one page."
