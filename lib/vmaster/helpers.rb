module VirtualMaster

  CONFIG_FILE = ".virtualmaster"
  DEFAULT_URL = "https://www.virtualmaster.com/virtualmaster/services/deltacloud"

  DEFAULT_IMAGE = 2664
  DEFAULT_PROFILE = "micro"

  # pre-defined list of images
  IMAGES = {
    :ubuntu_precise => 2664,
    :ubuntu_lucid => 2818,
    :debian_squeeze => 2808,
    :centos_6 => 2818,
    :centos_5 => 2804,
    :archlinux => 2668
  }

  PROFILES = {
    :nano => {
      :memory => 256,
      :storage => 3840
    },
    :micro => {
      :memory => 512,
      :storage => 10240,
    },
    :milli => {
      :memory => 1024,
      :storage => 20480,
    },
    :small => {
      :memory => 2048,
      :storage => 30720,
    },
    :medium => {
      :memory => 4096,
      :storage => 40960,
    },
    :large => {
      :memory => 7000,
      :storage => 20480,
    }
  }

  module Helpers
    def self.get_instances
      VirtualMaster::CLI.api.instances
    end

    def self.get_instance(name)
      get_instances.each do |instance|
        return instance if instance.name == name
      end

      nil
    end

    def self.get_hw_profile(memory, storage)
      api = VirtualMaster::CLI.api

      profile_list = api.hardware_profiles.select { |p| p.memory.value.to_i == memory && p.storage.value.to_i == storage }

      profile_list.first
    end

    def self.create_instance(name, image_id, profile, realm)
      api = VirtualMaster::CLI.api

      api.create_instance(image_id, {:name => name, :hwp_id => 'default', :memory => profile[:memory], :storage => profile[:storage], :realm_id => realm})
    end
  end
end
