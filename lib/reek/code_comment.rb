require 'yaml'
require 'private_attr/everywhere'

module Reek
  #
  # A comment header from an abstract syntax tree; found directly above
  # module, class and method definitions.
  #
  # @api private
  class CodeComment
    CONFIG_REGEX = /:reek:(\w+)(:\s*\{.*?\})?/

    def initialize(text)
      @config = Hash.new { |hash, key| hash[key] = {} }
      @text = text.gsub(CONFIG_REGEX) do
        @config.merge! add_to_config($1, $2)
        ''
      end.gsub(/#/, '').gsub(/\n/, '').strip
    end

    attr_reader :config

    def descriptive?
      text.split(/\s+/).length >= 2
    end

    private

    def add_to_config(smell, options)
      options ||= ': { enabled: false }'
      YAML.load(smell.gsub(/(?:^|_)(.)/) { $1.upcase } + options)
    end

    private_attr_reader :text
  end
end
