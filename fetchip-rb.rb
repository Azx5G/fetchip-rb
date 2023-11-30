# FetchIP-RB
# Copyright (c) 2023 Azx5G
# Licensed under the AGPL-3.0 License

require 'net/http'
require 'json'
require 'socket'
require 'rbconfig'

# Method to convert country code to flag emoji
def country_code_to_flag_emoji(country_code)
  return '' if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/


  base = 127397
  country_code.upcase.each_codepoint.map { |c| (base + c).chr(Encoding::UTF_8) }.join
end

# Table to map country code to language
country_to_language = {
  # English
  'AG' => 'en', 'AI' => 'en', 'AQ' => 'en', 'AS' => 'en', 'AU' => 'en',
  'BB' => 'en', 'BD' => 'en', 'BM' => 'en', 'BS' => 'en', 'BW' => 'en',
  'BZ' => 'en', 'CA' => 'en', 'CC' => 'en', 'CK' => 'en', 'CM' => 'en',
  'CX' => 'en', 'CY' => 'en', 'DM' => 'en', 'ER' => 'en', 'FJ' => 'en',
  'FK' => 'en', 'FM' => 'en', 'GB' => 'en', 'GD' => 'en', 'GG' => 'en',
  'GH' => 'en', 'GI' => 'en', 'GM' => 'en', 'GU' => 'en', 'GY' => 'en',
  'HK' => 'en', 'IE' => 'en', 'IM' => 'en', 'IN' => 'en', 'IO' => 'en',
  'JE' => 'en', 'JM' => 'en', 'KE' => 'en', 'KI' => 'en', 'KN' => 'en',
  'KY' => 'en', 'LC' => 'en', 'LR' => 'en', 'LS' => 'en', 'MH' => 'en',
  'MP' => 'en', 'MS' => 'en', 'MT' => 'en', 'MU' => 'en', 'MV' => 'en',
  'MW' => 'en', 'MY' => 'en', 'NA' => 'en', 'NF' => 'en', 'NG' => 'en',
  'NR' => 'en', 'NU' => 'en', 'NZ' => 'en', 'PG' => 'en', 'PH' => 'en',
  'PK' => 'en', 'PN' => 'en', 'PR' => 'en', 'PW' => 'en', 'RW' => 'en',
  'SB' => 'en', 'SC' => 'en', 'SG' => 'en', 'SH' => 'en',
  'SL' => 'en', 'SS' => 'en', 'SX' => 'en', 'SZ' => 'en', 'TC' => 'en',
  'TK' => 'en', 'TO' => 'en', 'TT' => 'en', 'TV' => 'en', 'TZ' => 'en',
  'UG' => 'en', 'UM' => 'en', 'US' => 'en', 'VC' => 'en', 'VG' => 'en',
  'VI' => 'en', 'VU' => 'en', 'WS' => 'en', 'ZA' => 'en', 'ZM' => 'en',
  'ZW' => 'en',

  # French
  'FR' => 'fr', 'MC' => 'fr', 'BJ' => 'fr', 'BF' => 'fr', 'CD' => 'fr', 'CG' => 'fr', 'CI' => 'fr',
  'GA' => 'fr', 'GN' => 'fr', 'ML' => 'fr', 'NE' => 'fr', 'SN' => 'fr', 'TG' => 'fr', 'BE' => 'fr',
  'LU' => 'fr', 'CH' => 'fr', 'BI' => 'fr', 'KM' => 'fr', 'DJ' => 'fr',
  'MG' => 'fr', 'CF' => 'fr', 'TD' => 'fr', 'HT' => 'fr',

  # Spanish
  'AR' => 'es', 'BO' => 'es', 'CL' => 'es', 'CO' => 'es', 'CR' => 'es', 'CU' => 'es', 'EC' => 'es',
  'ES' => 'es', 'GT' => 'es', 'GQ' => 'es', 'HN' => 'es', 'MX' => 'es', 'NI' => 'es', 'PA' => 'es',
  'PY' => 'es', 'PE' => 'es', 'DO' => 'es', 'SV' => 'es', 'UY' => 'es', 'VE' => 'es',

  # Russian
  'RU' => 'ru', 'BY' => 'ru', 'KZ' => 'ru', 'KG' => 'ru',

  # Arabic
  'SA' => 'ar', 'BH' => 'ar', 'AE' => 'ar', 'IQ' => 'ar', 'JO' => 'ar', 'KW' => 'ar', 'LB' => 'ar',
  'OM' => 'ar', 'PS' => 'ar', 'QA' => 'ar', 'YE' => 'ar', 'DZ' => 'ar', 'EG' => 'ar', 'LY' => 'ar',
  'MA' => 'ar', 'MR' => 'ar', 'SD' => 'ar', 'TN' => 'ar',

  # Chinese
  'CN' => 'zh', 'TW' => 'zh',
}

