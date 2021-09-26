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


#==============================================================================
# ** IPSYSTEM_CONFIG
#------------------------------------------------------------------------------
#  Contains the IPSystem configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** IPSkill
  #------------------------------------------------------------------------------
  #  Represents a IP skill (for weapons and armors)
  #==============================================================================

  class IPSkill
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Skill ID
    attr_reader :id
    # Cost (in percentage) of the IP skill
    attr_reader :cost
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : skill id
    #     cost : cost (in percentage) of the IP skill
    #--------------------------------------------------------------------------
    def initialize(id, cost)
      @id = id
      @cost = cost
    end
    
  end
  
  module IPSYSTEM_CONFIG
    
    #------------------------------------------------------------------------
    # Generic patterns
    #------------------------------------------------------------------------
    
    # Percentage pattern
    PERCENTAGE_PATTERN = "%d%" 
    
    #------------------------------------------------------------------------
    # Various options
    #------------------------------------------------------------------------
    
    # Freeze MP 
    #True = Do NOT lose MP when using an IP skill  False = reverse
    FREEZE_MP = true
    
    # Unique ids used to represent Death Effect
    LOSE_ALL_IP = 0
    LOSE_HALF_IP = 1
    LOSE_NONE = 2
    
    # Death Effect
    DEATH_EFFECT = LOSE_ALL_IP
    
    # Friendly Mode
    #True: IP will rise when attacked by an ally   False: reverse
    FRIENDLY = false
    
    # Slip Effect Mode
    #True: IP will rise when damaged by slip effect   False: reverse
    SLIP_EFFECT = true
    
    # Hide the IP cost in the IP skills window
    #True : IP cost will be hidden  False = reverse
    HIDE_IP_COST = false
    
    #------------------------------------------------------------------------
    # IP Skills Definitions
    #------------------------------------------------------------------------
    
    # Weapon IP Skills definitions
    #  - syntax: weapon_id => [IPSkill(skill_id, cost%), ...]
    WEAPON_IP = {
      2 => [IPSkill.new(35,0), IPSkill.new(22,10)]
    }
    
    # Armor IP Skills definitions
    #   syntax: armor_id => [IPSkill(skill_id, cost%), ...]
    ARMOR_IP = {
      1 => [IPSkill.new(59,100)]
    }
    
    # Actor IP Skills definitions 
    #   syntax: actor_id => [IPSkill(skill_id, cost%), ...]
    ACTOR_IP = {
      1 => [IPSkill.new(34,17), IPSkill.new(54,12), IPSkill.new(24,13)]
    }
    
    # Class IP Skills definitions
    #   syntax: class_id => [IPSkill(skill_id, cost%), ...]
    CLASS_IP = {
      1 => [IPSkill.new(22,22), IPSkill.new(45,11), IPSkill.new(1,1)]
    }
       
    # Unique ids used to represent IP types
    # IP_TYPE = 10xx
    
    # IP Increases by the amount of HP damage dealt to actor
    IP_HP_DAMAGE = 1001
    # IP Increases by the amount of MP damage dealt to actor
    IP_MP_DAMAGE = 1002
    # IP Increases by the amount of HP damage dealt to target 
    IP_HP_ATTACKING = 1003
    # IP Increases by the amount of MP damage dealt to target 
    IP_MP_ATTACKING = 1004
    # IP Increases when pricier items are used
    IP_MONEY = 1005
    # IP Increases when using skills with higher mp_cost
    IP_MP_USER = 1006
    # IP Is Filled when having a status
    IP_STATUS = 1007
    # IP Is Filled when turns has passed
    IP_TURN = 1008
    # IP Is Filled when defending
    IP_DEFENSE = 1009
    # IP Is Filled when waiting
    IP_WAIT = 1010
    # IP Is Filled when escaped
    IP_ESCAPE = 1011
    # IP Increases by the amount of HP healing done to actor
    IP_HP_HEALING = 1012
    # IP Increases by the amount of MP healing done to actor
    IP_MP_HEALING = 1013
    # IP Is Filled when skills are used
    IP_USING_SKILLS = 1014
    # IP Is Filled when attacks are used
    IP_USING_ATTACKS = 1015
    # IP Is Filled when items are used
    IP_USING_ITEMS = 1016
    # IP Is Filled when acting first
    IP_FIRST = 1017
    # IP Is Filled when acting last
    IP_LAST = 1018
    # IP Is Filled when HP is taking damage
    IP_TAKING_HP_DAMAGE = 1019
    # IP Is Filled when MP is taking damage
    IP_TAKING_MP_DAMAGE = 1020
    # IP Is Filled when missed
    IP_BLIND = 1021
    # IP Is Filled when dodged
    IP_EVADE = 1022
    # IP Is Filled when critical hit on target
    IP_LUCKY = 1023
    # IP Is Filled when actor is hit by critical hit
    IP_UNLUCKY = 1024
    
    # Actor IP Types definitions
    #   syntax: actor_id => {'type' => rate}
    #   Where 'type' is one of the IP modes above
    IP_TYPES_ACTOR = {
      1 => {},
      #1 => {IP_HP_DAMAGE => 100, IP_MP_DAMAGE => 100, IP_TURN => 100, 
      #      IP_USING_ITEMS => 100, IP_TAKING_HP_DAMAGE => 100, IP_TAKING_MP_DAMAGE => 100},
      2 => {IP_HP_ATTACKING => 100, IP_MP_ATTACKING => 100, IP_DEFENSE => 100, 
            IP_USING_ATTACKS => 100, IP_FIRST => 100, IP_EVADE => 100, IP_LUCKY => 100},
      3 => {IP_MONEY => 100, IP_MP_USER => 100, IP_WAIT => 100, IP_HP_HEALING => 100,
            IP_MP_HEALING => 100, IP_BLIND => 100},
      4 => {IP_STATUS => 100, IP_ESCAPE => 100, IP_USING_SKILLS => 100, IP_LAST => 100,
            IP_UNLUCKY => 100}
    }

    # Class IP Types definitions
    #   syntax: class_id => {'type' => rate}
    #   Where 'type' is one of the IP modes above
    IP_TYPES_CLASS = {
      11 => {IP_HP_DAMAGE => 25},
      12 => {IP_MP_DAMAGE => 25},
      13 => {IP_HP_ATTACKING => 25},
      14 => {IP_MP_ATTACKING => 25},
      15 => {IP_MONEY => 25},
      16 => {IP_MP_USER => 25},
      17 => {IP_STATUS => 25},
      18 => {IP_TURN => 25},
      19 => {IP_DEFENSE => 25},
      20 => {IP_WAIT => 25},
      21 => {IP_ESCAPE => 25},
      22 => {IP_HP_HEALING => 25},
      23 => {IP_MP_HEALING => 25},
      24 => {IP_USING_SKILLS => 25},
      25 => {IP_USING_ATTACKS => 25},
      26 => {IP_USING_ITEMS => 25},
      27 => {IP_FIRST => 25},
      28 => {IP_LAST => 25},
      29 => {IP_TAKING_HP_DAMAGE => 25},
      30 => {IP_TAKING_MP_DAMAGE => 25},
      31 => {IP_BLIND => 25},
      32 => {IP_EVADE => 25},
      33 => {IP_LUCKY => 25},
      34 => {IP_UNLUCKY => 25}
    }
    
    #------------------------------------------------------------------------
    # Defaults Setup
    #   ***Do not Touch Unless you know what you are doing***
    #------------------------------------------------------------------------
    IP_TYPES_ACTOR.default = {IP_HP_DAMAGE => 100}
    IP_TYPES_CLASS.default = {IP_HP_DAMAGE => 100}
    WEAPON_IP.default = [nil]
    ARMOR_IP.default = [nil]
    
  end
