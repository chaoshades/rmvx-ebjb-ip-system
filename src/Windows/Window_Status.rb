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
