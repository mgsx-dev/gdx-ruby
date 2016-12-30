require 'gdx'
include GDX

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


window(640, 480) do |app|

	app.table.add(img = image('test.jpg'))

	img.origin=Align.center
	img.scaling=Scaling.fill

	img.on_click{
		img.addAction(Actions.sequence(
			Actions.scaleTo(2,2,1, Interpolation.pow5Out),
			Actions.scaleTo(1,1,1, Interpolation.pow5In)
			))
	}

	#app.table.defaults.fill
	app.table.add(text_button("Menu 1"){ app.table.clear })
	app.table.add(text_button("Menu 2"){ app.table.add("a label") })
	app.table.add(text_button("Menu 3"){ app.table.add(image('test.jpg')) })


	app.table.add(text_button("Hello"){ puts "ok" })
	
end