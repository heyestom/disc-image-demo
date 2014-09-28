require_relative 'digital_ocean_utils'

digital_ocean_utils = DigitalOceanUtils.new(ENV['DIGITAL_OCEAN_CLIENT_ID'], ENV['DIGITAL_OCEAN_API_KEY'])

application_name = ENV['APPLICATION_NAME']
build_number = ENV['SNAP_PIPELINE_COUNTER']
commit_sha = ENV['SNAP_COMMIT_SHORT']
ssh_keys = ENV['AUTHORIZED_USERS'].split(',')

puts "SSH Keys: #{ssh_keys}"
environment = ARGV[0].upcase

DROPLET_NAME = "#{environment}-#{application_name}"
image_name_for_this_build = "#{application_name}-#{build_number}.#{commit_sha}"


ip_address = digital_ocean_utils.create_or_rebuild_droplet DROPLET_NAME, image_name_for_this_build, ssh_keys


puts "Machine is reachable on: #{ip_address}"
