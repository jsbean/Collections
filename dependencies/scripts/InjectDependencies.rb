require 'rubygems'
require 'nokogiri'
require 'json'
# set file to modify from first argument if present
if ARGV[0].nil?
  html_to_mod = 'index.html'
else
  html_to_mod=ARGV[0]
end
# set json to parse from second argument if present
if ARGV[1].nil?
  json_to_read = 'dependencies.json'
else
  json_to_read=ARGV[1]
end
# make sure the files we’re asking for exist before doing anything
if (File.exist?(json_to_read)) && (File.exist?(html_to_mod))
  html = File.read(html_to_mod)
  json = File.read(json_to_read)
  dependencies_hash = JSON.parse(json)

  page = Nokogiri::HTML(html)
  # clean out an existing #dependencies node if it exists
  if page.css("#dependencies")
    page.css("#dependencies").remove
  end
  # create new #dependencies navigation section
  page.css(".nav-groups")[0].add_child '<li class="nav-group-name" id="dependencies">
              <span class="nav-group-name-link">Dependencies</span>
              <ul class="nav-group-tasks"></ul>
            </li>'
  dependencies_hash["dependencies"].each do |dependency|
    if dependency["organisation"] == "dn-m"
      dependency_link="/"+dependency["repo"]+"/index.html"
    elsif dependency["registry"] == "github"
      dependency_link="https://github.com/"+dependency["organisation"]+"/"+dependency["repo"]
    end
    if dependency_link.nil?
      item_html = '<li class="nav-group-task"><span class="nav-group-task-link">'+dependency["repo"]+'</span>'
    else
      item_html = '<li class="nav-group-task">
        <a class="nav-group-task-link" href="'+dependency_link+'">'+dependency["repo"]+'</a>'
    end
    if dependency["version"].to_s.strip.length == 0
      item_html = item_html+'</li>'
    else
      item_html = item_html+' <span class="dependency-version">'+dependency["version"]+'</span></li>'
    end
    page.css("#dependencies .nav-group-tasks")[0].add_child item_html
  end
  File.write(html_to_mod, page.to_html)
else
  puts 'Error: looks like your arguments don’t match real life files.'
end
