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
