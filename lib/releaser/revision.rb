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
      append_codename(version_string, ' ')
    end

    def to_tagline
      append_codename(version_string, '-')
    end

    def to_deploy_tagline
      version_string
    end

    def current?
      build == 0
    end

    def next_major(codename = nil)
      options = { minor: 0, patch: 0, build: 0, codename: codename }
      self.class.new(@table.merge(options).tap { |h| h[:major] += 1 })
    end
    alias_method :new_major, :next_major

    def next_minor
      options = { patch: 0, build: 0 }
      self.class.new(@table.merge(options).tap { |h| h[:minor] += 1 })
    end
    alias_method :new_minor, :next_minor

    def next_patch
      self.class.new(@table.merge(build: 0).tap { |h| h[:patch] += 1 })
    end
    alias_method :new_patch, :next_patch

    protected

    def version_string(prefix = 'v')
      [
        prefix,
        [major, minor, patch, build == 0 ? nil : build].compact.join('.')
      ].join
    end

    def parse_string(str)
      regexp =
        /^v(\d+)(?:\.(\d+))?(?:\.(\d+))?(?:-(\w+))?(?:-(\d+))(?:-([a-z0-9]+))$/
      major, minor, patch, codename, build, sha = *str.match(regexp).captures
      { major: major.to_i,
        minor: minor.to_i,
        patch: patch.to_i,
        codename: codename,
        build: build.to_i,
        sha: sha }
    end

    def append_codename(str, separator = "")
      [str, codename].compact.join(separator)
    end
  end
end
