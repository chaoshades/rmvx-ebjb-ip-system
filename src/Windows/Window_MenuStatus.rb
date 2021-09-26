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
