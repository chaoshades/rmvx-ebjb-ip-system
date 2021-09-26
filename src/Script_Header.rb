################################################################################
#                         IP System - EBJB_IPSystem                   #   VX   #
#                          Last Update: 2012/03/17                    ##########
#                         Creation Date: 2011/10/17                            #
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Contains custom scripts adding an IP System (like Lufia II) in your game.   #
#  - Based on the IP System script from Trickster for RPG Maker XP             #
#  - Able to have skills by class, actor or equipment                          #
#  - New menu command in battle to display the IP skills                       #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the IPSystem_Config class. For #
#  more info on what and how to adjust these settings, see the documentation   #
#  in the class.                                                               #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Alias: Game_Actor - hp=, setup, skill_can_use?                              #
#  Alias: Game_BattleAction - clear                                            #
#  Alias: Game_Battler - slip_damage_effect                                    #
#  Alias: Scene_Battle - update_actor_command_selection, prior_actor,          #
#                        update_target_enemy_selection,                        #
#                        update_target_actor_selection, execute_action,        #
#                        execute_action_attack, execute_action_guard,          #
#                        execute_action_escape, process_escape,                #
#                        execute_action_wait, execute_action_item              #
#  Alias: Window_Status - draw_basic_info                                      #
#  Alias: Window_ActorCommand - setup                                          #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_IPSystem"] = true

