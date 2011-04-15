require 'lib/toto-moj/lib/toto'

@config = Toto::Config::Defaults

task :default => :new

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n\n"

  path = "#{Toto::Paths[:articles]}/#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}.#{@config[:ext]}"

  unless File.exist? path
    File.open(path, "w") do |file|
      file.write article
    end
    toto "an article was created for you at #{path}."
    if false and `echo $EDITOR`.chomp.empty? # temp.
      system "mate -l 5 #{path}"
    else
      system "$EDITOR #{path}"
    end
  else
    toto "I can't create the article, #{path} already exists."
  end
end

desc "Publish my blog."
task :publish do
  toto "publishing your article(s)..."
  `git push heroku master`
end

desc "Show unused CSS selectors"
task :css do
  system "deadweight -s public/css/main.css http://localhost:3000/"
end

def toto msg
  puts "\n  toto ~ #{msg}\n\n"
end

def ask message
  print message
  STDIN.gets.chomp
end

