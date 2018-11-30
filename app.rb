require 'tty-prompt'

@prompt = TTY::Prompt.new
@option = 1

def clear_terminal
    system 'clear'
end

def show_home
    clear_terminal
    puts '----------- Text Translator -----------'
    @option = @prompt.select("Select a option: ") do |menu|
        menu.choice 'Translator', 2
        menu.choice 'Setup', 3
        menu.choice 'Exit', 0
    end
    puts @option
end

def show_translator
    clear_terminal
    puts 'translator'
end

def show_setup
    clear_terminal
    puts '------------------- Setup -------------------'
    puts 'Get your token in https://translate.yandex.com/developers/keys and puts below:'
    print 'Token: '
    token = gets.chomp.to_i
end

while @option != 0
    case @option
        when 1
            show_home
        when 2
            show_translator
            @option = 1
        when 3
            show_setup
            @option = 1
        else
            puts 'invalid option '
            @option = 1
    end
end

puts 'Exit system'