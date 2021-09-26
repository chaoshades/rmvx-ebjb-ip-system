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
