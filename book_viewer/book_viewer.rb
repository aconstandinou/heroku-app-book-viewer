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

# original - just to locate chapters
# def chapters_matching(query)
#   list_of_chapters = Hash.new()
#   return list_of_chapters if !query || query.empty?
#
#   (1..12).each do |num|
#     text_to_read = File.read("data/chp#{num}.txt")
#     chapter_name = @contents[num - 1]
#     list_of_chapters[num] = chapter_name if text_to_read.include?(query)
#   end
#   list_of_chapters
# end

# helper to bold <strong> the word found - creating helper functions
helpers do
  def highlight(par, word)
    par.gsub!(word,"(<strong>#{word}</strong>)")
  end
end

# new - locate paragraphs
def pars_matching(query)
  hsh_of_pars = Hash.new()
  return hsh_of_pars if !query || query.empty?

  (1..12).each do |num|
    chp_name = @contents[num - 1]
    text_to_read = File.read("data/chp#{num}.txt")
    text_to_read.split("\n\n").each do |par|
      if par.include?(query)
        (hsh_of_pars[chp_name] ||= []) << [num, par]
      end
    end
  end

  hsh_of_pars
end

# New code for our search bar
get "/search" do
  @list_of_pars = pars_matching(params[:query])
  erb :search
end
