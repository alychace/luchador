
require 'rubygame'

class Fighter
	def initialize hp, attack, defense, name, speed
		@name = name
		@hp = hp
		@attack = attack
		@defense = defense
		@speed = speed
	end

	def hp
		@hp
	end

	def name
		@name
	end

	def attack
		@attack
	end

	def defense
		@defense
	end

	def speed
		@speed
	end

	def hit power
		power = power / (@defense * 0.5)
		@hp = @hp - power
	end

	def heal
		@hp = @hp + 1
	end

	def kill
		puts "#{@name} has died."
		@hp = 0
		@attack = 0
	end

end

class Dog < Fighter
	def initialize name
		@name = name
		@hp = 10
		@attack = 6
		@defense = 7
		@speed = 7
	end
end

class Cat < Fighter
	def initialize name
		@name = name
		@hp = 10
		@attack = 8
		@defense = 5
		@speed = 10
	end
end

cat = Cat.new "cat"

dog = Dog.new "dog"

def battle one, two
	if one.speed > two.speed
		two.hit one.attack
		one.hit two.attack
	else
		one.hit two.attack
		two.hit one.attack
	end
end

4.times do
	battle cat, dog
	if cat.hp <= 0
		break
	end
	if dog.hp <= 0
		break
	end
end

puts "#{cat.name}: #{cat.hp}"
puts "#{dog.name}: #{dog.hp}"


class FighterSprite
 
  # Turn this object into a sprite
  include Rubygame::Sprites::Sprite
 
  def initialize
    # Invoking the base class constructor is important and yet easy to forget:
    super()
 
    # @image and @rect are expected by the Rubygame sprite code
    @image = Rubygame::Surface.load "asteroid.png"
    @rect  = @image.make_rect
 
  end
 
  def update  seconds_passed
  end
 
  def draw  on_surface
    @image.blit  on_surface, @rect
  end
end

SCREEN = Rubygame::Screen.open [ 640, 480]

class Game
	def initialize screen = SCREEN
		@clock = Rubygame::Clock.new
		@clock.target_framerate = 60
		@clock.enable_tick_events
 
		@screen = screen
		@screen.title = "Luchador"

		@background = Rubygame::Surface.load "background.png"
		@background.blit @screen, [ 0, 0]
		# or drawn with a single method invocation.
		@sprites = Rubygame::Sprites::Group.new
		Rubygame::Sprites::UpdateGroup.extend_object @sprites
		3.times do @sprites << FighterSprite.new end
		@sprites.draw @screen
 

		@screen.flip()

		@event_queue = Rubygame::EventQueue.new
		@event_queue.enable_new_style_events

	end

	def update

	end

	def event_input
		should_run = true
		while should_run do
 
  			seconds_passed = @clock.tick().seconds
 
  			@event_queue.each do |event|
    			case event
      				when Rubygame::Events::QuitRequested, Rubygame::Events::KeyReleased
        			should_run = false
    			end
  			end
  		end
	end
end


game = Game.new()

game.event_input