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
