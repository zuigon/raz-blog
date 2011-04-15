require 'lib/toto-moj/lib/toto'

require 'coderay'
require 'rack/codehighlighter'
use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code", :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => true

# Rack config
use Rack::Static, :urls => ['/css', '/js', '/images', '/favicon.ico'], :root => 'public'
use Rack::CommonLogger

if ENV['RACK_ENV'] == 'development'
  use Rack::ShowExceptions
end

class AppHelper
  def self.fun_za_indexcode
    lambda {
      eval File.read('./lib/indexcode.rb')
      lambda { }
    }.call
  end
end

toto = Toto::Server.new do
  set :author,    ENV['USER']
  set :title,     'printf("Our House");'
  # set :root,      "index.temp"
  set :error => lambda {|code| "<font style='font-size:300%'>error (#{code})</font>" }
  set :to_html => lambda {|path, page, ctx| ERB.new(File.read("#{path}/#{page}.rhtml")).result(ctx) }
  set :cache, 300

  set :sites, {
    "localhost" => {
      :blk_hosts => [],
      # :real_blog_hosts => ["127.0.0.1", "::1"],
      :real_blog_hosts => [],
      :fake_page => lambda { ERB.new(File.read("templates/pages/index.temp.rhtml")).result(AppHelper.fun_za_indexcode) }
    },
    "blog.razred.bkrsta.co.cc" => {
      :blk_hosts => [],
      :real_blog_hosts => [],
      :fake_page => lambda { ERB.new(File.read("templates/pages/index.temp.rhtml")).result(AppHelper.fun_za_indexcode) }
    },
    "default" => {
      :blk_hosts => ["all"]
    }
  }
  set :disqus, 'rcoderblog-c'

  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
end

run toto
