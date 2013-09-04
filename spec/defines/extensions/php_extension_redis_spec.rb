require 'spec_helper'

describe "php::extension::redis" do
  let(:facts) { default_test_facts }
  let(:title) { "redis for 5.4.17" }
  let(:params) do
    {
      :php     => "5.4.17",
      :version => "2.2.3"
    }
  end

  it do
    should include_class("redis")
    should include_class("php::config")
    should include_class("php::5_4_17")

    should contain_repository("/test/boxen/data/php/cache/extensions/redis").with({
      :source => "nicolasff/phpredis"
    })

    should contain_php_extension("redis for 5.4.17").with({
      :provider         => "git",
      :extension        => "redis",
      :version          => "2.2.3",
      :homebrew_path    => "/test/boxen/homebrew",
      :phpenv_root      => "/test/boxen/phpenv",
      :php_version      => "5.4.17",
      :cache_dir        => "/test/boxen/data/php/cache/extensions",
      :require          => "Repository[/test/boxen/data/php/cache/extensions/redis]",
    })

    should contain_file("/test/boxen/config/php/5.4.17/conf.d/redis.ini").with({
      :content => File.read("spec/fixtures/redis.ini"),
      :require => "Php_extension[redis for 5.4.17]"
    })
  end
end
