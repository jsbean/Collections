require 'nokogiri'

html = %{
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>dn-m</title>
    <link rel="stylesheet" type="text/css" href="_build/css/jazzy.css" />
    <link rel="stylesheet" type="text/css" href="_build/css/highlight.css" />
    <meta charset="utf-8">
    <script src="build/js/jquery.min.js" defer></script>
    <script src="build/js/jazzy.js" defer></script>

  </head>
  <body>

    <a title="dn-m"></a>

    <header class="header">
      
      <p class="header-col header-col--primary">
        <a class="header-link" href="index.html">
          dn-m Docs
        </a>
      </p>

      <p class="header-col header-col--secondary">
        <a class="header-link" href="https://github.com/dn-m/">
          <img class="header-icon" src="build/img/gh.png"/>
          View on GitHub
        </a>
      </p>
      
    </header>

    <div class="content-wrapper">
      <nav class="navigation">
        <ul class="nav-groups">

        </ul>
      </nav>
      <article class="main-content">

        <section class="section">
          <div class="section-content">

            <a href='#dn-m' class='anchor' aria-hidden=true><span class="header-anchor"></span></a>

            {{> main.mo}}

          </div>
        </section>

      </article>
    </div>
    <section class="footer">
      <p>&copy; 2016 <a class="link" href="http://jamesbean.info" target="_blank" rel="external">James</a>. All rights reserved.</p>
    </section>
  </body>
</div>
</html>

}

page = Nokogiri::HTML(html)

categories = {
  "Utility" => ["Collections", "ArithmeticTools"],
  "Graphics" => ["PathTools", "GraphicsTools"]
}

#categories = ["Utility", "Abstract Musical Model"]

categories.each do |category, frameworks|
  
  categories_node = page.css(".nav-groups")[0]

  category_node = categories_node.add_child '
    <li class="nav-group-name" id="' + category + '"></li>
      <span class="nav-group-name-link">' + category + '</span>
      <ul class="nav-group-tasks"></ul>
    </li>
  '

  # Add link!
  frameworks.each do |framework|

    link = "https://github.com/dn-m/#{framework}"

    category_node.css(".nav-group-tasks")[0].add_child '
      <li class="nav-group-task">
        <a class="nav-group-task-link" href="' + link + '">' + framework + '</a>
      </li>
    '
    puts framework
  end
end

page.css(".nav-groups").each do |node|
  puts node
end

# # For each member of the current category
# page.css("#categories .nav-group-tasks")[0].add_child '
#   <li class="nav-group-task">
#     <span class="nav-group-task-link">Collections</span>
#   </li>
# '

File.write('index.html', page.to_html)

#puts page

          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Utility</span>
          #   <ul class="nav-group-tasks">
          #     {{#UTILITY_VERIFIED}}
          #       <li class="nav-group-task">
          #           <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #       </li>
          #     {{/UTILITY_VERIFIED}}
          #   </ul>
          # </li>
          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Music Model</span>
          #   <ul class="nav-group-tasks">
          #     {{#MUSICMODEL_VERIFIED}}
          #       <li class="nav-group-task">
          #         <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #       </li>
          #     {{/MUSICMODEL_VERIFIED}}
          #   </ul>
          # </li>
          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Graphics</span>
          #   <ul class="nav-group-tasks">
          #     {{#GRAPHICS_VERIFIED}}
          #       <li class="nav-group-task">
          #         <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #       </li>
          #     {{/GRAPHICS_VERIFIED}}
          #   </ul>
          # </li>
          # </li>
          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Music Notation</span>
          #   <ul class="nav-group-tasks">
          #     {{#MUSICNOTATION_VERIFIED}}
          #       <li class="nav-group-task">
          #         <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #       </li>
          #     {{/MUSICNOTATION_VERIFIED}}
          #   </ul>
          # </li>
          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Playback</span>
          #   <ul class="nav-group-tasks">
          #     {{#PLAYBACK_VERIFIED}}
          #       <li class="nav-group-task">
          #         <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #       </li>
          #     {{/PLAYBACK_VERIFIED}}
          #   </ul>
          # </li>
          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Interactivity</span>
          #   <ul class="nav-group-tasks">
          #     {{#INTERACTIVITY_VERIFIED}}
          #       <li class="nav-group-task">
          #         <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #       </li>
          #     {{/INTERACTIVITY_VERIFIED}}
          #   </ul>
          # </li>
          # </li>
          # {{#hasMISC}}
          # <li class="nav-group-name">
          #   <span class="nav-group-name-link">Uncategorised</span>
          #   <ul class="nav-group-tasks">
          #     {{#MISC}}
          #     <li class="nav-group-task">
          #       <a class="nav-group-task-link" href="{{.}}/index.html">{{.}}</a>
          #     </li>
          #     {{/MISC}}
          #   </ul>
          # </li>
          # {{/hasMISC}}

  # <head>
  #   <title>dn-m</title>
  #   <link rel="stylesheet" type="text/css" href="build/css/jazzy.css" />
  #   <link rel="stylesheet" type="text/css" href="build/css/highlight.css" />
  #   <meta charset="utf-8">
  #   <script src="build/js/jquery.min.js" defer></script>
  #   <script src="build/js/jazzy.js" defer></script>
  # </head>

# builder = Nokogiri::HTML::Builder.new do |doc|
#   doc.html {

#     doc.body(:onload => 'some_func();') {
#       doc.span.bold {
#         doc.text "Hello world"
#       }
#     }
#   }
# end



#puts builder.to_html

# categories = {
# 	"Utility": ["Collections", "ArithmeticTools"]
# }


