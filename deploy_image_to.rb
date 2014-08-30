require 'digital_ocean'
require 'net/http'
require 'uri'

environment = ARGV[0].upcase
application_name = ENV['APPLICATION_NAME']
build_number = ARGV[2]
commit_sha = ARGV[3]

DROPLET_NAME = "#{environment}-#{application_name}"
image_name_for_this_pipeline = "#{application_name}-#{build_number}.#{commit_sha}"

initialize_digital_ocean_client
create_or_rebuild_droplet DROPLET_NAME, image_name_for_this_pipeline




def initialize_digital_ocean_client
  @digital_ocean_client = DigitalOcean::API.new :client_id => ENV['DIGITALOCEAN_CLIENT_ID'],
                        :api_key =>   ENV['DIGITALOCEAN_API_KEY'],
                        :debug => false
end

def create_or_rebuild_droplet(droplet_name, image_name)

  image_id = image_id_for image_name

  if droplet_exists? droplet_name
    puts "Rebuilding from image #{image_name}"
    droplet_id = rebuild_droplet_from droplet_name, image_id

    puts 'Waiting for droplet to shut down...'
    wait_until_droplet_is 'off', droplet_id
    puts 'Droplet shut down successfully'

  else
    puts "Rebuilding from image #{image_name}"
    create_new_droplet droplet_name, image_id
    puts 'Waiting for new droplet...'
  end

  puts 'Retrieving droplet IP Address'
  ip_address = droplet_ip_address droplet_name

  puts 'Waiting for app to be running'
  #TODO wait_until_app_is_running ip_address
  puts 'Application ready'
end

def create_new_droplet(name, image_id, ssh_keys=[])
  new_york_2 = 4
  smallest_box_512 = 66

  response = @digital_ocean_client.droplets.create({name: name, size_id: smallest_box_512, image_id: image_id, region_id: new_york_2, ssh_key_ids: ssh_keys})
  response.droplet.id
end

def rebuild_droplet_from(droplet_name, image_id)
  droplet_id = @digital_ocean_client.droplets.list.droplets.select { |droplet| droplet.name == droplet_name }.first.id
  @digital_ocean_client.droplets.rebuild(droplet_id, :image_id => image_id)
  droplet_id
end

def droplet_exists?(droplet_name)
  return @digital_ocean_client.droplets.list.droplets.any? { |droplet| droplet.name == droplet_name }
end

def wait_until_droplet_is(status, droplet_id)
  sleep(1) until @digital_ocean_client.droplets.show(droplet_id).droplet.status == status
end

def wait_until_app_is_running(ip_address)
  wait_until_status_200(ip_address)
end

def wait_until_status_200(ip_address)
  ten_minutes_in_seconds = 600
  wait_time = 0
  wait_increment_in_seconds = 1

  while true
    if get_response_code(ip_address) < 400
      break
    else
      sleep(wait_increment_in_seconds)
      wait_time += wait_increment_in_seconds
      raise('The app was not active after waiting for 10 minutes') if wait_time > ten_minutes_in_seconds
    end
  end
end

def get_response_code(ip_address)
  uri = URI.parse("http://#{ip_address}")

  begin
    Net::HTTP.get_response(uri).code.to_i
  rescue StandardError
    500
  end
end

def droplet_ip_address(droplet_name)
  @digital_ocean_client.droplets.list.droplets.select { |droplet| droplet.name == droplet_name }.first.ip_address
end

def image_id_for(image_name)
  @digital_ocean_client.images.list.images.select { |image| image.name == image_name }.first.id
end

def ssh_is_available_on(ip_address)
  `ssh -q root@#{ip_address} exit; echo $?`.to_i == 0
end