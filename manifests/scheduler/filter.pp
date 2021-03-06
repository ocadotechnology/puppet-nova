# == Class: nova::scheduler::filter
#
# This class is aim to configure nova.scheduler filter
#
# === Parameters:
#
# [*scheduler_host_manager*]
#   (optional) The scheduler host manager class to use. Should be either
#   'host_manager' or 'ironic_host_manager'
#   Defaults to 'host_manager'
#
# [*scheduler_max_attempts*]
#   (optional) Maximum number of attempts to schedule an instance
#   Defaults to '3'
#
# [*scheduler_host_subset_size*]
#   (optional) defines the subset size that a host is chosen from
#   Defaults to '1'
#
# [*max_io_ops_per_host*]
#   (optional) Ignore hosts that have too many builds/resizes/snaps/migrations
#   Defaults to '8'
#
# [*isolated_images*]
#   (optional) An array of images to run on isolated host
#   Defaults to $::os_service_default
#
# [*isolated_hosts*]
#   (optional) An array of hosts reserved for specific images
#   Defaults to $::os_service_default
#
# [*max_instances_per_host*]
#   (optional) Ignore hosts that have too many instances
#   Defaults to '50'
#
# [*scheduler_available_filters*]
#   (optional) An array with filter classes available to the scheduler.
#   Example: ['first.filter.class', 'second.filter.class']
#   Defaults to ['nova.scheduler.filters.all_filters']
#
# [*scheduler_default_filters*]
#   (optional) An array of filters to be used by default
#   Defaults to $::os_service_default
#
# [*scheduler_weight_classes*]
#   (optional) Which weight class names to use for weighing hosts
#   Defaults to 'nova.scheduler.weights.all_weighers'
#
# [*baremetal_scheduler_default_filters*]
#   (optional) An array of filters to be used by default for baremetal hosts
#   Defaults to $::os_service_default
#
# [*scheduler_use_baremetal_filters*]
#   (optional) Use baremetal_scheduler_default_filters or not.
#   Defaults to false
#
# [*periodic_task_interval*]
#   (optional) This value controls how often (in seconds) to run periodic tasks
#   in the scheduler. The specific tasks that are run for each period are
#   determined by the particular scheduler being used.
#   Defaults to $::os_service_default
#
# [*track_instance_changes*]
#   (optional) Enable querying of individual hosts for instance information.
#   Defaults to $::os_service_default
#
# [*ram_weight_multiplier*]
#   (optional) Ram weight multipler ratio. This option determines how hosts
#   with more or less available RAM are weighed.
#   Defaults to $::os_service_default
#
# [*disk_weight_multiplier*]
#   (optional) Disk weight multipler ratio. Multiplier used for weighing free
#   disk space. Negative numbers mean to stack vs spread.
#   Defaults to $::os_service_default
#
# [*io_ops_weight_multiplier*]
#   (optional) IO operations weight multipler ratio. This option determines
#   how hosts with differing workloads are weighed
#   Defaults to $::os_service_default
#
# [*soft_affinity_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts for group soft-affinity
#   Defaults to $::os_service_default
#
# [*soft_anti_affinity_weight_multiplier*]
#   (optional) Multiplier used for weighing hosts for group soft-anti-affinity
#   Defaults to $::os_service_default
#
# [*restrict_isolated_hosts_to_isolated_images*]
#   (optional) Prevent non-isolated images from being built on isolated hosts.
#   Defaults to $::os_service_default
#
# [*aggregate_image_properties_isolation_namespace*]
#   (optional) Image property namespace for use in the host aggregate
#   Defaults to $::os_service_default
#
# [*aggregate_image_properties_isolation_separator*]
#   (optional) Separator character(s) for image property namespace and name
#   Defaults to $::os_service_default
#
# DEPRECATED PARAMETERS
#
# [*cpu_allocation_ratio*]
#   (optional) Virtual CPU to Physical CPU allocation ratio
#   Defaults to undef
#
# [*ram_allocation_ratio*]
#   (optional) Virtual ram to physical ram allocation ratio
#   Defaults to undef
#
# [*disk_allocation_ratio*]
#   (optional) Virtual disk to physical disk allocation ratio
#   Defaults to undef
#
class nova::scheduler::filter (
  $scheduler_host_manager                         = 'host_manager',
  $scheduler_max_attempts                         = '3',
  $scheduler_host_subset_size                     = '1',
  $max_io_ops_per_host                            = '8',
  $max_instances_per_host                         = '50',
  $isolated_images                                = $::os_service_default,
  $isolated_hosts                                 = $::os_service_default,
  $scheduler_available_filters                    = ['nova.scheduler.filters.all_filters'],
  $scheduler_default_filters                      = $::os_service_default,
  $scheduler_weight_classes                       = 'nova.scheduler.weights.all_weighers',
  $baremetal_scheduler_default_filters            = $::os_service_default,
  $scheduler_use_baremetal_filters                = false,
  $periodic_task_interval                         = $::os_service_default,
  $track_instance_changes                         = $::os_service_default,
  $ram_weight_multiplier                          = $::os_service_default,
  $disk_weight_multiplier                         = $::os_service_default,
  $io_ops_weight_multiplier                       = $::os_service_default,
  $soft_affinity_weight_multiplier                = $::os_service_default,
  $soft_anti_affinity_weight_multiplier           = $::os_service_default,
  $restrict_isolated_hosts_to_isolated_images     = $::os_service_default,
  $aggregate_image_properties_isolation_namespace = $::os_service_default,
  $aggregate_image_properties_isolation_separator = $::os_service_default,
  # DEPRECATED PARAMETERS
  $cpu_allocation_ratio                           = undef,
  $ram_allocation_ratio                           = undef,
  $disk_allocation_ratio                          = undef,
) {

  include ::nova::deps

  # The following values are following this rule:
  # - default is $::os_service_default so Puppet won't try to configure it.
  # - if set, we'll validate it's an array that is not empty and configure the parameter.
  # - Otherwise, fallback to default.
  if !is_service_default($scheduler_default_filters) and !empty($scheduler_default_filters){
    validate_array($scheduler_default_filters)
    $scheduler_default_filters_real = join($scheduler_default_filters, ',')
  } else {
    $scheduler_default_filters_real = $::os_service_default
  }

  if is_array($scheduler_available_filters) {
    if empty($scheduler_available_filters) {
      $scheduler_available_filters_real = $::os_service_default
    } else {
      $scheduler_available_filters_real = $scheduler_available_filters
    }
  } else {
    warning('scheduler_available_filters must be an array and will fail in the future')
    $scheduler_available_filters_real = any2array($scheduler_available_filters)
  }

  if !is_service_default($baremetal_scheduler_default_filters) and !empty($baremetal_scheduler_default_filters){
    validate_array($baremetal_scheduler_default_filters)
    $baremetal_scheduler_default_filters_real = join($baremetal_scheduler_default_filters, ',')
  } else {
    $baremetal_scheduler_default_filters_real = $::os_service_default
  }
  if !is_service_default($isolated_images) and !empty($isolated_images){
    validate_array($isolated_images)
    $isolated_images_real = join($isolated_images, ',')
  } else {
    $isolated_images_real = $::os_service_default
  }
  if !is_service_default($isolated_hosts) and !empty($isolated_hosts){
    validate_array($isolated_hosts)
    $isolated_hosts_real = join($isolated_hosts, ',')
  } else {
    $isolated_hosts_real = $::os_service_default
  }

  if $cpu_allocation_ratio {
    warning('cpu_allocation_ratio is deprecated in nova::scheduler::filter, please add to nova::init instead')
  }

  if $ram_allocation_ratio {
    warning('ram_allocation_ratio is deprecated in nova::scheduler::filter, please add to nova::init instead')
  }

  if $disk_allocation_ratio {
    warning('disk_allocation_ratio is deprecated in nova::scheduler::filter, please add to nova::init instead')
  }

  # TODO(aschultz): these should probably be in nova::scheduler ...
  nova_config {
    'scheduler/host_manager':           value => $scheduler_host_manager;
    'scheduler/max_attempts':           value => $scheduler_max_attempts;
    'scheduler/periodic_task_interval': value => $periodic_task_interval;
  }

  nova_config {
    'filter_scheduler/host_subset_size':
      value => $scheduler_host_subset_size;
    'filter_scheduler/max_io_ops_per_host':
      value => $max_io_ops_per_host;
    'filter_scheduler/max_instances_per_host':
      value => $max_instances_per_host;
    'filter_scheduler/track_instance_changes':
      value => $track_instance_changes;
    'filter_scheduler/available_filters':
      value => $scheduler_available_filters_real;
    'filter_scheduler/weight_classes':
      value => $scheduler_weight_classes;
    'filter_scheduler/use_baremetal_filters':
      value => $scheduler_use_baremetal_filters;
    'filter_scheduler/enabled_filters':
      value => $scheduler_default_filters_real;
    'filter_scheduler/baremetal_enabled_filters':
      value => $baremetal_scheduler_default_filters_real;
    'filter_scheduler/isolated_images':
      value => $isolated_images_real;
    'filter_scheduler/isolated_hosts':
      value => $isolated_hosts_real;
    'filter_scheduler/ram_weight_multiplier':
      value => $ram_weight_multiplier;
    'filter_scheduler/disk_weight_multiplier':
      value => $disk_weight_multiplier;
    'filter_scheduler/io_ops_weight_multiplier':
      value => $io_ops_weight_multiplier;
    'filter_scheduler/soft_affinity_weight_multiplier':
      value => $soft_affinity_weight_multiplier;
    'filter_scheduler/soft_anti_affinity_weight_multiplier':
      value => $soft_anti_affinity_weight_multiplier;
    'filter_scheduler/restrict_isolated_hosts_to_isolated_images':
      value => $restrict_isolated_hosts_to_isolated_images;
    'filter_scheduler/aggregate_image_properties_isolation_namespace':
      value => $aggregate_image_properties_isolation_namespace;
    'filter_scheduler/aggregate_image_properties_isolation_separator':
      value => $aggregate_image_properties_isolation_separator;
  }

  # TODO(aschultz): old options, remove in P
  nova_config {
    'DEFAULT/scheduler_host_manager':              ensure => 'absent';
    'DEFAULT/scheduler_max_attempts':              ensure => 'absent';
    'DEFAULT/scheduler_host_subset_size':          ensure => 'absent';
    'DEFAULT/max_io_ops_per_host':                 ensure => 'absent';
    'DEFAULT/max_instances_per_host':              ensure => 'absent';
    'DEFAULT/scheduler_available_filters':         ensure => 'absent';
    'DEFAULT/scheduler_weight_classes':            ensure => 'absent';
    'DEFAULT/scheduler_use_baremetal_filters':     ensure => 'absent';
    'DEFAULT/scheduler_default_filters':           ensure => 'absent';
    'DEFAULT/baremetal_scheduler_default_filters': ensure => 'absent';
    'DEFAULT/isolated_images':                     ensure => 'absent';
    'DEFAULT/isolated_hosts':                      ensure => 'absent';
  }

}
