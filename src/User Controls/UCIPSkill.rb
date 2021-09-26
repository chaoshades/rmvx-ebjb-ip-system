#==============================================================================
# ** UCIPSkill
#------------------------------------------------------------------------------
#  Represents an IP skill on a window
#==============================================================================

class UCIPSkill < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the IP skill source icon (Actor, Class or Equipment)
  attr_reader :ucIPSkillSrcIcon
  # CLabel for the IP skill source name (Actor, Class or Equipment)
  attr_reader :cIPSkillSrcName
  # CLabel for the IP skill name
  attr_reader :cIPSkillName
  # CLabel for the IP skill cost
  attr_reader :cIPSkillCost
  # IP skill object
  attr_reader :ipSkill
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIPSkillSrcIcon.visible = visible
    @cIPSkillSrcName.visible = visible
    @cIPSkillName.visible = visible
    @cIPSkillCost.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIPSkillSrcIcon.active = active
    @cIPSkillSrcName.active = active
    @cIPSkillName.active = active
    @cIPSkillCost.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     ipSource : IP Skill source object (Game_Actor, RPG::Class or RPG::BaseItem)
  #     ipSkill : IPSkill object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, ipSource, ipSkill, rect, spacing=10, 
                 active=true, visible=true)
    super(active, visible)
    @ipSkill = ipSkill
    
    case true
      when ipSource.is_a?(Game_Actor)
        icon_index = nil
        name = ipSource.name
      
      when ipSource.is_a?(RPG::Class)
        icon_index = nil
        name = ipSource.name
      
      when ipSource.is_a?(RPG::BaseItem)
        icon_index = ipSource.icon_index
        name = ipSource.name
      else
        icon_index = nil
        name = ipSource
    end
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIPSkillSrcIcon = UCIcon.new(window, rects[0], icon_index)
    @ucIPSkillSrcIcon.active = active
    @ucIPSkillSrcIcon.visible = visible
    
    @cIPSkillSrcName = CLabel.new(window, rects[1], name)
    @cIPSkillSrcName.active = active
    @cIPSkillSrcName.visible = visible
    @cIPSkillSrcName.cut_overflow = true
    
    if ipSkill != nil
      skill = $data_skills[ipSkill.id]
      skill_name = skill.name
      skill_cost = ipSkill.cost
    else
      skill_name = ""
      skill_cost = 0
      visible = false
    end
    skill = $data_skills[@ipSkill.id]
    
    @cIPSkillName = CLabel.new(window, rects[2], skill_name)
    @cIPSkillName.active = active
    @cIPSkillName.visible = visible
    @cIPSkillName.cut_overflow = true
    
    @cIPSkillCost = CLabel.new(window, rects[3], 
                               sprintf(IPSYSTEM_CONFIG::PERCENTAGE_PATTERN, skill_cost), 2)
    @cIPSkillCost.active = active
    if IPSYSTEM_CONFIG::HIDE_IP_COST == true
      @cIPSkillCost.visible = false
    else
      @cIPSkillCost.visible = visible
    end
    @cIPSkillCost.cut_overflow = true
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIPSkillSrcIcon.draw()
    @cIPSkillSrcName.draw()
    @cIPSkillName.draw()
    @cIPSkillCost.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[3] = Rect.new(rect.x,rect.y,60,rect.height)
    
    name_width = ((rect.width - rects[0].width - rects[3].width - spacing*2) / 2).floor
    
    # Rects Adjustments
    
    # ucIPSkillSrcIcon
    # Nothing to do
    
    # cIPSkillSrcName
    rects[1].x += rects[0].width
    rects[1].width = name_width
    
    # cIPSkillName
    rects[2].x += rect.width - rects[3].width - name_width - spacing
    rects[2].width = name_width
    
    # cIPSkillCost
    rects[3].x += rect.width - rects[3].width
    
    return rects
  end
  private :determine_rects
  
end
