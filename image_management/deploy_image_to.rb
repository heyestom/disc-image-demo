require_relative 'digital_ocean_utils'

digital_ocean_utils = DigitalOceanUtils.new(ENV['DIGITALOCEAN_CLIENT_ID'], ENV['DIGITALOCEAN_API_KEY'])

application_name = ENV['APPLICATION_NAME']
build_number = ENV['SNAP_PIPELINE_COUNTER']
commit_sha = ENV['SNAP_COMMIT_SHORT']
environment = ARGV[0].upcase

DROPLET_NAME = "#{environment}-#{application_name}"
image_name_for_this_build = "#{application_name}-#{build_number}.#{commit_sha}"


ip_address = digital_ocean_utils.create_or_rebuild_droplet DROPLET_NAME, image_name_for_this_build


puts "Waiting for app to be running on: #{ip_address}"
# digital_ocean_utils.wait_until_app_is_running ip_address
# puts 'Application ready'


#
# def wait_until_app_is_running(ip_address)
#   wait_until_status_200(ip_address)
# end
#
# def wait_until_status_200(ip_address)
#   ten_minutes_in_seconds = 600
#   wait_time = 0
#   wait_increment_in_seconds = 1
#
#   while true
#     if get_response_code(ip_address) < 400
#       break
#     else
#       sleep(wait_increment_in_seconds)
#       wait_time += wait_increment_in_seconds
#       raise('The app was not active after waiting for 10 minutes') if wait_time > ten_minutes_in_seconds
#     end
#   end
# end
#
# def get_response_code(ip_address)
#   uri = URI.parse("http://#{ip_address}")
#
#   begin
#     Net::HTTP.get_response(uri).code.to_i
#   rescue StandardError
#     500
#   end
# end

# def ssh_is_available_on(ip_address)
#   `ssh -q root@#{ip_address} exit; echo $?`.to_i == 0
# end



