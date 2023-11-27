require 'net/http'
require 'json'

# Method to convert country code to flag emoji
def country_code_to_flag_emoji(country_code)
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
    'ip_address' => 'IP Address',
    'isp' => 'ISP',
    'country' => 'Country',
    'region' => 'Region',
    'city' => 'City',
  },
  'fr' => {
    'ip_address' => 'Adresse IP',
    'isp' => 'FAI',
    'country' => 'Pays',
    'region' => 'Région',
    'city' => 'Ville',
  },
  'es' => {
    'ip_address' => 'Dirección IP',
    'isp' => 'Proveedor de Servicios de Internet',
    'country' => 'País',
    'region' => 'Región',
    'city' => 'Ciudad',
  },
  'ru' => {
    'ip_address' => 'IP-адрес',
    'isp' => 'Интернет-провайдер',
    'country' => 'Страна',
    'region' => 'Регион',
    'city' => 'Город',
  },
  'ar' => {
    'ip_address' => 'عنوان الآي بي',
    'isp' => 'مزود الخدمة',
    'country' => 'البلد',
    'region' => 'المنطقة',
    'city' => 'المدينة',
  },
  'zh' => {
    'ip_address' => 'IP地址',
    'isp' => '互联网服务提供商',
    'country' => '国家',
    'region' => '地区',
    'city' => '城市',
  },
}

# Obtaining external IP address
uri_ip = URI('https://httpbin.org/ip')
external_ip = JSON.parse(Net::HTTP.get(uri_ip))['origin']

# Obtaining IP details
uri_details = URI("http://ip-api.com/json/#{external_ip}")
ip_details = JSON.parse(Net::HTTP.get(uri_details))

# Determine the language
language = country_to_language[ip_details['countryCode']] || 'en'
texts = translations[language]

# Print the results
puts "#{texts['ip_address']}: #{external_ip}"
puts "#{texts['isp']}: #{ip_details['isp']}"
puts "#{texts['country']}: #{ip_details['country']} #{country_code_to_flag_emoji(ip_details['countryCode'])}"
puts "#{texts['region']}: #{ip_details['regionName']}"
puts "#{texts['city']}: #{ip_details['city']}"
# frozen_string_literal: true

