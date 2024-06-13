Rails.application.config.middleware.use OmniAuth::Builder do
  # deviseを使う場合はdevise.rbに記載したいが、今回はdeviseを使っていないので当ファイルに記載
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET']
end
