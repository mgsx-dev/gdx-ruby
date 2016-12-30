require 'gdx'
include GDX

require 'irb/completion'

# WITH jruby :
# jruby -I lib lib/playground.rb

# WITH jirb :

# jirb -I lib
# require 'lib/playground.rb'
# require 'irb/completion'
# $game.table.add("hello")
# $game.table.clear
# NO !!! => $game.table.add(Gdx.image("test.jpg")).expand.left.row
# YES !!! => Gdx.game{|game|game.table.add(Gdx.image("test.jpg")).expand.left.row}

# $game.table.stage.viewport = Java::ComBadlogicGdxUtilsViewport::StretchViewport.new(300,300)


$steps = [
	lambda{ 
		$game.table.clear
		tb = text_button("add an actor to game table at x=7 and press this button"){
			next_step if $game.table.children.size > 1 && $game.table.children.get(1).x = 7
			
		}
		$game.table.add(tb)
	},
	lambda{ 
		$game.table.clear
		$game.table.add("congrats !!!") 
	}
]

def next_step
	task = $steps.shift
	task.call if task
end


window(640, 480) do |app|

	app.skin = Skin.new(Gdx.files.internal("assets/uiskin.json"))

	app.table.add(img = image('test.jpg')).expandX.center

	img.origin=Align.center
	img.scaling=Scaling.fill

	img.on_click{

		img.addAction(Actions.sequence(
			Actions.scaleTo(2,2,1, Interpolation.pow5Out),
			Actions.scaleTo(1,1,1, Interpolation.pow5In)
			))
		next_step
	}

	#app.table.defaults.fill
	app.table.add("text_button(text){listener}")
	app.table.add(text_button("Button"){ puts "button has changed" })
	#app.table.add(text_button("Menu 2"){ app.table.add("a label") })
	#app.table.add(text_button("Menu 3"){ app.table.add(image('test.jpg')) })

	app.table.row

	app.table.add("select_box(items){listener}")
	app.table.add(select_box("A", "B", "C"){|sel| puts "item #{sel} selected" })
	app.table.row

	app.table.add(text_button("Press here now !!"){ puts "you can log to the console with ruby (p/puts) or LibGDX logger : Gdx.app.error('my TAG', my message')" })
	
end