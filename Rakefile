require 'json'
require 'yaml'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks'

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end


desc 'Release task for running on Travis CI'
task :travis_release => [ :validate, :clean, :build ] do

  target_version = ENV['TRAVIS_TAG']
  if target_version.nil? or target_version.empty?
    puts 'Not a build for a tag, not doing a release'
    exit
  end

  unless ENV['MAIN_ENV'] == 'y'
    puts 'Skipping release process because this is not the main environment.'
    exit
  end

  metadata = JSON.parse(File.read('metadata.json'))
  if metadata['version'] != target_version
    fail 'Version in metadata.json does not match current tag.'
  end

  # Create a puppet-blacksmith configuration file with credentials.
  # This code will become unnecessary from the next release of puppet-blacksmith.
  forge_settings = {
    'url' => ENV['BLACKSMITH_FORGE_URL'],
    'username' => ENV['BLACKSMITH_FORGE_USERNAME'],
    'password' => ENV['BLACKSMITH_FORGE_PASSWORD'],
  }
  target_file = File.expand_path('~/.puppetforge.yml')
  File.open(target_file, 'w') do |fh|
    YAML.dump(forge_settings, fh)
  end

  Rake::Task['module:push'].invoke

end
