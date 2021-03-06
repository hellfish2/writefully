require 'base64'

module Writefully
  module Source

    class << self
      def content_path
        Writefully.options[:content]
      end

      def models_path
        File.join(Writefully.options[:app_directory], 'app', 'models')
      end

      def sample_content file
        open(File.dirname(__FILE__) + "/../sample/#{file}").read
      end

      def sample_content_paths 
        valid_resources.map do |resource|
          ["#{resource}/1-change-me/README.md", 
           "#{resource}/1-change-me/meta.yml", 
           "#{resource}/1-change-me/assets/writefully.png"]
        end.flatten
      end

      def sample_content_properties file
        { 
          path: file,
          content: sample_content(file),
          message: "added sample #{file}"
        }
      end

      def valid_resources
        skim_for(::Regexp.new('Writefully::Post')).map { |r| r.pluralize }
      end

      def to_load
        skim_for ::Regexp.new('Writefully')
      end

      def skim_for matcher
        Dir.chdir(models_path) do 
          Dir.glob('*').select do |file|
            open(File.join(models_path, file)).read.strip.match(matcher) if File.file?(file)
          end.collect { |file| file.split('.')[0] }
        end
      end
    end
  end
end