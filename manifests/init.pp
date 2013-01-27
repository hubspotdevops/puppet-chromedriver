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
  $version = latest,
  $target_directory = '/usr/local/bin') {

  $ensure = $version? {
    absent => absent,
    default => present
  }
  $version_hashes = {
    '23.0.1240.0' => '988e47718972f650c96dc46f4ea1f5b4ed94f06f',
    '26.0.1383.0' => '061bb440039e2a21a816c3d10c3dce3e8543a08a'
  }
  $latest_version = '26.0.1383.0'
  $version_real = $version? {
    present => $latest_version,
    latest  => $latest_version,
    absent => $latest_version,
    default => $version 
  }

  $hash = $version_hashes[$version_real]
  if !$hash {
    fail("Unknown chromedriver version: ${version_real}")
  }
  $source_file = "chromedriver_linux32_${version_real}.zip"
  $source_url = "https://chromedriver.googlecode.com/files/${source_file}"
  $exec_name = 'chromedriver'
  $target_dir_versioned = "${target_directory}/.${exec_name}/${version_real}"
  $target_file_versioned = "${target_dir_versioned}/${exec_name}"
  $target_file = "${target_directory}/${exec_name}"
  
  archive { $source_file:
    ensure => $ensure,
    url => $source_url,
    digest_string => $hash,
    digest_type => 'sha1',
    target => $target_dir_versioned,
    root_dir => $exec_name,
    extension => 'zip'
  }

  $link = $ensure? {
     absent => absent,
     default => 'link'
  }

  file { $target_file:
     ensure => $link,
     target => $target_file_versioned,
     require => Archive[$source_file]
  }
}

