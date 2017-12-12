######################### Sinatra and Web Frameworks #########################

Sinatra Readme: http://sinatrarb.com/intro.html

- Lets sort out TCP to Rack to WEBrick to Sinatra, and how they relate to
  each other.

- Sinatra is a Rack-based web dev framework.
- Since its a Rack-based web dev framework, that implies that it uses Rack to connect
  to a web server like WEBrick.
- Sinatra provides conventions for where to place your application code.
- It has built-in capabilities for routing, view templates, and other features.
- At its core, its nothing more than Ruby code connecting to a TCP server, handling
  requests and sending back responses all in an HTTP-compliant string format.

                                  -------------------  request       response
      ----------------------------                        |             ^
server                                                    V             |
      ----------------------------                           WEBrick
                                  -------------------  [------------------]
                                                       [       [RACK]     ]
                                                       [ SINATRA FRAMEWORK]
                                                       [------------------]

############################## How Routes Work ##############################

- Sinatra provides DSL for defining routes and these routes are how a developer
  maps a URL pattern to some Ruby code.
- in our book_viewer.rb code;

1| require "sinatra"
2| require "sinatra/reloader"
3|
4| get "/" do
5|   File.read "public/template.html"
6| end

1) First, we 'require' 'sinatra' and 'sinatra/reloader' which causes the app to
   reload its files every time we load a page.
2) 'get "/" do' is declaring a route that matches the URL "/". When a user visits that
   path on the app, Sinatra will execute this code block. Value returned is then
   sent to users browser.
   In this case, it contains HTML code

############################ Rendering Templates ############################

- So far, this app is acting like a static file server since its just sending back
  static files back to the user.

- Templates (a.k.a view templates) are files that contain text that is converted
  into HTML before being sent to a users browser in a response.

- Our language of choice "ERB" (embedded Ruby) which is also the default language
  in Ruby on Rails.

ERB example of printing a dynamic value;

<h1><%= @title %></h1>

When the template is rendered, the value for @title will replace the ERB tags.
If @title == "Book Viewer", the rendered output of the template would be:

<h1>Book Viewer</h1>

- Any Ruby code at all can be placed in an .erb file by including it between
  # <% and %>
  If you want to display a value, you have to use a special start tag, <%=


# To use the HTML template in the project as an ERB template instead, perform the following:

1. Copy the code from public/template.html to views/home.erb.
2. Add require "tilt/erubis" to the top of book_viewer.rb.
3. Update the code inside get "/" to;

get "/" do
  erb :home
end

4. Refresh your browser. Nothing should have changed yet.
5. Try modifying erb :home to specify a nonexistent view template, something like erb
   :anything. Reload your browser and look at the error that it displays.
6. Add a dynamic value to the page. Replace the title tag in views/home.erb with a
   value that is defined in the get "/" route.

   <title><%= @title %></title>

7. [Q]: (bonus) What is tilt (referenced in point no. 2 above)
   [A]: allows us to render templates and erubis is a fast alternative to ERB

############################# Table of Contents #############################

- Lets add table of contents that lists the chapters in the book.
- File "data/toc.txt" contains all the chapters in book.

# A Scandal in Bohemia
# The Red-headed League
# A Case of Identity
# The Boscombe Valley Mystery
# The Five Orange Pips
# The Man with the Twisted Lip
# The Adventure of the Blue Carbuncle
# The Adventure of the Speckled Band
# The Adventure of the Engineer's Thumb
# The Adventure of the Noble Bachelor
# The Adventure of the Beryl Coronet
# The Adventure of the Copper Beeches

1. Load the contents of this file into an instance variable within "get '/'' " route.
   Answer
   get "/" do
     @title = "The Adventures of Sherlock Holmes"
     @contents = File.read("data/toc.txt")
     erb :home
   end

2. Display this value in the main content area by adding some code to 'views/home.erb'
<ul class="pure-menu-list">
  <% @contents.each do |chapter| %>
    <li class="pure-menu-item">
      <a href="#" class="pure-menu-link"><%= chapter %></a>
    </li>
  <% end %>
</ul>

3. Would be better to have an Array of Strings where each element in the array
   was the name of a chapter. Update the code that loads the data to do this.
   #we use readlines
   @contents = File.readlines("data/toc.txt")

4. Now update "views/home.erb" to loop through this array of chapter names in two places;
   main content area ( <div id="main"> ) and navigation area ( <div id="menu"> ).

############################# Adding a Chapter Page #############################

- lets start with chapter 1.
- route (aka path) = "/chapters/1"

  Step 1. add a new route to the application, inside it load 'data/chp1.text' into an instance variable.
  get "/chapters/1" do
    @title = "Chapter 1"
    @contents = File.readlines("data/toc.txt")
    @chapter = File.read("data/chp1.txt")

    erb :chapter
  end
  Step 2. Copied 'views/home.erb' over to 'views/chapter.erb' and updated new erb file
          to display our chapter 1 text, after instantiating a new variable @chapter

  Step 3. Adjust paths in stylesheet 'link' tags in 'views/chapter' to have CSS files
          loaded properly.

  (Bonus). The chapter text is not very legible right now.
           Well come back to this in a future assignment, but can you think of a
           way to improve its display?
