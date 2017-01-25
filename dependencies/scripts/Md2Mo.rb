require 'rubygems'
require 'redcarpet'
# set file to convert from first argument if present
if ARGV[0].nil?
  # if path not specified, assume we’re looking for main.md
  md_to_mod = 'main.md'
else
  md_to_mod = ARGV[0]
end
# set output target from second argument if present
if ARGV[1].nil?
  # if no second argument, export to same path as imported markdown
  # switching extension .md to .mo
  export_path = md_to_mod.sub /\.[^.]+\z/, ".mo"
else
  export_path = ARGV[1]
end

# Initialise Markdown parser
options = {
  filter_html:     true,
  hard_wrap:       true,
  link_attributes: { rel: 'nofollow', target: "_blank" },
  space_after_headers: true,
  fenced_code_blocks: true
}
extensions = {
  autolink:           true,
  superscript:        true,
  disable_indented_code_blocks: true
}
renderer = Redcarpet::Render::HTML.new(options)
markdown = Redcarpet::Markdown.new(renderer, extensions)

# If the .md file exists, read it, parse it to HTML, and save as .mo
if (File.exist?(md_to_mod))
  md = File.read(md_to_mod)
  html = markdown.render(md)
  File.write(export_path, html)
else
  puts 'Error: looks like ' + md_to_mod + ' doesn’t match a real life file.'
end
