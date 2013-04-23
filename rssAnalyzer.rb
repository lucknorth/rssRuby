#!/usr/bin/ruby
###RSS��ɽ�����饹
class RssAnalyze
    require 'net/http'
    require '/home/pi/rss/twitterPost'
    require 'uri'
    require 'rss'
    require 'set'
    require 'rexml/document'
    include REXML
    attr_accessor:source,:ary,:historys
    ##�᥽�å����
    #�¹Ԥ�����ޤ��������Ƥʤ�������URL�ȥ����ȥ�����󤫥ꥹ�Ȥ��֤��᥽�å�
    def initialize(sourceUrl)
        @source=sourceUrl
        @ary=Array.new
        @historys=Set.new
    end
    #rssResource������Ͽ�ե����ɤ��������᥽�å�
    def fetchRSS
        puts "fetch "+@source
        url = URI.parse(@source)
        req = Net::HTTP::Get.new(url.request_uri)
        res = Net::HTTP.start(url.host,url.port) {|http|
            http.request(req)
        }
        doc = REXML::Document.new(res.body)
        type = doc.root.attributes["xmlns"]
        #RSS�Υե����ޥåȤ������Ĥ�����Τ��б�
        #�����
        if type == "http://www.w3.org/2005/Atom" then
            doc.elements.each("feed/entry"){|item|
                title = item.elements["title"].text
                link = item.elements["link"].attributes["href"]
                c = Content.new(link,title,"",item.elements["updated"].text)
            @ary.push c
            }
        #�����
        elsif type == "http://purl.org/rss/1.0/" 
            rss = RSS::Parser.parse(@source)
            rss.items.each do |item|
                title = item.title
                link = item.about
                c = Content.new(link,title,"",item.date.to_s)
            @ary.push c
            end
        #������
        else   
            doc.elements.each("rss/channel/item"){|item|
                title = item.elements["title"].text
                link = item.elements["link"].text
                c = Content.new(link,title,"",item.elements["pubDate"].text)
            @ary.push c
            }
        end
    end
    
    #��������XML����Ϥ��ơ������������������ʹߤΥǡ������֤�
    def postNewEntry
         @ary.each{|a|
            begin
            #����򸫶ˤ�뤿��˼����ѤߤΥ���ȥ��ե��륿��󥰤���
                if @historys.include?(a.url) then
                    next
                else 
                    #�ĥ�����
                    #puts "Post: "+a.url
                    Twitter.update(a.title+"- "+a.url)
                 end
            rescue Twitter::Error::Forbidden => ex
                    @ary.delete(a)
            rescue => ex
                    @ary.delete(a)
        end
         }
        end
    end

##�ݥ������Ƥ�ɽ�����饹
class Content
    attr_reader :url, :title, :homeTitle, :date
    def initialize(url,title,homeTitle,date)
        @url = url
        @title =title
        @homeTitle = homeTitle
        @date = date
    end
end
