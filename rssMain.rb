#!/usr/bin/ruby
require '/home/pi/rss/rssAnalyzer'
require 'rexml/document'
require 'set'
include REXML
#�������
rssAry = Array.new
hisSet = Set.new
postAry = Array.new
sites = open("/home/pi/rss/rssResource")
history = open("/home/pi/rss/rssHistory","r+")
sites.each {|line|
    rssAry.push( RssAnalyze.new(line.chomp) )
}
sites.close
#�������
count=0
history.each{|entry|
   hisSet.add(entry.chomp)    
   count = count + 1
}
history.close

#RSS������¹Ԥ���
rssAry.each {|rss|
   rss.historys=hisSet
   rss.fetchRSS() 
   postAry.concat( rss.postNewEntry() )
}
#RSS���������¸
if count > 500 then
    #�����κǿ�RSS���������
    #puts "rssHistory reset"
    open("/home/pi/rss/rssHistory","w"){|f|
        rssAry.each{|rss|
            rss.ary.each{|entry|
                f.puts(entry.url)
            }
        }
    }
end
#����Υե��륿��󥰤Τ��ả��Υ���ȥ꡼���ɵ�
open("/home/pi/rss/rssHistory","a"){|f|
    #puts "Add entry to rssHistory"
    postAry.each{|url|
        f.puts(url)
        #puts "ADD: "+url
    }
}
