使用方法
1.各ファイルの場所を絶対パスで指定しているので、各自の環境に合わせて変更する
2.rssResource,rssHistoryを作成する
3.rssResourceに取得したいRSSのURLを一行ずつ記入する
4.Twitterのconsumer_keyなど一式を取得して、access_token.rbを編集する
5.$crontab -e にてrssMain.rbを実行する間隔を指定する
ex.) */30 * * * * /home/pi/rss/rssMain.rb
