class Nasa
  def self.deploy(rover_squad, plateau)
    rover_squad.rovers_with_commands_strings.map { |rover, commands_string|
      rover.deploy_on(plateau).execute commands_string
    }.each do |rover|
      puts "#{rover}"; puts
    end
  end
end
