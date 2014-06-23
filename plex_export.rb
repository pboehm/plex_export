#!/usr/bin/env ruby
# encoding: utf-8
#
# Copyright (C) 2014 Philipp Böhm
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


PLEX_HOST  = ENV.fetch("PLEX_HOST") do
  raise ArgumentError, "PLEX_HOST env variable is required"
end
PLEX_PORT  = ENV.fetch("PLEX_PORT") { 32400 }
PLEX_TOKEN = ENV.fetch("PLEX_TOKEN") do
  raise ArgumentError, "PLEX_TOKEN env variable is required"
end

REQUESTED_SERIES = ARGV.fetch(0) do
  raise ArgumentError, "You have to supply a series name as first argument"
end

require 'plex-ruby'
require 'uri'

class M3U
  attr_reader :series

  def initialize(series)
    @series = series
    @entries = []
  end

  def add(filename, url)
    @entries << [ filename, url ]
  end

  def has_entries?
    not @entries.empty?
  end

  def lines
    lines = ["#EXTM3U"]

    @entries.each do |filename, url|
      lines << "#EXTINF:-1,#{ filename }"
      lines << url
    end

    lines
  end
end

Plex.configure do |config|
  config.auth_token = PLEX_TOKEN
end

server = Plex::Server.new(PLEX_HOST, PLEX_PORT)

section = server.library.sections.first
shows = section.all

shows.select {|s|
    s.title =~ /#{ Regexp.escape(REQUESTED_SERIES) }/i }.each do |series|

  m3u = M3U.new(series.title)

  series.seasons.each do |season|
    season.episodes.each do |episode|
      part = episode.medias.first.parts.first

      filename = "S%.2dE%.2d - %s%s" % [
                    episode.parent_index, episode.index, episode.title,
                    File.extname(part.file) ]

      url = "http://%s:%s%s?X-Plex-Token=%s" % [
              PLEX_HOST, PLEX_PORT, part.key, PLEX_TOKEN ]

      m3u.add(filename, url)
    end
  end

  if m3u.has_entries?
    puts m3u.lines if m3u.has_entries?
  end
end
