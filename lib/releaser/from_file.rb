module Releaser
  class FromFile
    attr_accessor :name

    def initialize(file_name = File.join(Rails.root, "CURRENT_VERSION"))
      self.name = file_name
    end

    def version(default = "development")
      if exists?
        from_file
      else
        default
      end
    end

    protected

    def from_file
      `cat #{name}`
    end

    def exists?
      File.exists?(name)
    end
  end
end
