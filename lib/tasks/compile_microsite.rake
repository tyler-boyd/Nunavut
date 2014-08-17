task compile_microsite: :environment do
  # `rake assets:clean`
  # `rake assets:precompile`
  Dir.mkdir(Rails.root.join('compiled')) unless Dir.exist? Rails.root.join('compiled')

  # Partials
  files = Dir.glob(Rails.root + 'app/views/partial/**/**').select { |match| File.file? match }
  files.each do |file|
    str = `slimrb -e #{file}`.gsub(/<%[^%]*%>/, '')
    path = file.match(/#{Rails.root.join('app', 'views', 'partial')}\/?(.*)\/.*/)[1]
    Dir.mkdir(Rails.root.join('compiled', 'partial', path)) unless Dir.exist? Rails.root.join('compiled', 'partial', path)
    File.open(file.gsub('app/views', 'compiled').gsub(/\.slim/, ''), 'w') do |f|
      f << str
    end
  end

  # Index
  session = ActionDispatch::Integration::Session.new(Rails.application)
  session.get('/')
  body = session.response.body
  body.gsub!(/<link[^>]*>/, '{% for style_url in style_urls %} <link type="text/css" href="{{style_url}}"> {% endfor %}')
  body.gsub!(/<script[^>]*>/, ' {% for script_url in script_urls %} <script type="text/javascript" src="{{script_url}}"> {% endfor %}')
  File.open(Rails.root.join('compiled', 'index.html.liquid'), 'w') do |f|
    f << body
  end
end