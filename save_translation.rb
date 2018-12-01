class SaveTranslation

    def initialize(translator)
        @translator = translator
    end

    def save
        time = Time.now
        file_log_name = time.strftime('%d%m%Y-%H%M%S') + '.txt'

        File.open('./logs/' + file_log_name, 'w') do |line|
            text = 'Text: ' + @translator.text
            text_translated = 'Text translated: ' + @translator.text_translated[0]
            line.puts(text)
            line.puts(text_translated)
        end
    end
end
