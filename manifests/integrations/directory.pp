# Class: datadog_agent::integrations::directory
#
# This class will install the necessary config to hook the directory in the agent
#
# Parameters:
#   directory
#       (Required) - string, the directory path to monitor
#       This will be included as a tag: name:<name>.
#
#   name
#       (Optional) - string, tag metrics with specified name. defaults to the "directory"
#
#   dirtagname
#       (Optional) - string, the name of the key for the tag used for the directory, the value will be the value of "name" (see above). The resulting tag will be "<dirtagname>:<name>". defaults to "name"
#
#   filetagname
#       (Optional) - string, the name of the key for the tag used for each file, the value will be the filename. The resulting tag will be "<filetagname>:<filename>". defaults to "filename"
#
#   filegauges
#       (Optional) - boolean, when true stats will be an individual gauge per file (max. 20 files!) and not a histogram of the whole directory. default False
#
#   pattern
#       (Optional) - string, the `fnmatch` pattern to use when reading the "directory"'s files. The pattern will be matched against the files' absolute paths and relative paths in "directory". default "*"
#
#   recursive
#       (Optional) - boolean, when true the stats will recurse into directories. default False
#
#   countonly
#       (Optional) - boolean, when true the stats will only count the number of files matching the pattern. Useful for very large directories.
#
#
# Sample Usage:
#
# Add a class for each check instance:
#
# class { 'datadog_agent::integrations::directory':
#   directory => '/opt/ftp_data',
#   recursive => true,
#   countonly => true,
# }
#
# Add multiple instances in one class declaration:
#
# class { 'datadog_agent::integrations::directory':
#   instances => [{
#     'directory' => '/opt/ftp_data',
#     'recursive' => true,
#     'countonly' => true,
#     },
#     'directory' => '/opt/ftp_data-staging',
#     'recursive' => true,
#     'countonly' => true,
#     },
#   ]
# }

class datadog_agent::integrations::directory (
  Array[Struct[{
    directory   => String,
    name        => Optional[String],
    dirtagname  => Optional[String],
    filetagname => Optional[String],
    filegauges  => Optional[Boolean],
    pattern     => Optional[String],
    recursive   => Optional[Boolean],
    countonly   => Optional[Boolean],
  }]] $instances = [],
) inherits datadog_agent::params {
  include datadog_agent

  file { "${datadog_agent::params::conf_dir}/directory.yaml":
    ensure  => file,
    owner   => $datadog_agent::params::dd_user,
    group   => $datadog_agent::params::dd_group,
    mode    => '0600',
    content => template('datadog_agent/agent-conf.d/directory.yaml.erb'),
    require => Package[$datadog_agent::params::package_name],
    notify  => Service[$datadog_agent::params::service_name]
  }
}
