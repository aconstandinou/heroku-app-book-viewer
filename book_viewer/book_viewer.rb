require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

# old code
# get "/" do
#   File.read "public/template.html"
# end


before do
  @contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end
end

# Not found redirect
not_found do
  redirect "/"
end

# new code
get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

# adding a new route for Chapter 1
get "/chapter/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end
