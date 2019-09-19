AetheriaDiscordBot:
    type: command
    name: dDiscord
    description: no
    usage: /dDiscord
    script:
        - if <context.args.size> == 1:
            - if <context.args.get[1]> == connect:
                - yaml "load:Utilities/DiscordBot.yml" id:DiscordBot
                - ~discord id:mybot connect code:<yaml[DiscordBot].read[info.code]>
            - if <context.args.get[1]> == disconnect:
                - ~discord id:mybot disconnect
        - if <context.args.size> == 2:
            - if <context.args.get[1]> == message:
                - ~discord id:mybot message channel:<discord[mybot].group[Aetheria].channel[admin-chat]> "<context.args.get[2]>"
        

        # tag_parser_bot:
        #     type: world
        #     debug: false
        #     script_paths:
        #         stop_bot:
        #         - if <server.has_flag[tag_parser_bot_running]> {
        #           - discord id:tag_parser disconnect
        #           - flag server tag_parser_bot_running:!
        #           }
        #         start_bot:
        #         - inject locally script_paths.stop_bot
        #         - yaml load:data/tag_parser.yml id:tag_parser_temp
        #         - if !<yaml.list.contains_text[tag_parser_temp]> {
        #           - debug error "Load failed."
        #           - queue clear
        #           }
        #         - flag server tag_parser_logpath:<yaml[tag_parser_temp].read[bot.discord.log_path]>
        #         - flag server tag_parser_validchannels:!
        #         - flag server tag_parser_validchannels:|:<yaml[tag_parser_temp].read[bot.discord.valid_channels]>
        #         - flag server tag_parser_barredchannels:!
        #         - flag server tag_parser_barredchannels:|:<yaml[tag_parser_temp].read[bot.discord.barred_channels]>
        #         - flag server tag_parser_barredchannelmessages:!
        #         - flag server tag_parser_barredchannelmessages:|:<yaml[tag_parser_temp].read[bot.discord.barred_channel_messages]>
        #         - flag server tag_parser_link:<yaml[tag_parser_temp].read[script.link]>
        #         - define link <server.flag[tag_parser_link]>
        #         - define samples "li@link/<def[link].escaped>|sample_bool/true|sample_0/0|sample_1/1|sample_10/10|sample_0p5/0.5"
        #         - define samples "<def[samples]>|sample_text/Hello, world!|help/try typing 'help' to the bot!"
        #         - define samples "<def[samples]>|version/<server.version.escaped>|denizen_version/<server.denizen_version.escaped>"
        #         - flag server tag_parser_samples:!
        #         - flag server tag_parser_samples:|:<def[samples]>
        #         - discord id:tag_parser connect code:<yaml[tag_parser_temp].read[bot.discord.token]>
        #         - yaml unload id:tag_parser_temp
        #         - flag server tag_parser_bot_running
        #         process_tag:
        #         - log "<util.date.time> [<def[name]>] in [<def[origin]>] wants to process tag <def[tag]>" file:<server.flag[tag_parser_logpath]>
        #         - flag server tag_parser_result_temp:!
        #         - run locally script_paths.tag_run_path instantly def:<def[tag]>
        #         - define result <server.flag[tag_parser_result_temp]||FAILED=FLAG_MISSING;>
        #         - flag server tag_parser_result_temp:!
        #         - log "<util.date.time> [<def[name]>] in [<def[origin]>] got result <def[result]>" file:<server.flag[tag_parser_logpath]>
        #         crunch_result:
        #         - define final_result ""
        #         - foreach <def[result].split[;]> {
        #           - if <def[value].starts_with[VALID=]> {
        #             - define final_result "<def[final_result]><def[value].after[VALID=].replace[&sc].with[;]><n>"
        #             }
        #           }
        #         - foreach <def[result].split[;]> {
        #           - if <def[value].starts_with[FAILED=ERROR/]> {
        #             - define final_result "<def[final_result]>Had error: <def[value].after[FAILED=ERROR/].replace[&sc].with[;]><n>"
        #             }
        #             else if <def[value].starts_with[FAILED=EXCEPTION/]> {
        #             - define final_result "<def[final_result]>Had internal exception: <def[value].after[FAILED=EXCEPTION/].replace[&sc].with[;]><n>"
        #             }
        #             else if <def[value].starts_with[FAILED=]> {
        #             - define fail_reason <def[value].after[FAILED=]>
        #             - if <def[fail_reason]> == FLAG_MISSING {
        #               - define final_result "<def[final_result]>Got no result value.<n>"
        #               }
        #               else {
        #               - define final_result "<def[final_result]>Got failure '<def[fail_reason]>'.<n>"
        #               }
        #             }
        #           }
        #         - if <def[final_result].trim.length> == 0 {
        #           - define final_result ""
        #           }
        #         - if <def[final_result].length> > 1000 || <def[tag].length.add[<def[final_result].length>]> > 1500 {
        #           - define tag "(Spam)"
        #           - define final_result "Input too long, refused."
        #           }
        #         - if <def[final_result].to_list.filter[is[==].to[<n>]].size> > 10 {
        #           - define final_result "Newline spam, refused."
        #           }
        #         tag_run_path:
        #         - define samples <server.flag[tag_parser_samples].as_list>|sample_player/<player>|sample_npc/<npc>
        #         - foreach <def[samples]> {
        #           - define <def[value].before[/]> <def[value].after[/].unescaped>
        #           }
        #         - define help "Tell me any valid Denizen (Bukkit) tags, like <&lt>player.name<&gt> and I'll parse them for you! Alternately, tell me a valid definition name (like 'samples') and I'll tell you its contents."
        #         - if !<def[1].unescaped.contains[<&lt>]> && <def[<def[1].unescaped>].exists> {
        #           - flag server tag_parser_result_temp:VALID=<def[<def[1].unescaped>].escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>
        #           }
        #           else {
        #           - flag server tag_parser_result_temp:VALID=<parse.escaped.replace[;].with[&sc]:<def[1].unescaped>>;<server.flag[tag_parser_result_temp]||>
        #           }
        #     events:
        #         on server start:
        #         - wait 5s
        #         - flag server tag_parser_bot_running:!
        #         - inject locally script_paths.start_bot
        #         on script generates error:
        #         - flag server tag_parser_result_temp:FAILED=ERROR/<context.message.escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>
        #         on script generates exception:
        #         - flag server tag_parser_result_temp:FAILED=EXCEPTION/<context.type.escaped.replace[;].with[&sc]>-<context.message.escaped.replace[;].with[&sc]>;<server.flag[tag_parser_result_temp]||>
        #         on discord message received by tag_parser:
        #         - flag server tag_parser_bot_running
        #         - if <yaml.list.contains_text[tag_parser_temp]> {
        #           - yaml unload id:tag_parser_temp
        #           }
        #         - define name <context.author_id>/<context.author_name.escaped>
        #         - define origin <context.group>/<context.channel>/<context.group_name.escaped>/<context.channel_name.escaped>
        #         - announce to_console "Discord chatter! [<def[name]>] in [<def[origin]>] saying <context.message>"
        #         - if !<context.mentions.contains[<context.self>]> {
        #           #- if ( "<context.message.trim.starts_with[!p ]>" || "<context.message.trim.starts_with[!parse]>" ) && <server.flag[tag_parser_validchannels].as_list.contains[<context.channel>]> {
        #           #  - discord id:tag_parser message channel:<context.channel> "Parse request received! Please wait up to 24 hours for <&lt>@151839791179235328<&gt> to type the tag into his server's CLI and report back the results."
        #           #  }
        #           - queue clear
        #           }
        #         - if !<server.flag[tag_parser_validchannels].as_list.contains[<context.channel>]> {
        #           - define found <server.flag[tag_parser_barredchannels].as_list.find[<context.channel>]>
        #           - if <def[found]> > 0 {
        #             - discord id:tag_parser message channel:<context.channel> "Cannot parse that in this channel! <server.flag[tag_parser_barredchannelmessages].as_list.get[<def[found]>]>"
        #             }
        #           - queue clear
        #           }
        #         - define tag <context.no_mention_message.replace[<n>].with[<&sp>].trim.escaped>
        #         - inject locally script_paths.process_tag player:<server.list_players.get[1]> npc:<server.list_npcs.get[1]>
        #         - inject locally script_paths.crunch_result
        #         - discord id:tag_parser message channel:<context.channel> "Tag parse results for `<def[tag].unescaped.replace[`].with[']>`<&co><n>```<n><def[final_result].unescaped.replace[`].with[']>```"
        
        
        