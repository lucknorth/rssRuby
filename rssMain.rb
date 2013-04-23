#!/usr/bin/ruby
require '/home/pi/rss/rssAnalyzer'
require 'rexml/document'
require 'tempfile'
require 'set'
include REXML
#�������
tmp = Tempfile::new("tmp","/home/pi/rss/")
rssAry = Array.new
hisSet = Set.new
sites = open("/home/pi/rss/rssResource")
history = open("/home/pi/rss/rssHistory","r+")
sites.each {|line|
    rssAry.push( RssAnalyze.new(line.chomp) )
}
sites.close
#�������
history.each{|entry|
   hisSet.add(entry.chomp)    
}
history.close
    
#RSS������¹Ԥ���
rssAry.each {|rss|
   rss.historys=hisSet
   rss.fetchRSS() 
   rss.postNewEntry()
}
#���������켡�ե�����ؽ񤭹���
rssAry.each{|rss|
    rss.ary.each{|entry|
        tmp.puts(entry.url)
    }
}
tmp.close
tmp.open
#����Υե��륿��󥰤Τ��ả��Υ���ȥ꡼����¸
open("/home/pi/rss/rssHistory","w"){|f|
    tmp.each{|line|
        f.puts(line)
    }
}
tmp.close
