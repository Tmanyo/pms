chat_error = {"Welcome!"}
chat1 = {}
chat2 = {}
chat3 = {}
name1 = {}
name2 = {}
name3 = {}
player_chat = 0
message_sent = {}
sender = {}

minetest.register_on_joinplayer(function(player)
     a[player:get_player_name()] = 0
     chat_error[player:get_player_name()] = {"Welcome"}
     chat1[player:get_player_name()] = {}
     chat2[player:get_player_name()] = {}
     chat3[player:get_player_name()] = {}
     name1[player:get_player_name()] = {}
     name2[player:get_player_name()] = {}
     name3[player:get_player_name()] = {}
end)

function refine_message(tbl, player)
     player_message = 0
     local very_last = {}
     local secondary = {}
     local finished_message = {}
     local last_message = {}
     local sub_message = {}
     local s = minetest.serialize(tbl)
     local message = s:gsub("return", ""):gsub("{", ""):gsub("}", ""):gsub("\"", "")
     if player_chat == 1 then
          finished_message = message
          player_chat = 0
     else
          if tbl == chat_error[player:get_player_name()] then
               finished_message = message
          else
               if not message:match("%w+") then
                    table.insert(tbl, "-!- Conversation Started!")
                    finished_message = message
     --[[if message:find(",") == nil then
          if string.len(message) > 160 then
               local middle = message:sub(72, 84)
               local second_line = message:sub(1, 71) .. middle:gsub(" ", ",", 1) .. message:sub(85, 151)
               local second_middle = message:sub(155, 165)
               finished_message = "<" .. player:get_player_name() .. "> " .. message:sub(1, 71) .. middle:gsub(" ", ",", 1) .. message:sub(85, 154) ..
                    second_middle:gsub(" ", ",", 1) .. message:sub(166, string.len(message))
               table.remove(tbl, 1)
               table.insert(tbl, finished_message)
          elseif string.len(message) < 160 then
               if string.len(message) > 84 then
                    local middle = message:sub(72, 84)
                    finished_message = "<" .. player:get_player_name() .. "> " .. message:sub(1, 71) .. middle:gsub(" ", ",", 1) .. message:sub(85, string.len(message))
                    table.remove(tbl, 1)
                    table.insert(tbl, finished_message)
               else
                    finished_message = "<" .. player:get_player_name() .. "> " .. message
                    table.remove(tbl, 1)
                    table.insert(tbl, finished_message)
               end
          end]]
               elseif message:match("%w+") then
                    local message_reverse = message:reverse()
                    local message_get_last = message_reverse:find(",")
                    if message_get_last ~= nil then
                         last_message = message:len() - message_get_last
                    else
                         last_message = 0
                    end
                    local text_old = message:sub(1, (last_message + 1))
                    local very_last = message:sub((last_message + 2), message:len())
                    if string.match(very_last, "-!-") then
                         sub_message = very_last
                    else
                         player_message = 1
                         sub_message = "<"  .. player:get_player_name() .. "> " .. very_last
                    end
                    if string.len(sub_message) > 160 then
                         local middle = sub_message:sub(72, 84)
                         local second_line = sub_message:sub(1, 71) .. middle:gsub(" ", ",", 1) .. sub_message:sub(85, 151)
                         local second_middle = sub_message:sub(155, 165)
                         finished_message = text_old .. sub_message:sub(1, 71) .. middle:gsub(" ", ",", 1) .. sub_message:sub(85, 154) ..
                              second_middle:gsub(" ", ",", 1) .. sub_message:sub(166, string.len(message))
                         secondary = sub_message:sub(1, 71) .. middle:gsub(" ", ",", 1) .. sub_message:sub(85, 154) ..
                              second_middle:gsub(" ", ",", 1) .. sub_message:sub(166, string.len(message))
                         table.remove(tbl)
                         table.insert(tbl, secondary)
                    elseif string.len(sub_message) < 160 then
                         if string.len(sub_message) > 84 then
                              local edited_message = sub_message:sub(72, 84)
                              finished_message = text_old .. sub_message:sub(1, 71) .. edited_message:gsub(" ", ",", 1) .. sub_message:sub(85, string.len(sub_message))
                              secondary = sub_message:sub(1, 71) .. edited_message:gsub(" ", ",", 1) .. sub_message:sub(85, string.len(sub_message))
                              table.remove(tbl)
                              table.insert(tbl, secondary)
                         else
                              if player_message == 1 then
                                   if not string.match(sub_message, "<" .. player:get_player_name() .. "> ..") then
                                        table.remove(tbl)
                                        player_message = 0
                                        finished_message = text_old
                                   else
                                        finished_message = text_old .. sub_message
                                        secondary = sub_message
                                        table.remove(tbl)
                                        table.insert(tbl, secondary)
                                   end
                              else
                                   if sub_message == nil then
                                        table.remove(tbl)
                                        finished_message = text_old
                                   else
                                        finished_message = text_old .. sub_message
                                        secondary = sub_message
                                        table.remove(tbl)
                                        table.insert(tbl, secondary)
                                   end
                              end
                         end
                    end
               else
                    finished_message = text_old
               end
          end
     end
     return finished_message