end

#===============================================================================
# ** RPG::Weapon Addon
#------------------------------------------------------------------------------
#  Addon function for IP skills
#===============================================================================

class RPG::Weapon
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Ip Skill and Cost
  #--------------------------------------------------------------------------
  def ip_skills
    return IPSYSTEM_CONFIG::WEAPON_IP[self.id]
  end

end

#===============================================================================
# ** RPG::Armor Addon
#------------------------------------------------------------------------------
#  Addon function for IP skills 
#===============================================================================

class RPG::Armor
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Ip Skill and Cost
  #--------------------------------------------------------------------------
  def ip_skills
    return IPSYSTEM_CONFIG::ARMOR_IP[self.id]
  end

end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB

  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # The actor's ip
  attr_reader :ip
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Actor's Ip
  #--------------------------------------------------------------------------
  # SET
  def ip=(ip)
    @ip = [[ip, 100].min, 0].max
  end
  
  #--------------------------------------------------------------------------
  # * Set Actor's Hp
  #--------------------------------------------------------------------------
  # SET
  alias trick_ip_actor_hp= hp= unless $@
  def hp=(hp)
    # The Usual
    self.trick_ip_actor_hp=(hp)
    # Skip if not dead
    return if not self.dead?
    # Branch By Death Effect
    case IPSYSTEM_CONFIG::DEATH_EFFECT
    when IPSYSTEM_CONFIG::LOSE_ALL_IP # Reset
      @ip = 0
    when IPSYSTEM_CONFIG::LOSE_HALF_IP # Half
      @ip = @ip / 2
    when IPSYSTEM_CONFIG::LOSE_NONE # None
      
    end
  end
  
  #--------------------------------------------------------------------------
  # * Get Actor's Ip Growth Rate
  #    type : IP type to get the growth rate
  #--------------------------------------------------------------------------
  # GET
  def ip_rate(type)
    # Get Ip Rates 
    actor_ip = IPSYSTEM_CONFIG::IP_TYPES_ACTOR[@actor_id][type]
    class_ip = IPSYSTEM_CONFIG::IP_TYPES_CLASS[@class_id][type]
    # Get Ip Amount
    ip_amount = [actor_ip, class_ip]
    # Remove 0 & nil
    ip_amount.delete(0)
    ip_amount.delete(nil)
    # Return Average
    sum = 0
    ip_amount.each { |n| sum+=n }
    return (sum / ip_amount.size) / 100.0
  end
  
  #--------------------------------------------------------------------------
  # * Get Actor's Ip Type
  #--------------------------------------------------------------------------
  # GET
  def ip_type
    # Get Actor and Class Types
    actor_type = IPSYSTEM_CONFIG::IP_TYPES_ACTOR[@actor_id]
    class_type = IPSYSTEM_CONFIG::IP_TYPES_CLASS[@class_id]
    # Return An Array with both
    return [actor_type, class_type]
  end
  
  #--------------------------------------------------------------------------
  # * Get Actor's Ip Skills and Class Ip Skills
  #--------------------------------------------------------------------------
  # GET
  def ip_skills
    return [IPSYSTEM_CONFIG::ACTOR_IP[@actor_id], IPSYSTEM_CONFIG::CLASS_IP[@class_id]]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  alias trick_ip_actor_setup setup unless $@
  def setup(actor_id)
    # The Usual
    trick_ip_actor_setup(actor_id)
    # Setup Instance Variables
    @ip = 0
  end
  
  #--------------------------------------------------------------------------
  # * Can Use Skill?
  #-------------------------------------------------------------------------- 
  alias trick_ip_actor_skill_can_use? skill_can_use? unless $@
  def skill_can_use?(skill_id)
    # If Ip Flag
    if self.action.ip
      # Can Use Skill
      return true
    else
      # The Usual
      return trick_ip_actor_skill_can_use?(skill_id)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Check if Have Ip Type
  #--------------------------------------------------------------------------
  def has_ip_type?(type)
    return ip_type[0].include?(type) || ip_type[1].include?(type)
  end
  
  #--------------------------------------------------------------------------
  # * Can Use IP Skill?
  #--------------------------------------------------------------------------
  def ip_skill_can_use?(skill)
    return false if self.ip < skill.cost
    return false if !IPSYSTEM_CONFIG::FREEZE_MP && self.mp < self.calc_mp_cost(skill)
    return true
  end
  
