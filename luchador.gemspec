time = Time.new
month = time.month
day = time.day
if (time.month < 10)
    month = "0#{month}"
end

if (day < 10)
    day = "0#{day}"
end

date = "#{time.year}-#{month}-#{day}"

Gem::Specification.new do |s|
    s.name        = 'luchador'
    s.license     = 'GPL'
    s.executables << 'luchador'
    s.version     = '0.0.1'
    s.date        = date
    s.summary     = 'RPG-like battler.'
    s.description = "RPG-like battling system that pits cats against dogs. Written with rubygame."
    s.authors     = ['Thomas Chace']
    s.email       = 'tchacex@gmail.com'
    s.homepage    = 'http://tchace.info'
    s.files       = ["lib/luchador.rb", "lib/background.png", "lib/cat.png", "lib/dog.png", "lib/Lato-Regular.ttf"]
    s.add_runtime_dependency "rubygame"
end
