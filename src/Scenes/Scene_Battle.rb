#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_actor_command_selection
  #--------------------------------------------------------------------------
  alias update_actor_command_selection_ebjb update_actor_command_selection unless $@
  def update_actor_command_selection
    update_actor_command_selection_ebjb()
    
    if Input.trigger?(Input::C)
      case @actor_command_window.index
      when 4 # IP Skill
        Sound.play_decision
        start_ip_selection
      when 5 # Wait
        Sound.play_decision
        @active_battler.action.set_wait
        next_actor
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Start Ip Skill Selection
  #--------------------------------------------------------------------------
  def start_ip_selection
    @help_window = Window_Help.new
    @ip_window = Window_IP.new(0, 56, 544, 232, @active_battler)
    @ip_window.help_window = @help_window
    @ip_window.active = true
    @actor_command_window.active = false
  end
  
  #--------------------------------------------------------------------------
  # * End IP Skill Selection
  #--------------------------------------------------------------------------
  def end_ip_selection
    if @ip_window != nil
      @ip_window.dispose
      @ip_window = nil
      @help_window.dispose
      @help_window = nil
    end
    @actor_command_window.active = true
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_basic(true)
    update_info_viewport                  # Update information viewport
    if $game_message.visible
      @info_viewport.visible = false
      @message_window.visible = true
    end
    unless $game_message.visible          # Unless displaying a message
      return if judge_win_loss            # Determine win/loss results
      update_scene_change
      if @target_enemy_window != nil
        update_target_enemy_selection     # Select target enemy
      elsif @target_actor_window != nil
        update_target_actor_selection     # Select target actor
      elsif @skill_window != nil
        update_skill_selection            # Select skill
      elsif @item_window != nil
        update_item_selection             # Select item
      elsif @ip_window != nil
        update_ip_selection               # Select IP skill
      elsif @party_command_window.active
        update_party_command_selection    # Select party command
      elsif @actor_command_window.active
        update_actor_command_selection    # Select actor command
      else
        process_battle_event              # Battle event processing
        process_action                    # Battle action
        process_battle_event              # Battle event processing
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Ip Selection
  #--------------------------------------------------------------------------
  def update_ip_selection
    @ip_window.active = true
    @ip_window.update
    @help_window.update
    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_ip_selection
    elsif Input.trigger?(Input::C)
      # Get currently selected data on the skill window
      @ip_skill = @ip_window.selected_ip
      # If it can't be used
      if @ip_skill != nil and @active_battler.ip_skill_can_use?(@ip_skill)
        Sound.play_decision
        determine_ip()
      else
        Sound.play_buzzer
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm IP Skill
  #--------------------------------------------------------------------------
  def determine_ip
    @active_battler.action.set_ip_skill(@ip_skill)
    @ip_window.active = false
    skill = @ip_window.skill
    if skill.need_selection?
      if skill.for_opponent?
        start_target_enemy_selection
      else
        start_target_actor_selection
      end
    else
      end_ip_selection
      next_actor
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias prior_actor
  #--------------------------------------------------------------------------
  alias prior_actor_ebjb prior_actor unless $@
  def prior_actor
    prior_actor_ebjb
    if @active_battler != nil
      # Clear action when returning to previous actor
      @active_battler.action.clear
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_target_enemy_selection
  #--------------------------------------------------------------------------
  alias update_target_enemy_selection_ebjb update_target_enemy_selection unless $@
  def update_target_enemy_selection
    if Input.trigger?(Input::C)
      # End Ip Select if ip window defined
      end_ip_selection if @ip_window != nil
    end
    
    update_target_enemy_selection_ebjb()
  end
  
  #--------------------------------------------------------------------------
  # * Alias update_target_actor_selection
  #--------------------------------------------------------------------------
  alias update_target_actor_selection_ebjb update_target_actor_selection unless $@
  def update_target_actor_selection
    if Input.trigger?(Input::C)
      # End Ip Select if ip window defined
      end_ip_selection if @ip_window != nil
    end
    
    update_target_actor_selection_ebjb()
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_ebjb execute_action unless $@
  def execute_action
    execute_action_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_STATUS,
                               IPSYSTEM_CONFIG::IP_TURN,
                               IPSYSTEM_CONFIG::IP_FIRST,
                               IPSYSTEM_CONFIG::IP_LAST])
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_attack
  #--------------------------------------------------------------------------
  alias execute_action_attack_ebjb execute_action_attack unless $@
  def execute_action_attack
    execute_action_attack_ebjb()
    targets = @active_battler.action.make_targets
    for target in targets
      target.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_HP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_USING_ATTACKS,
                        IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_BLIND,
                        IPSYSTEM_CONFIG::IP_EVADE,
                        IPSYSTEM_CONFIG::IP_LUCKY,
                        IPSYSTEM_CONFIG::IP_UNLUCKY], @active_battler)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_guard
  #--------------------------------------------------------------------------
  alias execute_action_guard_ebjb execute_action_guard unless $@
  def execute_action_guard
    execute_action_guard_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_DEFENSE])
  end

  #--------------------------------------------------------------------------
  # * Alias execute_action_escape
  #--------------------------------------------------------------------------
  alias execute_action_escape_ebjb execute_action_escape unless $@
  def execute_action_escape
    execute_action_escape_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_ESCAPE])
  end

  #--------------------------------------------------------------------------
  # * Escape Processing
  #--------------------------------------------------------------------------
  alias process_escape_ebjb process_escape unless $@
  def process_escape
    for actor in $game_party.members
      actor.action.set_escape
      actor.ip_effect([IPSYSTEM_CONFIG::IP_ESCAPE])
    end
    process_escape_ebjb()
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_wait
  #--------------------------------------------------------------------------
  alias execute_action_wait_ebjb execute_action_wait unless $@
  def execute_action_wait
    execute_action_wait_ebjb()
    @active_battler.ip_effect([IPSYSTEM_CONFIG::IP_WAIT])
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Skill
  #--------------------------------------------------------------------------
  def execute_action_skill
    skill = @active_battler.action.skill
    text = @active_battler.name + skill.message1
    @message_window.add_instant_text(text)
    unless skill.message2.empty?
      wait(10)
      @message_window.add_instant_text(skill.message2)
    end
    targets = @active_battler.action.make_targets
    display_animation(targets, skill.animation_id)
    # If IP skill is used
    if @active_battler.action.ip
      # Reduces IP
      @active_battler.ip -= @active_battler.action.ip_skill.cost
      # Reduces MP if config says so
      if !IPSYSTEM_CONFIG::FREEZE_MP
        @active_battler.mp -= @active_battler.calc_mp_cost(skill)  
      end
    else
      @active_battler.mp -= @active_battler.calc_mp_cost(skill)
    end
    $game_temp.common_event_id = skill.common_event_id
    for target in targets
      target.skill_effect(@active_battler, skill)
      display_action_effects(target, skill)
      target.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_HP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_USER,
                        IPSYSTEM_CONFIG::IP_HP_HEALING,
                        IPSYSTEM_CONFIG::IP_MP_HEALING,
                        IPSYSTEM_CONFIG::IP_USING_SKILLS,
                        IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_BLIND,
                        IPSYSTEM_CONFIG::IP_EVADE], @active_battler)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action_item
  #--------------------------------------------------------------------------
  alias execute_action_item_ebjb execute_action_item unless $@
  def execute_action_item
    execute_action_item_ebjb()
    targets = @active_battler.action.make_targets
    for target in targets
      target.ip_effect([IPSYSTEM_CONFIG::IP_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_HP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MP_ATTACKING,
                        IPSYSTEM_CONFIG::IP_MONEY,
                        IPSYSTEM_CONFIG::IP_HP_HEALING,
                        IPSYSTEM_CONFIG::IP_MP_HEALING,
                        IPSYSTEM_CONFIG::IP_USING_ITEMS,
                        IPSYSTEM_CONFIG::IP_TAKING_HP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_TAKING_MP_DAMAGE,
                        IPSYSTEM_CONFIG::IP_BLIND,
                        IPSYSTEM_CONFIG::IP_EVADE], @active_battler)
    end
  end
  
end