end

function pm_form(name)
     local player = minetest.get_player_by_name(name)
     minetest.show_formspec(name, "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "textarea[2.5,1.25;3.5,2;chat_box0;;]" ..
          "textlist[0,4;6,5;chat;" .. refine_message(chat_error[player:get_player_name()], player) .. "]")
end

minetest.register_chatcommand("pm", {
     description = "Send private messages to players.",
     func = function(name, param)
          pm_form(name)
     end
})

function player1(player)
     minetest.show_formspec(player:get_player_name(), "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "button[.25,1;2,1;player1;" .. name1[player:get_player_name()] .. "]" ..
          "textarea[2.5,1.25;3.5,2;chat_box1;;]" ..
          "button[4,3;2,1;send1;Send]" ..
          "textlist[0,4;6,5;chat1;" .. refine_message(chat1[player:get_player_name()], player) .. "]")
end

function player11(player)
     minetest.show_formspec(player:get_player_name(), "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "button[.25,1;2,1;player1;" .. name1[player:get_player_name()] .. "]" ..
          "button[.25,2;2,1;player2;" .. name2[player:get_player_name()] .. "]" ..
          "textarea[2.5,1.25;3.5,2;chat_box1;;]" ..
          "button[4,3;2,1;send1;Send]" ..
          "textlist[0,4;6,5;chat1;" .. refine_message(chat1[player:get_player_name()], player) .. "]")
end

function player111(player)
     minetest.show_formspec(player:get_player_name(), "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "button[.25,1;2,1;player1;" .. name1[player:get_player_name()] .. "]" ..
          "button[.25,2;2,1;player2;" .. name2[player:get_player_name()] .. "]" ..
          "button[.25,3;2,1;player3;" .. name3[player:get_player_name()].."]" ..
          "textarea[2.5,1.25;3.5,2;chat_box1;;]" ..
          "button[4,3;2,1;send1;Send]" ..
          "textlist[0,4;6,5;chat1;" .. refine_message(chat1[player:get_player_name()], player) .. "]")
end

function player2(player)
     minetest.show_formspec(player:get_player_name(), "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "button[.25,1;2,1;player1;" .. name1[player:get_player_name()] .. "]" ..
          "button[.25,2;2,1;player2;" .. name2[player:get_player_name()] .. "]" ..
          "textarea[2.5,1.25;3.5,2;chat_box2;;]" ..
          "button[4,3;2,1;send2;Send]" ..
          "textlist[0,4;6,5;chat2;" .. refine_message(chat2[player:get_player_name()], player) .. "]")
end

function player22(player)
     minetest.show_formspec(player:get_player_name(), "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "button[.25,1;2,1;player1;" .. name1[player:get_player_name()] .. "]" ..
          "button[.25,2;2,1;player2;" .. name2[player:get_player_name()] .. "]" ..
          "button[.25,3;2,1;player3;" .. name3[player:get_player_name()] .."]" ..
          "textarea[2.5,1.25;3.5,2;chat_box2;;]" ..
          "button[4,3;2,1;send2;Send]" ..
          "textlist[0,4;6,5;chat2;" .. refine_message(chat2[player:get_player_name()], player) .. "]")
