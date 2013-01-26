# == Definition: chromedriver
#
# Download and install chromedriver (WebDriver for Google Chrome)
#
# Parameters:
#
# - *$target_directory: Directory to install chromedriver into (default: '/usr/local/bin')
#
# Example usage:
#
# class { 'chromedriver':
# 	target_directory => '/opt'
# }
class chromedriver (
  $ensure = present,
  $target_directory = '/usr/local/bin') {

  $source_file = 'chromedriver_linux32_23.0.1240.0.zip'
  $source_url = "https://chromedriver.googlecode.com/files/${source_file}"
  $exec_name = 'chromedriver'
  $target_file = "${target_directory}/${exec_name}"
  
  archive { $source_file:
    ensure => $ensure,
    url => $source_url,
    digest_string => '988e47718972f650c96dc46f4ea1f5b4ed94f06f',
    digest_type => 'sha1',
    target => $target_directory,
    root_dir => $exec_name,
    extension => 'zip'
  }
  
  file { $target_file:
     ensure => $ensure,
     mode => 755,
     require => Archive[$source_file]
  }
}

