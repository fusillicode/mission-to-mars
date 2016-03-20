class Nasa
  def self.deploy(rover_squad, plateau)
    rover_squad.rovers_with_commands_strings.map do |rover, commands_string|
      rover.deploy_on(plateau).execute commands_string
    end.each do |rover|
      puts rover.to_s; puts
    end
  end
end
