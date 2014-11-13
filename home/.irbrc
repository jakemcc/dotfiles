require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'
require 'wirble'

begin
  Wirble.init
  Wirble.colorize
rescue LoadError => e
  $stderr.puts "couldnt load wirble: #{e}"
end
 
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true

