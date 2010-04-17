#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'tempfile'
require 'im_magick'

image = 'image.jpg'

def pixelate image, degree
  size = ImMagick::identify.format('%wx%h!').run.on(image).result[0]
  p size
  cmd = ImMagick::convert do |i|
    i.from image
    i.scale "#{100.0/degree}%"
    i.scale size
  end
  p cmd
  tmp = Tempfile.new('img')
  cmd.run.save(tmp.path)
  s = File.read(tmp.path)
  tmp.unlink
  s
end

get '/' do
  <<END
<img src='/i'>
END
end

a = [50, 40, 30, 20, 10, 5, 3]
get '/i' do
  content_type 'image/jpeg'
  if a.empty?
    File.read(image)
  else
    pixelate image, a.delete_at(0)
  end
end
