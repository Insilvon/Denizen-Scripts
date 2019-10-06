completeddescription:
    type: item
    material: paper
    display name: completeddescription
JournalistAssignment:
    type: assignment
    actions:
        on assignment:
            - narrate "Assignment set!"
            - trigger name:click state:true
        on click:
            - random:
                - narrate "*The journalist looks up from their desk, eyeing the object in your hands.*"
                - narrate "*As you approach, the journalist peers up at you.*"
                - narrate "*The sounds of quills scratching against parchment cease as you approach.*"
            - if <player.item_in_hand.script.contains_text[completeddescription]>:
                - chat "You got news for me? Fine. I guess I<&sq>ll take it and have a look."
                - random:
                    - narrate "*They begin to comb through the pages, reading the description of the event.*"
                    - narrate "*Slowly, they trace a finger over the ink on the page.*"
                    - narrate "*As the journalist studies your work, they squint.*"
                    - narrate "*They dip their quill in red ink, prepared to scratch out anything they see fit.*"
                - random:
                    - chat "Fine fine - I<&sq>ll consider having a look. Get on - there<&sq>s work to do."
                    - chat "I<&sq>d hardly call this newsworthy... but I'm at a low. I<&sq>ll take it."
                    - chat "You call this a story? Fine - whatever, I suppose we can run it. Thanks for the free press."
                    - chat "This is fairly interesting - not sure if it will catch enough attention, but maybe with some other stories."
                    - chat "We<&sq>ll give it a run - not my fault if it doesn<&sq>t bring in the revenue."
                    - chat "This was a pretty solid read - I<&sq>ll give you that. We<&sq>ll run it."
                    - chat "Straightforward, snappy, and to the point. We<&sq>ll run the story."
                    - chat "I<&sq>ll mull it over, but I think this is runnable. Check the paper this week. You may be happy with what you see."
            - else:
                - chat "I don<&sq>t know what you<&sq>re trying to shove at me, but I don<&sq>t appreciate it."
                - chat "Get out of here if you don<&sq>t have something constructive for me."
    interact scripts:
        - 1 JournalistInteract

JournalistInteract:
    type: interact
    steps:
        1:
            chat trigger:
                1:
                    trigger: /Regex:Hello/
                    script:
                        - random:
                            - chat "I<&sq>m busy here - what do you need?"
                            - chat "Hello to you too."
                            - chat "Yeah, can I help you?"
                            - chat "Yeah it's me, just old <npc.name>. What are you in for?"
                            - chat "Odd place to come visit - can I help you with something?"
                            - chat "What's the meaning of this?"