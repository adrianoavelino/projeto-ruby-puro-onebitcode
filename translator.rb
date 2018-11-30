require 'rest-client'
require 'json'

class Translator
    # def initialize

    # end

    attr_accessor :text, :text_translated, :language_original, :language_translated

    def get_url_languages
        'https://translate.yandex.net/api/v1.5/tr.json/getLangs?ui=en&key=' + get_token
    end

    def get_languages_origem_text 
        json = RestClient.post get_url_languages, {}
        abbreviations_countries = JSON.parse(json)['dirs']
        languages = JSON.parse(json)['langs']

        abbreviations_countries_availables = Hash.new

        abbreviations_countries.select do |value|
            country = value[0..1]
            abbreviations_countries_availables[country] = languages[country]
        end
        abbreviations_countries_availables
    end

    def get_languages_text_translated(abbreviation_language_text)
        langsOK = []
        json = RestClient.post get_url_languages, {}
        languages = JSON.parse(json)['langs']
        abbreviations_countries = JSON.parse(json)['dirs']
        match = Regexp.new('^'+ abbreviation_language_text)
        langsOK = abbreviations_countries.select do |val|
            match =~ val
        end
        destinos = languages.select do |key, val|
            langsOK.include?(abbreviation_language_text + "-#{key}")
        end
        destinos
    end

    def get_url_translator(abbreviation_country_dash_abbreviation_another_country)
        'https://translate.yandex.net/api/v1.5/tr.json/translate?lang='+ abbreviation_country_dash_abbreviation_another_country +'&key=' + get_token
    end

    def get_token
        token = File.open('./.token', &:readline)
        # tweets = IO.readlines('./.token')

    end

    def translator(text)
        text_translated = RestClient.post get_url_translator, {text: typed_text}
    end
end

