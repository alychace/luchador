#!/usr/bin/ruby
# Luchador - and RPG battler.
# Copyright (C) 2014 Thomas Chace <tchacex@gmail.com

# Luchador is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Luchador is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygame'

directory = File.dirname(__FILE__)
PATH = File.expand_path(directory)

class Fighter
	def initialize hp, attack, defense, name, speed
		@name = name
		@hp = hp
		@attack = attack
		@defense = defense
		@speed = speed
		@attackup = 0
	end
	def hp
		@hp
	end
	def name
		@name
	end
	def attack
		@attack# + @attackup
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
	def bite
		@attackup = 1
	end
	def scratch
		@attackup = 0.5
	end

end

class CatSprite < Fighter
	include Rubygame::Sprites::Sprite
 
	def initialize name, position
    	super()
    	@name = name
		@hp = 10
		@attack = 8
		@defense = 5
		@speed = 10

    	@image = Rubygame::Surface.load File.join(PATH, "cat.png")
    	@rect  = @image.make_rect
    	@rect.topleft = position
	end
 	def update seconds_passed
  	end
  	def draw on_surface
    	@image.blit on_surface, @rect
  	end
end

class DogSprite < Fighter
	include Rubygame::Sprites::Sprite
 
	def initialize name, position
    	super()
		@name = name
		@hp = 10
		@attack = 6
		@defense = 7
		@speed = 7

    	@image = Rubygame::Surface.load File.join(PATH, "dog.png")
    	@rect  = @image.make_rect
    	@rect.topleft = position
	end
 	def update seconds_passed
  	end
  	def draw on_surface
    	@image.blit on_surface, @rect
  	end
end

Rubygame::TTF.setup
SCREEN = Rubygame::Screen.open [640, 480]

class Luchador
	def initialize screen = SCREEN
		@clock = Rubygame::Clock.new
		@clock.target_framerate = 60
		@clock.enable_tick_events
 
		@screen = screen
		@screen.title = "Luchador"

		@background = Rubygame::Surface.load File.join(PATH, "background.png")
		@background.blit @screen, [0, 0]
		# or drawn with a single method invocation.
		@dogs = Rubygame::Sprites::Group.new
		@cats = Rubygame::Sprites::Group.new
		Rubygame::Sprites::UpdateGroup.extend_object @dogs
		Rubygame::Sprites::UpdateGroup.extend_object @cats
		2.times do
			x = (30..320).to_a.sample
			y = (30..240).to_a.sample
			@cats << CatSprite.new("cat", [x, y])
		end
		2.times do
			x = (320..610).to_a.sample
			y = (240..450).to_a.sample
			@dogs << DogSprite.new("dog", [x, y])
		end
		@cats.draw @screen
		@dogs.draw @screen
		update_text
 
		@screen.flip()

		@event_queue = Rubygame::EventQueue.new
		@event_queue.enable_new_style_events
	end

	def update_text
		@font = Rubygame::TTF.new File.join(PATH, "Lato-Regular.ttf"), 20
		@text_surface = @font.render_utf8 "#{@dogs[0].name}: #{@dogs[0].hp}", true, [ 0xee, 0xee, 0x33]
		rt = @text_surface.make_rect
		rt.topleft = [8, 8]
		@text_surface.blit @screen, rt

		@text_surface = @font.render_utf8 "#{@dogs[1].name}: #{@dogs[1].hp}", true, [ 0xee, 0xee, 0x33]
		rt = @text_surface.make_rect
		rt.topleft = [8, 28]
		@text_surface.blit @screen, rt

		@text_surface = @font.render_utf8 "#{@cats[0].name}: #{@cats[0].hp}", true, [ 0xee, 0xee, 0x33]
		rt = @text_surface.make_rect
		rt.topleft = [8, 48]
		@text_surface.blit @screen, rt

		@text_surface = @font.render_utf8 "#{@cats[1].name}: #{@cats[1].hp}", true, [ 0xee, 0xee, 0x33]
		rt = @text_surface.make_rect
		rt.topleft = [8, 68]
		@text_surface.blit @screen, rt
	end

	def battle one, two
		if one.speed > two.speed
			two.hit one.attack
			one.hit two.attack
		else
			one.hit two.attack
			two.hit one.attack
		end
		puts "#{one.name}: #{one.hp}"
		puts "#{two.name}: #{two.hp}"
	end
	def update
		@background.blit @screen, [0, 0]
		@cats.draw @screen
		@dogs.draw @screen
		update_text
		@screen.flip()

	end
	def event_input
		should_run = true
		while should_run do
			update
  			seconds_passed = @clock.tick().seconds
  			@event_queue.each do |event|
    			case event
      				when Rubygame::Events::QuitRequested
        				should_run = false
        			when Rubygame::Events::KeyReleased
        				battle(@cats.sample, @dogs.sample)
        				for sprite in @cats + @dogs
        					if sprite.hp <= 0
        						sprite.kill
        					end
        				end
    			end
  			end
  		end
	end
end