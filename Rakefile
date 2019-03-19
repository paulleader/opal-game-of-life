require 'opal'
require 'opal-jquery'

task :build do
  Opal.append_path "opal"
  File.binwrite "life.js", Opal::Builder.build("application").to_s
  `sass life.scss > life.css`
end
