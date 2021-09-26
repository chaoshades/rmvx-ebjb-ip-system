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
