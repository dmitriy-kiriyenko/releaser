require 'ostruct'

module Releaser
  class Revision < OpenStruct
    def initialize(duck)
      super(duck.is_a?(String) ? parse_string(duck) : duck)
      raise ArgumentError.new("Version should at least contain major part, but given: #{duck.inspect}") unless valid?
    end

    def valid?
      !!major
    end

    def to_s
      append_codename(version_string, " ")
    end

    def to_tagline
      append_codename(version_string, "-")
    end

    def to_deploy_tagline
      version_string
    end

    def current?
      build == 0
    end

    def next_major(codename = nil)
      self.class.new(@table.merge(:build => 0, :minor => 0, :codename => codename).tap {|hsh| hsh[:major] += 1})
    end
    alias_method :new_major, :next_major

    def next_minor
      self.class.new(@table.merge(:build => 0).tap {|hsh| hsh[:minor] += 1})
    end
    alias_method :new_minor, :next_minor

    protected

    def version_string(prefix = "v")
      "#{prefix}#{[major, minor, build == 0 ? nil : build].compact.join(".")}"
    end

    def parse_string(str)
      major, minor, codename, build, sha = *str.match(/^v(?:(\d+)(?:\.(\d+))?)(?:.\d+)?(?:-(.*))?(?:-(\d+))(?:-(.*))$/).captures
      { :major => major.to_i, :minor => minor.to_i, :codename => codename, :build => build.to_i, :sha => sha }
    end

    def append_codename(str, separator = "")
      [str, codename].compact.join(separator)
    end

  end
end
