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