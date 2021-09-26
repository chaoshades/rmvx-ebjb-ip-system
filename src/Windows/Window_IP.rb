#==============================================================================
# ** Window_IP
#------------------------------------------------------------------------------
#  This window displays the IP skills for an actor (actor IP skills,
#  class IP skills and equipment IP skills)
#==============================================================================

class Window_IP < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCIPSkill for every IP skills of the actor
  attr_reader :ucIPSkillsList
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current ip
  #--------------------------------------------------------------------------
  # GET
  def selected_ip
    return (self.index < 0 || @data[self.index] == nil ? nil : @data[self.index][1])
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill
  #--------------------------------------------------------------------------
  def skill
    return $data_skills[selected_ip.id] if selected_ip != nil
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y corrdinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @ucIPSkillsList = []
    window_update(actor)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    @data = []
    if actor != nil
      @actor = actor

      ip_skills = actor.ip_skills
      if ip_skills != nil
        index = 0
        # Actor IP skills & Class IP Skills
        for skill_set in ip_skills
          # Increment Index
          index += 1 
          if skill_set != nil
            for skill in skill_set
              obj = (index == 1) ? actor : actor.class
              @data.push([obj, skill]) if skill != nil
            end
          end
        end
      end
      
      equips = actor.equips
      if equips != nil
        index = 0
        # Equipment IP skills
        for item in equips
          if item != nil
            for skill in item.ip_skills
              @data.push([item, skill])
            end
          else
            case index
            when 0
              if @actor.two_swords_style
                kindDesc = Vocab::weapon1
              else
                kindDesc = Vocab::weapon
              end
            when 1
              if @actor.two_swords_style
                kindDesc = Vocab::weapon2
              else
                kindDesc = Vocab::armor1
              end
            when 2
              kindDesc = Vocab::armor2
            when 3
              kindDesc = Vocab::armor3
            when 4
              kindDesc = Vocab::armor4
            end
            @data.push([kindDesc, nil])
          end
          index += 1
        end
      end
      
      @item_max = @data.size
      create_contents()
      @ucIPSkillsList.clear()
      for i in 0..@item_max-1
        @ucIPSkillsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @ucIPSkillsList.each() { |ucIPSKillItem| ucIPSKillItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if selected_ip != nil
#~       @help_window.window_update(skill.description)
#~     else
#~       @help_window.window_update("")
#~     end
    @help_window.set_text(skill == nil ? "" : skill.description)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the UCIPSkills list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    data = @data[index]
    rect = item_rect(index, true)
    
    ucIPSkillItem = UCIPSkill.new(self, data[0], data[1], rect)
    
    if data[1] == nil
      # Different color when there are no skill for the current item
      f = Font.new()
      f.color = system_color
      ucIPSkillItem.cIPSkillSrcName.font = f
    elsif @actor.ip < data[1].cost
      ucIPSkillItem.active = false
    end

    return ucIPSkillItem
  end
  private :create_item
  
end
