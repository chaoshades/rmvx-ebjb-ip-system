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
