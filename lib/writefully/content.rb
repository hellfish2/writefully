module Writefully
  class Content
    attr_reader :index, :path
    attr_accessor :body

    def initialize(index)
      @index = index
      @path = File.join(Writefully.options[:content], index[:site], index[:resource], index[:slug])
    end

    def body
      Dir.chdir(path) { File.open(Dir['README.*'].first).read }
    end

    def meta
      YAML.load(File.read(File.join(path, "meta.yml"))).merge({ "position" => position })
    end

    def details
      Hashie::Mash.new(meta["details"])
    end

    def slug
      index[:slug].split(/\A\d*-/).last
    end

    def position
      index[:slug].match(/\A\d*/).to_s.to_i
    end
  end
end 