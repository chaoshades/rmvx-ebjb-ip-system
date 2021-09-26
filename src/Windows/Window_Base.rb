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
