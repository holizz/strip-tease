#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'tempfile'
require 'im_magick'

image = 'image.jpg'

def pixelate image, degree
  cmd = ImMagick::convert do |i|
    i.from image
    i.scale "#{100.0/degree}%"
    i.scale "#{100.0*degree}%"
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

get '/i' do
  content_type 'image/jpeg'
  pixelate image, 6
end
