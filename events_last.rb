require 'date'

class Participant
    @all = []
    def self.all
        @all
    end

    attr_accessor :name, :sername, :email

    def initialize (name, sername, email)
        @name = name
        @sername = sername
        @email = email

        self.class.all << self
    end
end

class Event
    @all = []
    def self.all
        @all
    end

    attr_accessor :name, :date, :place, :seats_num, :participants

    def initialize (name, date, place, seats_num=0, participants=[])
        @date = date
        @seats_num = seats_num
        validate_event
        
        @name = name
        @place = place
        @participants = participants

        
    end

    def validate_event
        raise "Wrong number of seats!" if @seats_num < 0
        raise "Wrong event date!" if Date.parse(@date) <= Date.today
    end

    

end

class EventManager

    attr_accessor :events

    def initialize(events=[])
        @events = events

        event_validation

        @participants = @events.map(&:participants).flatten.uniq
    end

    def event_validation
        @events.each {|event| event.validate_event}
    end

    def add_event(name, date, place, seats_num=0, participants=[])
        new_event = Event.new(name, date, place, seats_num, participants)
        event_validation
        @events << new_event
        return new_event
    end

    def add_participant(event, participant)
        event.participants.push(participant)
    end

    def remove_participant(event, participant_to_remove)
        event.participants = event.participants.reject {|current_participant| current_participant == participant_to_remove}
    end

    def select_participant_from_event(event, wanted_participant_data)
    event.participants.select {|participant| participant.name == wanted_participant_data[0] && participant.sername == wanted_participant_data[1] && participant.email == wanted_participant_data[2]}.first
    end

    def select_event_by_name(wanted_event_name)
        @events.select {|event| event.name == wanted_event_name}.first
    end
end

class EventConsoleInterface

    def show_events(event_manager)
        puts "met"
        event_manager.events.each {|event| puts "\n#{event.name}, #{event.date}, #{event.place}, #{event.seats_num}, \nParticipants: #{self.show_participants(event_manager, "#{event.name}")}"}
        
    end

    def show_participants(event_manager, event_name)
        wanted_event = event_manager.select_event_by_name(event_name)
        wanted_event.participants.each_with_index {|participant, idx|  "\n#{idx+1}. #{participant.name}, #{participant.sername}, #{participant.email}"} #тут хотел чтобы каждый новый ивент с новой строчки был, как сделать можно
    end

end


console_interface = EventConsoleInterface.new
main_manager = EventManager.new

ivan = Participant.new("Ivan", "begunov", "ivan@mail.ru")
alex = Participant.new("Alex", "beAlex", "Alex@mail.ru")
andry = Participant.new("Andry", "beAndry", "Andry@mail.ru")
odri = Participant.new("Odri", "beOdri", "Odri@mail.ru")
sam = Participant.new("Sam", "beSam", "Sam@mail.ru")

ivan_bd = main_manager.add_event("Ivan Birthday", "06.06.2025", "Voronezh", 8)
alex_bd = main_manager.add_event("Alex Birthday", "09.06.2026", "Minsk", 10)

main_manager.add_participant(ivan_bd, ivan)
main_manager.add_participant(ivan_bd, alex)
main_manager.add_participant(ivan_bd, andry)
main_manager.add_participant(ivan_bd, odri)

loop do
    puts "Hi! Choose what you want to do:"
    puts "1. See all events\n2. Sign up for an event\n3. Remove from event\n4.Exit"

    user_choice = gets.chomp.downcase
    break if user_choice == "exit" || user_choice == "Exit" || user_choice == "4"
    case user_choice
    when "1"
        puts "Here are all events: \n #{console_interface.show_events(main_manager)} КОНЕЦ"

    when "2"
        puts "Okay, enter the name of the event you want to sign up:"
        wanted_event_name = gets.chomp
        wanted_event = main_manager.select_event_by_name(wanted_event_name)
        puts wanted_event
        puts "#{wanted_event}"
        if wanted_event == nil
            puts "We don't have such event!" 
        else 
            puts "Okay, you choosed #{wanted_event.name}, #{wanted_event.date}, #{wanted_event.place}"
            puts "Now enter your name, sername and email"
            participant_data = gets.chomp.split
            puts "#{participant_data}"
            current_participant = main_manager.select_participant_from_event(wanted_event, participant_data)
            if current_participant == nil
                puts "We can't find such a participant, do you want to register new one?[y/n]"
                user_choice = gets.chomp.downcase
                if user_choice == "y"
                    new_participant = Participant.new("#{participant_data[0]}", "#{participant_data[1]}", "#{participant_data[2]}")
                    main_manager.add_participant(wanted_event, new_participant)
                    puts "Okay, we added you to this event!"
                else return "ds"                                           #как тут можно было по другому выйти из текущего цикла, чтобы начать новый цикл
                end
            else main_manager.add_participant(wanted_event, current_participant)
                puts "Okay, new participant is added!"
            end
        end
    when "3" 
        puts "Okay, enter the name of the event you want to sign out:"
        wanted_event_name = gets.chomp
        wanted_event = main_manager.select_event_by_name(wanted_event_name)
        if wanted_event == nil
            puts "We don't have such event!" 
        else 
            puts "Okay, you choosed #{wanted_event.name}, #{wanted_event.date}, #{wanted_event.place}"
            puts "Now enter your name, sername and email"
            participant_data = gets.chomp.split
            puts "participant_data .#{participant_data}."
            current_participant = main_manager.select_participant_from_event(wanted_event, participant_data)
            puts "current_participant #{current_participant}"
            if current_participant == nil
                puts "We can't find such a participant in this event!"
            else main_manager.remove_participant(wanted_event, current_participant)
                puts "Okay, we removed you from the event!"
            end
        end
    else puts "I don't understand you! Try again!"

    end
    
end



        

