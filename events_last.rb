require 'date'

all_events = []
all_participants = []

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

    def show_events
        self.all.each {|event| puts "#{event.name}, #{event.date}, #{event.place}, #{event.seats_num}, Participants: #{event.show_participants}"}
    end

    attr_accessor :name, :date, :place, :seats_num, :participants

    def initialize (name, date, place, seats_num, participants=[])
        validate_event

        @name = name
        @date = date
        @place = place
        @seats_num = seats_num
        @participants = participants

        self.class.all << self
    end

    def validate_event
        puts "Wrong number of seats!" if @seats_num < 0
        puts "Wrong event date!" if Date.parse(@date) <= Date.today
        raise "ValidationError"
    end

    def add_participant(participant)
        self.participants.push(participant)
    end

    def remove_participant(participant_to_remove)
        self.participants = self.participants.select {|current_participant| current_participant != participant_to_remove}
    end

    def show_participants()
        self.participants.each_with_index {|participant, idx| puts "#{idx+1}. #{participant.name}, #{participant.sername}, #{participant.email}\n\n"} #тут хотел чтобы каждый новый ивент с новой строчки был, как сделать можно
    end

end

ivan = Participant.new("Ivan", "begunov", "ivan@mail.ru")
alex = Participant.new("Alex", "beAlex", "Alex@mail.ru")
andry = Participant.new("Andry", "beAndry", "Andry@mail.ru")
odri = Participant.new("Odri", "beOdri", "Odri@mail.ru")
sam = Participant.new("Sam", "beSam", "Sam@mail.ru")

ivan_bd = Event.new("Ivan Birthday", "06.06.2025", "Voronezh", 8)
alex_bd = Event.new("Alex Birthday", "09.06.2026", "Minsk", 10)

ivan_bd.add_participant(ivan)
ivan_bd.add_participant(alex)
ivan_bd.add_participant(andry)
ivan_bd.add_participant(odri)

loop do
    puts "Hi! Choose what you want to do:"
    puts "1. See all events\n2. Sign up for an event\n3. Remove from event\n4.Exit"

    user_choice = gets.chomp.downcase

    case user_choice
    when "1"
        puts "Here are all events: #{Event.all}"

    when "2"
        puts "Okay, enter the name of the event you want to sign up:"
        wanted_event_name = gets.chomp
        wanted_event_array = Event.all.select {|event| event.name == wanted_event_name}
        wanted_event = wanted_event_array[0]
        if wanted_event_array == []
            puts "We don't have such event!" 
        else 
            puts "Okay, you choosed #{wanted_event.name}, #{wanted_event.date}, #{wanted_event.place}"
            puts "Now enter your name, sername and email"
            participant_data = gets.chomp.split
            current_participant_array = Participant.all.select {|participant| participant.name == participant_data[0] && participant.sername == participant_data[1] && participant.email == participant_data[2]}
            current_participant = current_participant_array[0]
            if current_participant_array == []
                puts "We can't find such a participant, do you want to register new one?[y/n]"
                user_choice = gets.chomp.downcase
                if user_choice == "y"
                    new_participant = Participant.new("#{participant_data[0]}", "#{participant_data[1]}", "#{participant_data[2]}")
                    wanted_event.add_participant(new_participant)
                    puts "Okay, we added you to this event!"
                else return ""                                           #как тут можно было по другому выйти из текущего цикла, чтобы начать новый цикл
                end
            else wanted_event.add_participant(current_participant)
                puts "Okay, new participant is added!"
            end
        end
    when "3" 
        puts "Okay, enter the name of the event you want to sign out:"
        wanted_event_name = gets.chomp
        wanted_event_array = Event.all.select {|event| event.name == wanted_event_name}
        wanted_event = wanted_event_array[0]
        if wanted_event_array == []
            puts "We don't have such event!" 
        else 
            puts "Okay, you choosed #{wanted_event.name}, #{wanted_event.date}, #{wanted_event.place}"
            puts "Now enter your name, sername and email"
            participant_data = gets.chomp.split
            current_participant_array = wanted_event.participants.select {|participant| participant.name == participant_data[0] && participant.sername == participant_data[1] && participant.email == participant_data[2]}
            current_participant = current_participant_array[0]
            if current_participant_array == []
                puts "We can't find such a participant in this event!"
            else wanted_event.remove_participant(current_participant)
                puts "Okay, we removed you from the event!"
            end
        end
    else puts "I don't understand you! Try again!"

    end
    break if user_choice == "exit" || user_choice == "Exit" || user_choice == "4"
end



        

