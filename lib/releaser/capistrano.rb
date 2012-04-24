unless Capistrano::Configuration.respond_to?(:instance)
  abort "Soprano requires Capistrano 2"
end

Capistrano::Configuration.instance(:must_exist).load do
  Dir["#{File.dirname(__FILE__)}/capistrano/*.rb"].each do |recipe|
    load(recipe)
  end
end
