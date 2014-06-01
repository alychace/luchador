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
