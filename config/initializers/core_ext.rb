# Loads within the Rails app all the files from lib/core_ext directory
Dir[File.join(Rails.root, 'lib', 'core_ext', '*.rb')].each { |file| require file }
