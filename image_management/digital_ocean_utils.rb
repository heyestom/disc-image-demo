require 'digital_ocean'
require 'net/http'
require 'uri'

class DigitalOceanUtils
  def initialize(client_id, api_key)
    @digital_ocean_client = DigitalOcean::API.new :client_id => client_id,
                                                  :api_key =>   api_key,
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
    droplet_ip_address droplet_name
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


  def droplet_ip_address(droplet_name)
    @digital_ocean_client.droplets.list.droplets.select { |droplet| droplet.name == droplet_name }.first.ip_address
  end

  def image_id_for(image_name)
    @digital_ocean_client.images.list.images.select { |image| image.name == image_name }.first.id
  end
end