end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////

  # IP flag to be able to determine if this is an IP Skill or a normal skill
  attr_accessor :ip
  # IPSkill object when using an IP Skill
  attr_reader :ip_skill
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Wait Determination
  #--------------------------------------------------------------------------
  def wait?
    return (@kind == 0 and @basic == 3)
  end
  
  #--------------------------------------------------------------------------
  # * Escape Determination
  #--------------------------------------------------------------------------
  def escape?
    return (@kind == 0 and @basic == 2)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  alias trick_ip_battleaction_clear clear unless $@
  def clear
    # The Usual
    trick_ip_battleaction_clear
    # Clear Ip flag and IP skill
    @ip = false
    @ip_skill = nil
  end
  
  #--------------------------------------------------------------------------
  # * Set Escape
  #--------------------------------------------------------------------------
  def set_escape
    @kind = 0
    @basic = 2
  end
  
  #--------------------------------------------------------------------------
  # * Set Wait
  #--------------------------------------------------------------------------
  def set_wait
    @kind = 0
    @basic = 3
  end
  
  #--------------------------------------------------------------------------
  # * Set IP Skill
  #     ip_skill : IPSkill object
  #--------------------------------------------------------------------------
  def set_ip_skill(ip_skill)
    @kind = 1
    @skill_id = ip_skill.id
    @ip = true
    @ip_skill = ip_skill
  end
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Apply IP Effects
  #     types  : IP types to apply
  #     battler : Active battler (attacker, skill user, item user, etc.)
  #--------------------------------------------------------------------------
  def ip_effect(types, battler=self)
    
    for type in types
      if type != nil
        calc_ip(type, battler, self)
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Alias slip_damage_effect
  #--------------------------------------------------------------------------
  alias slip_damage_effect_ebjb slip_damage_effect unless $@
  def slip_damage_effect
    slip_damage_effect_ebjb()
    self.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                    IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                    IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                    IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Calculation of IP
  #     type : IP type
  #     battler : Active battler (attacker, skill user, item user, etc.)
  #     target : Active target
  #--------------------------------------------------------------------------
  def calc_ip(type, battler, target)
    
    # If an actor and has the ip type
    if target.actor? && target.has_ip_type?(type)
      # Get Ip Rate
      rate = target.ip_rate(type)
      b_actor = battler.is_a?(Game_Actor)
      
      case type
        when IPSYSTEM_CONFIG::IP_HP_DAMAGE
          # If Slip Effect option and slip_damage or
          # Friendly Attack option on and actor or an enemy or 
          if (IPSYSTEM_CONFIG::SLIP_EFFECT and target.slip_damage?) or
             (IPSYSTEM_CONFIG::FRIENDLY and b_actor) or !b_actor
            # If Target is being damaged
            if target.hp_damage > 0
              # Increase Ip
              target.ip += (target.hp_damage * 100.0 / target.maxhp * rate).round
            end
          end
          
        when IPSYSTEM_CONFIG::IP_MP_DAMAGE
          # If Slip Effect option and slip_damage or
          # Friendly Attack option on and actor or an enemy or 
          if (IPSYSTEM_CONFIG::SLIP_EFFECT and target.slip_damage?) or
             (IPSYSTEM_CONFIG::FRIENDLY and b_actor) or !b_actor
            # If Target is being damaged
            if target.mp_damage > 0
              # Increase Ip
              target.ip += (target.mp_damage * 100.0 / target.maxmp * rate).round
            end
          end
        
        when IPSYSTEM_CONFIG::IP_HP_HEALING
          # If Target is being healed
          if target.hp_damage < 0
            # Increase Ip
            target.ip += (-target.hp_damage * 100.0 / target.maxhp * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_MP_HEALING
          # If Target is being healed
          if target.mp_damage < 0
            # Increase Ip
            target.ip += (-target.mp_damage * 100.0 / target.maxmp * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE
          # If Slip Effect option and slip_damage or
          # Friendly Attack option on and actor or an enemy or 
          if (IPSYSTEM_CONFIG::SLIP_EFFECT and target.slip_damage?) or
             (IPSYSTEM_CONFIG::FRIENDLY and b_actor) or !b_actor
            # If Target is being damaged
            if target.hp_damage > 0
              # Increase Ip
              target.ip += (100.0 * rate).round
            end
          end
          
        when IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE
          # If Slip Effect option and slip_damage or
          # Friendly Attack option on and actor or an enemy or 
          if (IPSYSTEM_CONFIG::SLIP_EFFECT and target.slip_damage?) or
             (IPSYSTEM_CONFIG::FRIENDLY and b_actor) or !b_actor
            # If Target is being damaged
            if target.mp_damage > 0
              # Increase Ip
              target.ip += (100.0 * rate).round
            end
          end
          
        when IPSYSTEM_CONFIG::IP_EVADE
          if target.evaded
            # Increase Ip
            target.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_UNLUCKY
          if target.critical
            # Increase Ip
            target.ip += (100.0 * rate).round
          end
          
      end
        
    end
    
    # If an actor and has the ip type
    if battler.actor? && battler.has_ip_type?(type)
      # Get Ip Rate
      rate = battler.ip_rate(type)
      t_actor = target.is_a?(Game_Actor)

      case type
        when IPSYSTEM_CONFIG::IP_HP_ATTACKING
          # If Friendly Attack option on and actor or an enemy
          if (IPSYSTEM_CONFIG::FRIENDLY and t_actor) or !t_actor
            # If Target is being damaged
            if target.hp_damage > 0
              # Increase Ip
              battler.ip += (target.hp_damage * 100.0 / target.maxhp * rate).round
            end
          end
          
        when IPSYSTEM_CONFIG::IP_MP_ATTACKING
          # If Friendly Attack option on and actor or an enemy
          if (IPSYSTEM_CONFIG::FRIENDLY and t_actor) or !t_actor
            # If Target is being damaged
            if target.mp_damage > 0
              # Increase Ip
              battler.ip += (target.mp_damage * 100.0 / target.maxmp * rate).round
            end
          end
        
        when IPSYSTEM_CONFIG::IP_MONEY
          # If action was an item
          if battler.action.item?
            # Get Gold (or 100 if less than 100)
            gold = $game_party.gold <= 100 ? 100 : $game_party.gold
            # Increase Ip
            battler.ip += (battler.action.item.price * 100.0 / gold * rate).round
          end

        when IPSYSTEM_CONFIG::IP_MP_USER
          # If action was a skill and Not using a IP skill
          if battler.action.skill? && battler.action.ip == false
            # Increase Ip
            battler.ip += (battler.action.skill.mp_cost * 100.0 / battler.maxmp * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_STATUS
          # If battler has a state and not dead
          if battler.states.size > 0 && !battler.dead?
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_TURN
          # Increase Ip
          battler.ip += (100.0 * rate).round
        
        when IPSYSTEM_CONFIG::IP_DEFENSE
          # If action was a defend
          if battler.action.guard?
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_WAIT
          # If action was a wait
          if battler.action.wait?
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_ESCAPE
          # If action was an escape
          if battler.action.escape?
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_HP_HEALING
          # If being healed by absorbing damage
          if target.absorbed && target.hp_damage > 0
            # Increase Ip
            battler.ip += (target.hp_damage * 100.0 / battler.maxhp * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_MP_HEALING
          # If being healed by absorbing damage
          if target.absorbed && target.mp_damage > 0
            # Increase Ip
            battler.ip += (target.mp_damage * 100.0 / battler.maxmp * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_USING_SKILLS
          # If action was a skill and Not using a IP skill
          if battler.action.skill? && battler.action.ip == false
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_USING_ATTACKS
          # If action was an attack
          if battler.action.attack?
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_USING_ITEMS
          # If action was an item
          if battler.action.item?
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_FIRST
          speeds = get_action_speeds()
          # If battler has the max speed
          if battler.action.speed == speeds.max
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_LAST
          speeds = get_action_speeds()
          # If battler has the max speed
          if battler.action.speed == speeds.min
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
          
        when IPSYSTEM_CONFIG::IP_BLIND
          if target.missed
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
        
        when IPSYSTEM_CONFIG::IP_LUCKY
          if target.critical
            # Increase Ip
            battler.ip += (100.0 * rate).round
          end
          
      end
        
    end
    
  end
  private :calc_ip
  
  #--------------------------------------------------------------------------
  # * Gets action speeds from every battler in battle
  #--------------------------------------------------------------------------
  def get_action_speeds()
    # Initialize Array
    speeds = []
    # Get All Speeds
    ($game_party.members + $game_troop.members).each do |battler|
      speeds << battler.action.speed
    end
    return speeds
  end
  private :get_action_speeds
  
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_selection
  #--------------------------------------------------------------------------
  alias update_actor_command_selection_ebjb update_actor_command_selection unless $@
  def update_actor_command_selection
    update_actor_command_selection_ebjb()
    
    if Input.trigger?(Input::C)
      case @actor_command_window.index
      when 4 # IP Skill
        Sound.play_decision
        start_ip_selection
      when 5 # Wait
        Sound.play_decision
        @active_battler.action.set_wait
        next_actor
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Start Ip Skill Selection
  #--------------------------------------------------------------------------
  def start_ip_selection
    @help_window = Window_Help.new
    @ip_window = Window_IP.new(0, 56, 544, 232, @active_battler)
    @ip_window.help_window = @help_window
    @ip_window.active = true
    @actor_command_window.active = false
  end
  
  #--------------------------------------------------------------------------
  # * End IP Skill Selection
  #--------------------------------------------------------------------------
  def end_ip_selection
    if @ip_window != nil
      @ip_window.dispose
      @ip_window = nil
      @help_window.dispose
      @help_window = nil
    end
    @actor_command_window.active = true
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_basic(true)
    update_info_viewport                  # Update information viewport
    if $game_message.visible
      @info_viewport.visible = false
      @message_window.visible = true
    end
    unless $game_message.visible          # Unless displaying a message
      return if judge_win_loss            # Determine win/loss results
      update_scene_change
      if @target_enemy_window != nil
        update_target_enemy_selection     # Select target enemy
      elsif @target_actor_window != nil
        update_target_actor_selection     # Select target actor
      elsif @skill_window != nil
        update_skill_selection            # Select skill
      elsif @item_window != nil
        update_item_selection             # Select item
      elsif @ip_window != nil
        update_ip_selection               # Select IP skill
      elsif @party_command_window.active
        update_party_command_selection    # Select party command
      elsif @actor_command_window.active
        update_actor_command_selection    # Select actor command
      else
        process_battle_event              # Battle event processing
        process_action                    # Battle action
        process_battle_event              # Battle event processing
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Ip Selection
  #--------------------------------------------------------------------------
  def update_ip_selection
    @ip_window.active = true
    @ip_window.update
    @help_window.update
    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_ip_selection
    elsif Input.trigger?(Input::C)
      # Get currently selected data on the skill window
      @ip_skill = @ip_window.selected_ip
      # If it can't be used
      if @ip_skill != nil and @active_battler.ip_skill_can_use?(@ip_skill)
        Sound.play_decision
        determine_ip()
      else
        Sound.play_buzzer
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm IP Skill
  #--------------------------------------------------------------------------
  def determine_ip
    @active_battler.action.set_ip_skill(@ip_skill)
    @ip_window.active = false
    skill = @ip_window.skill
    if skill.need_selection?
      if skill.for_opponent?
        start_target_enemy_selection
      else
        start_target_actor_selection
      end
    else
      end_ip_selection
      next_actor
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias prior_actor
  #--------------------------------------------------------------------------
  alias prior_actor_ebjb prior_actor unless $@
  def prior_actor
    prior_actor_ebjb
    if @active_battler != nil
      # Clear action when returning to previous actor
      @active_battler.action.clear
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_target_enemy_selection
  #--------------------------------------------------------------------------
  alias update_target_enemy_selection_ebjb update_target_enemy_selection unless $@
  def update_target_enemy_selection
    if Input.trigger?(Input::C)
      # End Ip Select if ip window defined
      end_ip_selection if @ip_window != nil
    end
    
    update_target_enemy_selection_ebjb()
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_target_actor_selection
  #--------------------------------------------------------------------------
  alias update_target_actor_selection_ebjb update_target_actor_selection unless $@
  def update_target_actor_selection
    if Input.trigger?(Input::C)
      # End Ip Select if ip window defined
      end_ip_selection if @ip_window != nil
    end
    
    update_target_actor_selection_ebjb()
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_ebjb execute_action unless $@
  def execute_action
    execute_action_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_STATUS,
                               IPSYSTEM_CONFIG::IP_TURN,
                               IPSYSTEM_CONFIG::IP_FIRST,
                               IPSYSTEM_CONFIG::IP_LAST])
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_attack
  #--------------------------------------------------------------------------
  alias execute_action_attack_ebjb execute_action_attack unless $@
  def execute_action_attack
    execute_action_attack_ebjb()
    targets = @active_battler.action.make_targets
    for target in targets
      target.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_HP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_USING_ATTACKS,
                        IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_BLIND,
                        IPSYSTEM_CONFIG::IP_EVADE,
                        IPSYSTEM_CONFIG::IP_LUCKY,
                        IPSYSTEM_CONFIG::IP_UNLUCKY], @active_battler)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_guard
  #--------------------------------------------------------------------------
  alias execute_action_guard_ebjb execute_action_guard unless $@
  def execute_action_guard
    execute_action_guard_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_DEFENSE])
  end

  #--------------------------------------------------------------------------
  # * Alias execute_action_escape
  #--------------------------------------------------------------------------
  alias execute_action_escape_ebjb execute_action_escape unless $@
  def execute_action_escape
    execute_action_escape_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_ESCAPE])
  end

  #--------------------------------------------------------------------------
  # * Escape Processing
  #--------------------------------------------------------------------------
  alias process_escape_ebjb process_escape unless $@
  def process_escape
    for actor in $game_party.members
      actor.action.set_escape
      actor.ip_effect([IPSYSTEM_CONFIG::IP_ESCAPE])
    end
    process_escape_ebjb()
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_wait
  #--------------------------------------------------------------------------
  alias execute_action_wait_ebjb execute_action_wait unless $@
  def execute_action_wait
    execute_action_wait_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_WAIT])
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Skill
  #--------------------------------------------------------------------------
  def execute_action_skill
    skill = @active_battler.action.skill
    text = @active_battler.name + skill.message1
    @message_window.add_instant_text(text)
    unless skill.message2.empty?
      wait(10)
      @message_window.add_instant_text(skill.message2)
    end
    targets = @active_battler.action.make_targets
    display_animation(targets, skill.animation_id)
    # If IP skill is used
    if @active_battler.action.ip
      # Reduces IP
      @active_battler.ip -= @active_battler.action.ip_skill.cost
      # Reduces MP if config says so
      if !IPSYSTEM_CONFIG::FREEZE_MP
        @active_battler.mp -= @active_battler.calc_mp_cost(skill)  
      end
    else
      @active_battler.mp -= @active_battler.calc_mp_cost(skill)
    end
    $game_temp.common_event_id = skill.common_event_id
    for target in targets
      target.skill_effect(@active_battler, skill)
      display_action_effects(target, skill)
      target.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_HP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_USER,
                        IPSYSTEM_CONFIG::IP_HP_HEALING,
                        IPSYSTEM_CONFIG::IP_MP_HEALING,
                        IPSYSTEM_CONFIG::IP_USING_SKILLS,
                        IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_BLIND,
                        IPSYSTEM_CONFIG::IP_EVADE], @active_battler)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_item
  #--------------------------------------------------------------------------
  alias execute_action_item_ebjb execute_action_item unless $@
  def execute_action_item
    execute_action_item_ebjb()
    targets = @active_battler.action.make_targets
    for target in targets
      target.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_HP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MONEY,
                        IPSYSTEM_CONFIG::IP_HP_HEALING,
                        IPSYSTEM_CONFIG::IP_MP_HEALING,
                        IPSYSTEM_CONFIG::IP_USING_ITEMS,
                        IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_BLIND,
                        IPSYSTEM_CONFIG::IP_EVADE], @active_battler)
    end
  end
  
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
#  Contains the different colors
#==============================================================================

