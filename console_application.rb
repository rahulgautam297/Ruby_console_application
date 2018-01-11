require 'state_machine'

class FullName
  attr_accessor :first_name, :last_name

  def initialize
    @first_name = ""
    @last_name = ""
    super
  end
  # Different states
  state_machine :state, initial: :write_first_name do
    event :writing_first_name do
      transition write_first_name: :first_name_written
    end
    event :writing_last_name do
      transition first_name_written: :last_name_written
    end
  end

  def writing_first_name(first_name)
    @first_name = first_name
    super
  end

  def writing_last_name(last_name)
    @last_name = last_name
    super
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end
end

class WorkEx
  attr_accessor :job_position, :company_name

  def initialize
    @job_position = ""
    @company_name = ""
    super
  end
  
  # Different states
  state_machine :state, initial: :write_job_position do
    event :writing_job_position do
      transition write_job_position: :job_position_written
    end
    event :writing_company_name do
      transition job_position_written: :company_name_written
    end
  end

  def writing_job_position(job_position)
    @job_position = job_position
    super
  end

  def writing_company_name(company_name)
    @company_name = company_name
    super
  end
end

class Interview
  attr_accessor :name, :work_experience
  
  def initialize
    @name = FullName.new
    @work_experience = WorkEx.new
    super
  end
  # Different states
  state_machine :state, initial: :main_menu do
    event :want_job_description_menu do
      transition main_menu: :job_description_menu
    end
    event :want_main_menu do
      transition job_description_menu: :main_menu
    end
  end

  def full_info
    puts "Full Name: #{@name.full_name}, Job Position: #{@work_experience.job_position}, Company Name: #{@work_experience.company_name}"
  end

  def lexical_analyzer
    [@name.full_name.scan(/[a-zA-Z]+/),
    @work_experience.job_position.scan(/[a-zA-Z]+/),
    @work_experience.company_name.scan(/[a-zA-Z]+/),
    ]
  end
end

interview = Interview.new

loop do
  if interview.state == "main_menu"
    if interview.name.state == "write_first_name"
      puts "Main Menu
      1. Enter Name
      2. Working Experience
      3. Exit
      
      Select number or menu name.
      
      "
      # When we have user's full name
    elsif interview.name.state == "last_name_written"
    puts "Main Menu
          1. Enter Name (#{interview.name.full_name})
          2. Working Experience
          3. Exit
          
          Select number or menu name.
          
          "
    end
    input = gets.chomp

    if input == "1" || input == "Enter Name"
      print "Enter First Name: "
      interview.name.writing_first_name(gets.chomp)
      print "Enter Last Name: "
      interview.name.writing_last_name(gets.chomp)
    elsif input == "2" || input == "Working Experience"
      interview.want_job_description_menu
    elsif input == "3" || input == "Exit"
      interview.full_info
      # Can be iterated for cleaner output.
      print "Lexical Analysis => Words: #{interview.lexical_analyzer}"
      break;
    end
  elsif interview.state == "job_description_menu"
    puts "Job Description Menu:
          1. Job Position
          2. Company
          3. Back to Main Menu

    Select number or menu name.
    
    "
    input = gets.chomp

    if input == "1" || input == "Job Position"
      print "Enter job Position: "
      interview.work_experience.writing_job_position(gets.chomp)
    elsif input == "2" || input == "Company"
      print "Enter Company Name: "
      interview.work_experience.writing_company_name(gets.chomp)
    elsif input == "3" || input == "Main Menu"
      interview.want_main_menu
    end
  end
end