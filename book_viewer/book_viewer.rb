require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

# old code
# get "/" do
#   File.read "public/template.html"
# end

# new code
get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines("data/toc.txt")

  erb :home
end

# adding a new route for Chapter 1
get "/chapter/1" do
  @title = "Chapter 1"
  @contents = File.readlines("data/toc.txt")
  @chapter = File.read("data/chp1.txt")
  erb :chapter
end