class Color
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get IP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.ip_gauge_color1
    return text_color(14)
  end
  
  #--------------------------------------------------------------------------
  # * Get IP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.ip_gauge_color2
    return text_color(17)
  end

end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Battle related
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Get Text to show for IP Skills battle command
  #--------------------------------------------------------------------------
  def self.ip_battle_command
    return "IP Skills"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Wait battle command
  #--------------------------------------------------------------------------
  def self.wait_battle_command
    return "Wait"
  end
  
  #--------------------------------------------------------------------------
  # * Get IP Label
  #--------------------------------------------------------------------------
  def self.ip_label
    return "IP"
  end
    
end

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a superclass of all windows in the game.
#==============================================================================

class Window_Base < Window
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw IP
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : Width
  #--------------------------------------------------------------------------
  def draw_actor_ip(actor, x, y, width = 120)
    draw_actor_ip_gauge(actor, x, y, width)
    self.contents.font.color = system_color
    self.contents.draw_text(x+2, y, 30, WLH, Vocab::ip_label)
    self.contents.font.color = normal_color
    last_font_size = self.contents.font.size
    xr = x + width
    self.contents.draw_text(xr - 44, y, 44, WLH,       
                            sprintf(IPSYSTEM_CONFIG::PERCENTAGE_PATTERN, actor.ip), 2)
  end
  
  #--------------------------------------------------------------------------
  # * Draw IP Gauge
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     width : Width
  #     height : Height
  #--------------------------------------------------------------------------
  def draw_actor_ip_gauge(actor, x, y, width = 120, height = 6)
    gw = width * actor.ip / 100
    gc1 = Color.ip_gauge_color1
    gc2 = Color.ip_gauge_color2
    self.contents.fill_rect(x, y + WLH - height - 2, width, height, Color.gauge_back_color)
    self.contents.gradient_fill_rect(x, y + WLH - height - 2, gw, height, gc1, gc2)
  end
  
