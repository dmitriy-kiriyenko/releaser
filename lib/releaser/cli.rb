require 'thor'
require 'active_support/core_ext/object/blank'
require 'rails/generators/actions'

class AlreadyReleasedError < StandardError
end

module Releaser
  class CLI < ::Thor
    include Thor::Actions
    include Rails::Generators::Actions
    add_runtime_options!
    class_option :message, :type => :string, :aliases => "-m", :desc => "Specify a tag message (-m option for git tag)"
    class_option :object, :type => :string, :aliases => "-o", :desc => "Specify a tag object (which commit to tag with version)"
    class_option :push, :type => :boolean, :default => true, :desc => "Whether to push the commit (provide --no-push to override)"
    default_task :info

    desc "major [CODENAME]", "Issue a major release"
    def major(codename = "")
      new_version = version_from_tag_to_release.new_major(codename)
      message = options.message.presence || "Major release: #{new_version}"
      tag(new_version.to_tagline, :message => message)
    end

    desc "minor", "Issue a minor release"
    def minor
      new_version = version_from_tag_to_release.new_minor
      message = options.message.presence || "Minor release: #{new_version}"
      tag(new_version.to_tagline, :message => message)
    end

    desc "deploy", "Tag current commit for a deploy"
    def deploy
      tag(version_from_tag_to_release.to_deploy_tagline, :force => true)
    rescue AlreadyReleasedError
      # no actions required
    end

    desc "info", "Get current version"
    method_option :verbose, :type => :boolean, :default => false, :aliases => "-v"
    def info
      version = version_from_tag

      unless options.verbose?
        say version
      else
        log :current_version, version
        log :next_major, version.next_major("[CODENAME]")
        log :next_minor, version.next_minor
      end
    end

    protected

    def version_from_tag_to_release
      version_from_tag.tap { |v| raise AlreadyReleasedError.new(v.to_s) if v.current? }
    end

    def version_from_tag
      tagline = `git describe --match \"v[0-9]*\" --long`.chomp
      Revision.new(tagline)
    end

    def tag(tag, config = {})
      tag_options = [].tap do |opts|
        opts.push "-m \"#{config[:message]}\"" if config[:message]
        opts.push "-f" if config[:force]
      end

      run "git tag #{tag_options.join(" ")} -- #{tag} #{options.object}"
      run "git push origin #{tag}" if options.push?
    end

  end
end
