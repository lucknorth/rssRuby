#!/usr/bin/ruby
require '/home/pi/rss/rssAnalyzer'
require 'rexml/document'
require 'tempfile'
require 'set'
include REXML
#$B=i4|=hM}(B
tmp = Tempfile::new("tmp","/home/pi/rss/")
rssAry = Array.new
hisSet = Set.new
sites = open("/home/pi/rss/rssResource")
history = open("/home/pi/rss/rssHistory","r+")
sites.each {|line|
    rssAry.push( RssAnalyze.new(line.chomp) )
}
sites.close
#$BMzNr<hF@(B
history.each{|entry|
   hisSet.add(entry.chomp)    
}
history.close
    
#RSS$B<hF@$r<B9T$9$k(B
rssAry.each {|rss|
   rss.historys=hisSet
   rss.fetchRSS() 
   rss.postNewEntry()
}
#$B99?7MzNr$r0l<!%U%!%$%k$X=q$-9~$`(B
rssAry.each{|rss|
    rss.ary.each{|entry|
        tmp.puts(entry.url)
    }
}
tmp.close
tmp.open
#$B<!2s$N%U%#%k%?%j%s%0$N$?$a:#2s$N%(%s%H%j!<$rJ]B8(B
open("/home/pi/rss/rssHistory","w"){|f|
    tmp.each{|line|
        f.puts(line)
    }
}
tmp.close
