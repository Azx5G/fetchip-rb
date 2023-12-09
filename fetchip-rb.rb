# FetchIP-RB
# Copyright (c) 2023 Azx5G
# Licensed under the AGPL-3.0 License

require 'net/http'
require 'json'
require 'socket'
require 'rbconfig'
require_relative 'translations'
require_relative 'countriesnativename'


# Method to convert country code to flag emoji
def country_code_to_flag_emoji(country_code)
  return '' if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/


  base = 127397
  country_code.upcase.each_codepoint.map { |c| (base + c).chr(Encoding::UTF_8) }.join
end

begin
  # Obtaining external IP address
  uri_ip = URI('https://httpbin.org/ip')
  external_ip_response = Net::HTTP.get_response(uri_ip)
  uri_ipv6 = URI('https://ifconfig.me/ip')
  external_ipv6_response = Net::HTTP.get_response(uri_ipv6)

  if external_ipv6_response.is_a?(Net::HTTPSuccess)
    external_ipv6 = external_ipv6_response.body
  end

  if external_ip_response.is_a?(Net::HTTPSuccess)
    external_ip = JSON.parse(external_ip_response.body)['origin']
    if external_ipv6 == external_ip
      external_ipv6 = "N/A"
    end

    # Obtaining IP details
    if external_ipv6 == "N/A"
      uri_details = URI("http://ip-api.com/json/#{external_ip}")
    else
      uri_details = URI("http://ip-api.com/json/#{external_ipv6}")
    end
    ip_details_response = Net::HTTP.get_response(uri_details)

    if ip_details_response.is_a?(Net::HTTPSuccess)
      ip_details = JSON.parse(ip_details_response.body)

      # Determine the language
      language = country_to_language[ip_details['countryCode']] || 'en'
      texts = translations[language]
      # Determine Linux distro
      if File.exist?("/etc/os-release")
        os_release_info = File.read("/etc/os-release")
        distro_name = os_release_info.match(/^PRETTY_NAME="(.+)"$/)&.captures&.first
      else
        distro_name = 'Unknown Version'
      end
      # Determine the OS and the version
      os = RbConfig::CONFIG['host_os']
      case os
      when /mswin|mingw|cygwin/
        os_version = `wmic os get Caption`.split("\n")[2].strip
      when /darwin|mac os/
        os_version = "macOS #{`sw_vers -productVersion`.strip}"
      when /linux/
        os_version = distro_name
      else
        os_version = 'Unknown Version'
      end

      # Determine local IP
      local_ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
      local_ip_address = local_ip ? local_ip.ip_address : 'Not Available'

      # Show Commercial OS name

      def get_os_name(os, os_version)
        case os
        when /mswin|mingw|cygwin/
          "Windows"
        when /darwin|mac os/
          os_version = `sw_vers -productVersion`.strip
          "macOS"
        when /linux/
          "Linux"
        else
          "Unknown OS"
        end
      end
      os_name = get_os_name(os, '')
      country_names = create_country_name_mapping
      native_country_name = get_country_name_in_native_language(ip_details['country'], country_names)
      # Print the results
      puts "#{texts['ipv4_address']}: #{external_ip}"
      puts "#{texts['ipv6_address']}: #{external_ipv6}"
      puts "#{texts['local_ip']}: #{local_ip_address}"
      puts "#{texts['isp']}: #{ip_details['isp']}"
      puts "#{texts['country']}: #{native_country_name} #{country_code_to_flag_emoji(ip_details['countryCode'])}"
      puts "#{texts['region']}: #{ip_details['regionName']}"
      puts "#{texts['city']}: #{ip_details['city']}"
      puts "#{texts['os']}: #{os_name}"
      puts "#{texts['version']}: #{os_version}"

    else
      raise "Error fetching IP details: #{ip_details_response.code}"
    end
  else
    raise "Error fetching external IP: #{external_ip_response.code}"
  end
rescue SocketError => e
  puts "Network error: #{e}"
  if File.exist?("/etc/os-release")
    os_release_info = File.read("/etc/os-release")
    distro_name = os_release_info.match(/^PRETTY_NAME="(.+)"$/)&.captures&.first
  else
    distro_name = 'Unknown Version'
  end
  # Determine the OS and the version
  os = RbConfig::CONFIG['host_os']
  case os
  when /mswin|mingw|cygwin/
    os_version = `wmic os get Caption`.split("\n")[2].strip
  when /darwin|mac os/
    os_version = "macOS #{`sw_vers -productVersion`.strip}"
  when /linux/
    os_version = distro_name
  else
    os_version = 'Unknown Version'
  end
  def get_os_name(os, os_version)
    case os
    when /mswin|mingw|cygwin/
      "Windows"
    when /darwin|mac os/
      os_version = `sw_vers -productVersion`.strip
      "macOS"
    when /linux/
      "Linux"
    else
      "Unknown OS"
    end
  end
  os_name = get_os_name(os, '')
  puts "Operating System: #{os_name}"
  puts "OS Version: #{os_version}"
  puts "This program got an network error. Please check your internet connection. If you think this is a bug, please take a screenshot of the terminal window and report it at https://github.com/Azx5G/FetchIP-RB/issues"
rescue StandardError => e
  puts "An error occurred: #{e}"
  puts "This program got a general error. Please take a screenshot of the terminal window and report it at https://github.com/Azx5G/FetchIP-RB/issues"
end
# frozen_string_literal: true
