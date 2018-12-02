require 'tty-prompt'
require_relative 'translator'
require_relative 'save_translation'
require_relative 'token'

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
    puts '---------------------- Translator ----------------------'
    translator = Translator.new
    translator.language_original = @prompt.select("Select text language:", filter: true) do |menu|
        translator.get_languages_origem_text.each do |key, val|
            menu.choice "#{val}", key
        end    
    end
    
    translator.language_translated = @prompt.select("Select translated text language:", filter: true) do |menu|
        translator.get_languages_text_translated(translator.language_original).each do |key, val|
            menu.choice "#{val}", key
        end    
    end
    
    language_origem_destiny = translator.language_original + '-' + translator.language_translated
    translator.translation_direction = language_origem_destiny
    
    print 'Put your text: '
    translator.text = gets.chomp
    
    translator.text_translated = translator.translator(translator.text)
    puts 'Translated text: ' + translator.text_translated.first
    
    SaveTranslation.new(translator).save

    puts '--------------------------------------------------------'
    choice = @prompt.yes?('Would you like translating again?') do |q|
        q.default 'y'
        q.positive 'y'
        q.negative 'n'
    end
    @option = (choice and choice != nil)? 2: 1
end

def show_setup
    clear_terminal
    puts '------------------- Setup -------------------'
    puts 'Get your token in https://translate.yandex.com/developers/keys and puts below:'
    print 'Token: '
    token = gets.chomp
    if Token.new().validate_token(token)
        Token.new().create_token(token)
        @option = 1
    else
        puts 'Invalid Token!'
        choice = @prompt.yes?('Would you like inserting another token') do |q|
            q.default 'y'
            q.positive 'y'
            q.negative 'n'
        end
        @option = (choice)? 3: 1
    end

end

while @option != 0
    case @option
        when 1
            show_home
        when 2
            clear_terminal
            if (!File.exist?('./.token')) 
                choice = @prompt.yes?('You didn\'t create the token! Would you like inserting one?') do |q|
                    q.default 'y'
                    q.positive 'y'
                    q.negative 'n'
                end                
                @option = (choice)? 3: 1
            else
                show_translator
            end
        when 3
            show_setup
        else
            puts 'invalid option '
            @option = 1
    end
end
clear_terminal
