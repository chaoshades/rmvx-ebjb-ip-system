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
