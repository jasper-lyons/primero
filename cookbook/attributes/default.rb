
default[:primero].tap do |p|
  p[:http_port] = 80
  p[:https_port] = 443
  p[:rails_env] = 'production'
  p[:home_dir] = '/srv/primero'
  p[:app_dir] = File.join(node[:primero][:home_dir], 'application')
  p[:config_dir] = File.join(node[:primero][:home_dir], 'configuration')
  p[:log_dir] = File.join(node[:primero][:home_dir], 'logs')
  p[:daemons_dir] = File.join(node[:primero][:app_dir], 'daemons')
  p[:app_user] = 'primero'
  p[:app_group] = 'primero'

  p[:queue].tap do |queue|
    queue[:host] = 'localhost'
    queue[:port] = '11300'
    queue[:storage_dir] = File.join(node[:primero][:home_dir], 'beanstalkd')
    queue[:queue_list] = 'mailer,export'
  end

  p[:couch_watcher].tap do |cw|
    cw[:app_host] = 'localhost'
    cw[:app_port] = 4000
  end

  p[:no_reseed] = false

  p[:git].tap do |git|
    git[:repo] = 'git@bitbucket.org:primeroims/primero.git'
    git[:revision] = 'development'
  end

  p[:seed].tap do |seed|
    seed[:enabled] = false
  end

  p[:couchdb].tap do |c|
    c[:host] = 'localhost'
    c[:username] = 'primero'
    c[:cert_path] = '/etc/ssl/couch.crt'
    c[:key_path] = '/etc/ssl/private/couch.key'
    c[:client_ca_path] = '/etc/ssl/client_ca.crt'
    c[:root_ca_cert_source] = 'couch_ca.crt'
    c[:config].tap do |conf|
      conf[:httpd].tap do |httpd|
        httpd[:bind_address] = '0.0.0.0'
        httpd[:port] = '5984'
      end
      conf[:ssl].tap do |ssl|
        ssl['verify_ssl_certificates'] = true
      end
      conf[:compactions].tap do |compactions|
        compactions[:_default] = '[{db_fragmentation, "70%"}, {view_fragmentation, "60%"}, {from, "23:00"}, {to, "04:00"}]'
      end
      conf[:replicator].tap do |rep|
        rep['verify_ssl_certificates'] = true
      end
      conf[:query_servers].tap do |qs|
        qs[:javascript] = "/usr/bin/couchjs -S 134217728 /usr/share/couchdb/server/main.js"
      end
      conf[:couchdb].tap do |cdb|
        cdb[:os_process_timeout] = '20000'
      end
    end
  end

  p[:solr].tap do |solr|
    solr[:user] = 'solr'
    solr[:group] = 'solr'
    solr[:version] = '5.3.1'
    solr[:hostname] = 'localhost'
    solr[:port] = 8983
    solr[:log_level] = 'INFO'
    solr[:memory] = '512m'
    solr[:home_dir] = '/var/solr'
    solr[:log_dir] = File.join(node[:primero][:log_dir], 'solr')
    solr[:data_dir] =  File.join(node[:primero][:solr][:home_dir], 'data')
    solr[:core_dir] = File.join(node[:primero][:solr][:home_dir], 'cores')
  end

  p[:ruby_version] = '2.4.3'
  p[:ruby_patch] = 'railsexpress'
  p[:bundler_version] = '1.16.1'
  p[:rubygems_version] = '2.7.5'

  p[:puma_conf].tap do |pc|
    pc[:min_thread_count] = 5
    pc[:max_thread_count] = 5
    pc[:port] = 4000
  end

  p[:mailer].tap do |m|
    m[:delivery_method] = 'sendmail'
    m[:host] = 'primero.org'
    m[:from_address] = 'noreply@primero.org'
  end
end

default[:postfix].tap do |pf|
  pf[:admin] = 'root'
  pf[:admin_email] = 'noreply@email.example.com'
  pf[:alias_path] = '/etc/aliases'
  pf[:alias_maps] = 'hash:/etc/aliases'
  pf[:alias_database] = 'hash:/etc/aliases'
  pf[:message_size_limit] = 10240
  pf[:mailbox_size_limit] = 51200000
  pf[:qmgr_message_active_limit] = 50000
  pf[:home_mailbox] = 'mail'
end

default[:rvm].tap do |rvm|
  rvm[:user_installs] = [
    {
      :user => node[:primero][:app_user],
      :home => node[:primero][:home_dir],
    }
  ]
  rvm[:vagrant][:system_chef_solo] = '/opt/chef/bin/chef-solo'
end

default[:nginx_dir] = '/etc/nginx'
default[:nginx_default_site] = true

default[:postfix_dir] = '/etc/postfix'

default[:python][:install_method] = 'package'
default[:python][:setuptools_version] = '3.4.4'
default[:python][:virtualenv_version] = '1.11.4'
default[:supervisor][:version] = '3.1.2'
default[:supervisor][:minfds] = 16384
