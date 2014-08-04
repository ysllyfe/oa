#!/usr/bin/env ruby
require "tempfile"


def with_tmp_dir(&block)
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir, &block)
  end
end



with_tmp_dir do |dir|
  puts "Dir is accessible as parameter and pwd is set: #{dir}"
end
