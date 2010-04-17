#!/usr/bin/env ruby

# Copyright © 2010, Tom Adams
#
# This software is dedicated to Jerri Wilson <3
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

require 'rubygems'
require 'sinatra'
require 'tempfile'
require 'im_magick'

image = 'image.jpg'

def pixelate image, degree
  size = ImMagick::identify.format('%wx%h!').run.on(image).result[0]
  cmd = ImMagick::convert do |i|
    i.from image
    i.scale "#{100.0/degree}%"
    i.scale size
  end
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

a = [50, 40, 30, 20, 10, 5]
get '/i' do
  content_type 'image/jpeg'
  if a.empty?
    puts "Full resolution"
    File.read(image)
  else
    n = a.delete_at(0)
    puts "#{100.0/n}% resolution"
    pixelate image, n
  end
end
