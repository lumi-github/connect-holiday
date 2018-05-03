# config/schedule.rb
# 出力先のログファイルの指定
set :output, 'log/crontab.log'
# ジョブの実行環境の指定
set :environment, :production
# 3時間毎に実行するスケジューリング
every 1.minute do
  runner 'Event.event_mail'
end
