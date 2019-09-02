TBCController:
  type: world
  events:
    on player right clicks with locationtool:
    - narrate "pos2 selected"
    - flag player pos2:<c.location>
    - narrate "schematic create name:YOURNAMEHERE cu@<player.flag[pos1]>|<player.flag[pos2]> <player.location>"
    - narrate "schematic save name:test"
    - narrate "schematic load name:test"
    - determine cancelled
    on player left clicks with locationtool:
    - narrate "pos1 selected"
    - flag player pos1:<c.location>
    - determine cancelled
    on player drops locationtool:
    - schematic create name:test cu@<player.flag[pos1]>|<player.flag[pos2]> <player.location>
    - schematic save name:test
    - schematic load name:test

SchematicCommand:
  type: command
  name: dSchem
  description: Saves Denizen Schematics for usage.
  usage: /dSchem <&lt>schem_name<&gt>
  script:
    - if !<player.is_op||<context.server>>:
      - narrate "<red>"You do not have permission for that command."
      - stop
    - define rawArgs:<context.args>
    - if <[rawArgs].size> != 2:
      - narrate "Error in syntax: use /dschem save||load schematicName"
      - stop
    - define firstArg:<[rawArgs].get[1]>
    - define secondArg:<[rawArgs].get[2]>
    - narrate "First Arg: <[firstArg]>"
    - narrate "Second Arg: <[secondArg]>"
    - if <[firstArg]> == "save":
      - schematic create name:<[secondArg]> cu@<player.flag[pos1]>|<player.flag[pos2]> <player.location.cursor_on>
      - schematic load name:<[secondArg]>
      - schematic save name:<[secondArg]>
      - narrate "Schematic saved as <[secondArg]>."
      - stop
    - else if <[firstArg]> == "load":
      - define schemName: <context.raw_args[1]>
      - schematic load name:<[secondArg]>
      - schematic paste name:<[secondArg]> <player.location.cursor_on.relative[0,2,0]> noair
      - narrate "Schematic <[secondArg]> pasted!"
      - stop
    - else:
      - narrate "Error in syntax: use /dschem save|load schematicName"
SchematicController:
  type: world
  events:
    on player right clicks with schematic:
    - create player "TestDummy" <player.location> save:temp
    - adjust <entry[temp].created_npc> lookclose:TRUE
    - adjust <entry[temp].created_npc> set_sneaking:TRUE
    - adjust <entry[temp].created_npc> invulnerable:TRUE
    - adjust <entry[temp].created_npc> skin:HeroicKnight -p
    - adjust <entry[temp].created_npc> set_assignment:TestAssignment
    #- execute as_server "npc lookclose"
    #- execute as_server "npc skin HeroicKnight -p"
    #- execute as_server "npc vulnerable"
    #- execute as_server "npc deselect"
    on player left clicks with schematic:
    - schematic rotate name:test angle:90
    - narrate "schematic rotated 90 degrees"

# Items
locationtool:
  type: item
  material: m@diamond_axe
  display name: selector

schematic:
  type: item
  material: i@paper
  display name: schematic

testschematic:
  type: item
  material: i@paper
  display name: NPC Schematic


TestAssignment:
  type: assignment
  interact scripts:
    - 1 TestInteract
TestInteract:
  type: interact
  steps:
    1:
      chat trigger:
        1:
          trigger: "Hello"
          script:
            - chat "Hello stranger."

        # Loop through the blocklist, show fake for each
        #- showfake <schematic[TestBench].block[<location>]>
