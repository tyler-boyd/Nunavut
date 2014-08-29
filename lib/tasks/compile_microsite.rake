task compile_microsite: :environment do
  if !Rails.env.production?
    raise 'Re-run with "RAILS_ENV=production"'
  end
  Dir.mkdir(Rails.root.join('compiled')) unless Dir.exist? Rails.root.join('compiled')
  `rm -rf compiled/*`
  `rm compiled.zip`

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
  body.sub!(/<link[^>]*>/, '{% for style_url in style_urls %} <link type="text/css" href="{{style_url}}" media="all" rel="stylesheet"/> {% endfor %}')
  body.sub!(/<script[^>]*>[^<]*<\/script>/, ' {% for script_url in script_urls %} <script type="text/javascript" src="{{script_url}}"> </script> {% endfor %}')
  body.sub!(/catalog\_tie/, '<script type="text/javascript">window.catalog_id={{catalog_id}};window.microsite_id={{microsite_id}}</script>')
  File.open(Rails.root.join('compiled', 'index.html.liquid'), 'w') do |f|
    f << body
  end

  # Public Folder
  Dir.mkdir(Rails.root.join('compiled', 'public')) unless Dir.exist? Rails.root.join('compiled', 'public')
  `rm -rf public/assets`
  `cp -R public/* compiled/public/`

  # Assets
  `rake assets:precompile`
  Dir.mkdir(Rails.root.join('compiled', 'assets')) unless Dir.exist? Rails.root.join('compiled', 'assets')
  `cp -R public/assets/* compiled/assets/`

  # Zip it up
  `zip -r compiled.zip compiled/`
end