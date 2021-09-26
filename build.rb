module EBJB_IPSystem
  # Build filename
  FINAL   = "build/EBJB_IPSystem.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/IPSystem_Config.rb",
    "src/RPG Objects/RPG_Weapon Addon.rb",
    "src/RPG Objects/RPG_Armor Addon.rb",
    "src/Game Objects/Game_Actor.rb",
    "src/Game Objects/Game_BattleAction.rb",
    "src/Game Objects/Game_Battler.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/User Interface/Color.rb",
    "src/User Interface/Vocab.rb",
    "src/Windows/Window_Base.rb",
    "src/Windows/Window_BattleStatus.rb",
    "src/Windows/Window_IP.rb",
    "src/Windows/Window_Status.rb",
    "src/Windows/Window_MenuStatus.rb",
    "src/Windows/Window_ActorCommand.rb",
    "src/User Controls/UCIPSkill.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_IPSystem::FINAL, "w+")
  EBJB_IPSystem::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()