# Translations
translations = {
  'en' => {
    'ipv4_address' => 'IPv4 Address',
    'ipv6_address' => 'IPv6 Address',
    'isp' => 'ISP',
    'country' => 'Country',
    'region' => 'Region',
    'city' => 'City',
    'os' => 'Operating System',
    'version' => 'OS Version',
    'local_ip' => 'Local IP',
  },
  'fr' => {
    'ipv4_address' => 'Adresse IPv4',
    'ipv6_address' => 'Adresse IPv6',
    'isp' => 'FAI',
    'country' => 'Pays',
    'region' => 'Région',
    'city' => 'Ville',
    'os' => 'Système d’exploitation',
    'version' => 'Version OS',
    'local_ip' => 'IP Locale',
  },
  'es' => {
    'ipv4_address' => 'Dirección IPv4',
    'ipv6_address' => 'Dirección IPv6',
    'isp' => 'Proveedor de Servicios de Internet',
    'country' => 'País',
    'region' => 'Región',
    'city' => 'Ciudad',
    'os' => 'Sistema Operativo',
    'version' => 'Versión del SO',
    'local_ip' => 'IP Local',
  },
  'ru' => {
    'ipv4_address' => 'IPv4-адрес',
    'ipv6_address' => 'IPv6-адрес',
    'isp' => 'Интернет-провайдер',
    'country' => 'Страна',
    'region' => 'Регион',
    'city' => 'Город',
    'os' => 'Операционная Система',
    'version' => 'Версия ОС',
    'local_ip' => 'Локальный IP',
  },
  'ar' => {
    'ipv4_address' => 'عنوان آي بي في 4',
    'ipv6_address' => 'عنوان آي بي في 6',
    'isp' => 'مزود الخدمة',
    'country' => 'البلد',
    'region' => 'المنطقة',
    'city' => 'المدينة',
    'os' => 'نظام التشغيل',
    'version' => 'إصدار النظام',
    'local_ip' => 'الآي بي المحلي',

  },
  'zh' => {
    'ipv4_address' => 'IPv4地址',
    'ipv6_address' => 'IPv6地址',
    'isp' => '互联网服务提供商',
    'country' => '国家',
    'region' => '地区',
    'city' => '城市',
    'os' => '操作系统',
    'version' => '操作系统版本',
    'local_ip' => '本地IP',
  },
}

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

      # Determine the OS and the version
      os = RbConfig::CONFIG['host_os']
      case os
      when /mswin|mingw|cygwin/
        os_version = `ver`.strip
      when /darwin|mac os/
        os_version = `sw_vers -productVersion`.strip
      when /linux/
        os_version = `uname -r`.strip
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
      # Print the results
      puts "#{texts['ipv4_address']}: #{external_ip}"
      puts "#{texts['ipv6_address']}: #{external_ipv6}"
      puts "#{texts['local_ip']}: #{local_ip_address}"
      puts "#{texts['isp']}: #{ip_details['isp']}"
      puts "#{texts['country']}: #{ip_details['country']} #{country_code_to_flag_emoji(ip_details['countryCode'])}"
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
rescue StandardError => e
  puts "An error occurred: #{e}"
end
# frozen_string_literal: true