end

#==============================================================================
# ** Window_BattleStatus
#------------------------------------------------------------------------------
#  This window displays the status of all party members on the battle screen.
#==============================================================================

class Window_BattleStatus < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw Item
  #     index : Item number
  #--------------------------------------------------------------------------
  alias draw_item_ebjb draw_item unless $@
  def draw_item(index)
    draw_item_ebjb(index)
    rect = item_rect(index)
    actor = $game_party.members[index]
    draw_actor_ip_gauge(actor, 4, rect.y, 100, 2)
  end
  
end

#==============================================================================
# ** Window_IP
#------------------------------------------------------------------------------
#  This window displays the IP skills for an actor (actor IP skills,
#  class IP skills and equipment IP skills)
#==============================================================================

class Window_IP < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCIPSkill for every IP skills of the actor
  attr_reader :ucIPSkillsList
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current ip
  #--------------------------------------------------------------------------
  # GET
  def selected_ip
    return (self.index < 0 || @data[self.index] == nil ? nil : @data[self.index][1])
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def skill
    return $data_skills[selected_ip.id] if selected_ip != nil
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y corrdinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @ucIPSkillsList = []
    window_update(actor)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    @data = []
    if actor != nil
      @actor = actor

      ip_skills = actor.ip_skills
      if ip_skills != nil
        index = 0
        # Actor IP skills & Class IP Skills
        for skill_set in ip_skills
          # Increment Index
          index += 1 
          if skill_set != nil
            for skill in skill_set
              obj = (index == 1) ? actor : actor.class
              @data.push([obj, skill]) if skill != nil
            end
          end
        end
      end
      
      equips = actor.equips
      if equips != nil
        index = 0
        # Equipment IP skills
        for item in equips
          if item != nil
            for skill in item.ip_skills
              @data.push([item, skill])
            end
          else
            case index
            when 0
              if @actor.two_swords_style
                kindDesc = Vocab::weapon1
              else
                kindDesc = Vocab::weapon
              end
            when 1
              if @actor.two_swords_style
                kindDesc = Vocab::weapon2
              else
                kindDesc = Vocab::armor1
              end
            when 2
              kindDesc = Vocab::armor2
            when 3
              kindDesc = Vocab::armor3
            when 4
              kindDesc = Vocab::armor4
            end
            @data.push([kindDesc, nil])
          end
          index += 1
        end
      end
      
      @item_max = @data.size
      create_contents()
      @ucIPSkillsList.clear()
      for i in 0..@item_max-1
        @ucIPSkillsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @ucIPSkillsList.each() { |ucIPSKillItem| ucIPSKillItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if selected_ip != nil
#~       @help_window.window_update(skill.description)
#~     else
#~       @help_window.window_update("")
#~     end
    @help_window.set_text(skill == nil ? "" : skill.description)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the UCIPSkills list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    data = @data[index]
    rect = item_rect(index, true)
    
    ucIPSkillItem = UCIPSkill.new(self, data[0], data[1], rect)
    
    if data[1] == nil
      # Different color when there are no skill for the current item
      f = Font.new()
      f.color = system_color
      ucIPSkillItem.cIPSkillSrcName.font = f
    elsif @actor.ip < data[1].cost
      ucIPSkillItem.active = false
    end

    return ucIPSkillItem
  end
  private :create_item
  
end

#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw Basic Information
  #     x : Draw spot X coordinate
  #     y : Draw spot Y coordinate
  #--------------------------------------------------------------------------
  alias draw_basic_info_ebjb draw_basic_info unless $@
  def draw_basic_info(x, y)
    draw_basic_info_ebjb(x,y)
    draw_actor_ip(@actor, x, y + WLH * 4)
  end

end

#==============================================================================
# ** Window_MenuStatus
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_MenuStatus < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Alias Refresh
  #--------------------------------------------------------------------------
  alias refresh_ebjb refresh unless $@
  def refresh
    refresh_ebjb()
    for actor in $game_party.members
      x = 104
      y = actor.index * (Graphics.height-32)/4 + WLH / 2 + 2
      bar_width = contents.width - x - 124
      draw_actor_ip(actor, x + 120, y + WLH * 3, bar_width)
    end
  end
  
end

#==============================================================================
# ** Window_ActorCommand
#------------------------------------------------------------------------------
#  This window is used to select actor commands, such as "Attack" or "Skill".
#==============================================================================

class Window_ActorCommand < Window_Command
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Setup
  #     actor : actor
  #--------------------------------------------------------------------------
  alias setup_ebjb setup unless $@
  def setup(actor)
    setup_ebjb(actor)
    # Adds the IP Skills command
    self.add_command(Vocab::ip_battle_command, false)
    # Adds the Wait command
    self.add_command(Vocab::wait_battle_command, false)
  end
  
end

#==============================================================================
# ** UCIPSkill
#------------------------------------------------------------------------------
#  Represents an IP skill on a window
#==============================================================================

class UCIPSkill < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the IP skill source icon (Actor, Class or Equipment)
  attr_reader :ucIPSkillSrcIcon
  # CLabel for the IP skill source name (Actor, Class or Equipment)
  attr_reader :cIPSkillSrcName
  # CLabel for the IP skill name
  attr_reader :cIPSkillName
  # CLabel for the IP skill cost
  attr_reader :cIPSkillCost
  # IP skill object
  attr_reader :ipSkill
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIPSkillSrcIcon.visible = visible
    @cIPSkillSrcName.visible = visible
    @cIPSkillName.visible = visible
    @cIPSkillCost.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIPSkillSrcIcon.active = active
    @cIPSkillSrcName.active = active
    @cIPSkillName.active = active
    @cIPSkillCost.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     ipSource : IP Skill source object (Game_Actor, RPG::Class or RPG::BaseItem)
  #     ipSkill : IPSkill object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, ipSource, ipSkill, rect, spacing=10, 
                 active=true, visible=true)
    super(active, visible)
    @ipSkill = ipSkill
    
    case true
      when ipSource.is_a?(Game_Actor)
        icon_index = nil
        name = ipSource.name
      
      when ipSource.is_a?(RPG::Class)
        icon_index = nil
        name = ipSource.name
      
      when ipSource.is_a?(RPG::BaseItem)
        icon_index = ipSource.icon_index
        name = ipSource.name
      else
        icon_index = nil
        name = ipSource
    end
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIPSkillSrcIcon = UCIcon.new(window, rects[0], icon_index)
    @ucIPSkillSrcIcon.active = active
    @ucIPSkillSrcIcon.visible = visible
    
    @cIPSkillSrcName = CLabel.new(window, rects[1], name)
    @cIPSkillSrcName.active = active
    @cIPSkillSrcName.visible = visible
    @cIPSkillSrcName.cut_overflow = true
    
    if ipSkill != nil
      skill = $data_skills[ipSkill.id]
      skill_name = skill.name
      skill_cost = ipSkill.cost
    else
      skill_name = ""
      skill_cost = 0
      visible = false
    end
    skill = $data_skills[@ipSkill.id]
    
    @cIPSkillName = CLabel.new(window, rects[2], skill_name)
    @cIPSkillName.active = active
    @cIPSkillName.visible = visible
    @cIPSkillName.cut_overflow = true
    
    @cIPSkillCost = CLabel.new(window, rects[3], 
                               sprintf(IPSYSTEM_CONFIG::PERCENTAGE_PATTERN, skill_cost), 2)
    @cIPSkillCost.active = active
    if IPSYSTEM_CONFIG::HIDE_IP_COST == true
      @cIPSkillCost.visible = false
    else
      @cIPSkillCost.visible = visible
    end
    @cIPSkillCost.cut_overflow = true
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIPSkillSrcIcon.draw()
    @cIPSkillSrcName.draw()
    @cIPSkillName.draw()
    @cIPSkillCost.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[3] = Rect.new(rect.x,rect.y,60,rect.height)
    
    name_width = ((rect.width - rects[0].width - rects[3].width - spacing*2) / 2).floor
    
    # Rects Adjustments
    
    # ucIPSkillSrcIcon
    # Nothing to do
    
    # cIPSkillSrcName
    rects[1].x += rects[0].width
    rects[1].width = name_width
    
    # cIPSkillName
    rects[2].x += rect.width - rects[3].width - name_width - spacing
    rects[2].width = name_width
    
    # cIPSkillCost
    rects[3].x += rect.width - rects[3].width
    
    return rects
  end
  private :determine_rects
  
end