end

function player3(player)
     minetest.show_formspec(player:get_player_name(), "pms:pm",
          "size[6,9]" ..
          "field[.5,.5;4,1;player;Player:;]" ..
          "image_button[4.25,.25;.75,.75;add.png;add;;true;false;]" ..
          "button[.25,1;2,1;player1;" .. name1[player:get_player_name()] .. "]" ..
          "button[.25,2;2,1;player2;" .. name2[player:get_player_name()] .. "]" ..
          "button[.25,3;2,1;player3;" .. name3[player:get_player_name()] .."]" ..
          "textarea[2.5,1.25;3.5,2;chat_box3;;]" ..
          "button[4,3;2,1;send3;Send]" ..
          "textlist[0,4;6,5;chat3;" .. refine_message(chat3[player:get_player_name()], player) .. "]")
end

player_yes = {}
player_list = {}
minetest.register_on_player_receive_fields(function(player, formname, fields)
     if formname == "pms:pm" then
          if fields.add then
               a[player:get_player_name()] = a[player:get_player_name()] + 1
               if fields.player ~= "" then
                    player_list = minetest.get_dir_list(minetest.get_worldpath() .. "/players", false)
                    local s = minetest.serialize(player_list)
                    if s:match(fields.player) then
                         player_yes = 1
                    end
                    if a[player:get_player_name()] == 1 then
                         if player_yes == 1 then
                              name1[player:get_player_name()] = fields.player
                              minetest.chat_send_player(fields.player, player:get_player_name() .. " has started a private conversation.  Would you like to view?")
                              message_sent = 1
                         else
                              a[player:get_player_name()] = 0
                         end
                    elseif a[player:get_player_name()] == 2 then
                         if player_yes == 1 then
                              name2[player:get_player_name()] = fields.player
                              minetest.chat_send_player(fields.player, player:get_player_name() .. " has started a private conversation.  Would you like to view?")
                              message_sent = 1
                         else
                              a[player:get_player_name()] = 1
                         end
                    elseif a[player:get_player_name()] == 3 then
                         if player_yes == 1 then
                              name3[player:get_player_name()] = fields.player
                              minetest.chat_send_player(fields.player, player:get_player_name() .. " has started a private conversation.  Would you like to view?")
                              message_sent = 1
                         else
                              a[player:get_player_name()] = 2
                         end
                    end
                    if player_yes == 1 then
                         if a[player:get_player_name()] == 1 then
                              if name1[player:get_player_name()] ~= nil then
                                   player1(player)
                                   player_yes = 0
                              end
                         elseif a[player:get_player_name()] == 2 then
                              if name1[player:get_player_name()] == nil then
                                   player1(player)
                                   player_yes = 0
                              else
                                   if name2[player:get_player_name()] ~= nil then
                                        player2(player)
                                        player_yes = 0
                                   end
                              end
                         elseif a[player:get_player_name()] == 3 then
                              if name1[player:get_player_name()] == nil then
                                   player1(player)
                                   player_yes = 0
                              elseif name2[player:get_player_name()] == nil then
                                   player2(player)
                                   player_yes = 0
                              else
                                   if name3[player:get_player_name()] ~= nil then
                                        player3(player)
                                        player_yes = 0
                                   end
                              end
                         elseif a[player:get_player_name()] > 3 then
                              table.insert(chat3[player:get_player_name()], "-!- You are chatting with the maximum amount of players.")
                              player3(player)
                         end
                    else
                         if a[player:get_player_name()] == 1 then
                              table.insert(chat1[player:get_player_name()], "-!- No such player exists.")
                              player1(player)
                         elseif a[player:get_player_name()] == 2 then
                              table.insert(chat2[player:get_player_name()], "-!- No such player exists.")
                              player2(player)
                         elseif a[player:get_player_name()] == 3 then
                              table.insert(chat3[player:get_player_name()], "-!- No such player exists.")
                              player3(player)
                         elseif a[player:get_player_name()] > 3 then
                              table.insert(chat3[player:get_player_name()], "-!- No such player exists.")
                              player3(player)
                         else
                              table.insert(chat_error[player:get_player_name()], "-!- No such player exists.")
                              local name = player:get_player_name()
                              pm_form(name)
                         end
                    end
               else
                    if a[player:get_player_name()] == 1 then
                         table.insert(chat1[player:get_player_name()], "-!- No player name entered.")
                         player1(player)
                         a = 0
                    elseif a[player:get_player_name()] == 2 then
                         table.insert(chat1[player:get_player_name()], "-!- No player name entered.")
                         player1(player)
                         a = 1
                    elseif a[player:get_player_name()] == 3 then
                         table.insert(chat2[player:get_player_name()], "-!- No player name entered.")
                         player2(player)
                         a = 2
                    elseif a[player:get_player_name()] > 3 then
                         table.insert(chat3[player:get_player_name()], "-!- No player name entered.")
                         player3(player)
                    else
                         table.insert(chat_error[player:get_player_name()], "-!- No player name entered.")
                         local name = player:get_player_name()
                         pm_form(name)
                    end
               end
          end
          if fields.player1 then
               player_chat = 1
               if a[player:get_player_name()] == 1 then
                    player1(player)
               elseif a[player:get_player_name()] == 2 then
                    player11(player)
               elseif a[player:get_player_name()] == 3 then
                    player111(player)
               else
                    player111(player)
               end
          end
          if fields.player2 then
               player_chat = 1
               if a[player:get_player_name()] == 2 then
                    player2(player)
               elseif a[player:get_player_name()] == 3 then
                    player22(player)
               else
                    player22(player)
               end
          end
          if fields.player3 then
               player_chat = 1
               player3(player)
          end
          if fields.send1 then
               if fields.chat_box1 ~= nil then
                    table.insert(chat1[player:get_player_name()], fields.chat_box1)
                    if name1[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat1[name1[player:get_player_name()]], fields.chat_box1)
                    elseif name2[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat2[name2[player:get_player_name()]], fields.chat_box1)
                    elseif name3[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat3[name3[player:get_player_name()]], fields.chat_box1)
                    end
                    if a[player:get_player_name()] == 1 then
                         player1(player)
                    elseif a[player:get_player_name()] == 2 then
                         player11(player)
                    elseif a[player:get_player_name()] == 3 then
                         player111(player)
                    end
               else
                    return false
               end
          end
          if fields.send2 then
               if fields.chat_box2 ~= nil then
                    table.insert(chat2[player:get_player_name()], fields.chat_box2)
                    if name1[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat1[name1[player:get_player_name()]], fields.chat_box2)
                    elseif name2[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat2[name2[player:get_player_name()]], fields.chat_box2)
                    elseif name3[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat3[name3[player:get_player_name()]], fields.chat_box2)
                    end
                    if a[player:get_player_name()] == 2 then
                         player2(player)
                    else
                         player22(player)
                    end
               else
                    return false
               end
          end
          if fields.send3 then
               if fields.chat_box3 ~= nil then
                    table.insert(chat3[player:get_player_name()], fields.chat_box3)
                    if name1[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat1[name1[player:get_player_name()]], fields.chat_box3)
                    elseif name2[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat2[name2[player:get_player_name()]], fields.chat_box3)
                    elseif name3[name1[player:get_player_name()]] == player:get_player_name() then
                         table.insert(chat3[name3[player:get_player_name()]], fields.chat_box3)
                    end
                    player3(player)
               else
                    return false
               end
          end
     end
end)

--[[minetest.register_on_chat_message(function(name, message)
     local player = minetest.get_player_by_name(name)
     if message_sent == 1 then
          if message == "Yes" or "yes" or "Y" or "y" then
               if a == 0 then
                    playernames.name1[player:get_player_name()] = sender
                    player1(player)
                    a = 1
               --[[elseif a == 1 then
                    player2(player)
                    a = 2
               elseif a == 2 then
                    player2(player)
                    a = 3
               end
          elseif message == "No" or "no" or "N" or "n" then
               minetest.chat_send_player(name, "Okay.")
          end
     end
end)]]
