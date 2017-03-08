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

class MyGame < MyApp

	def create
		
		@shader = ShaderProgram.new(Gdx.files.internal("shaders/vert.glsl"), Gdx.files.internal("shaders/frag.glsl"))
		@shader.begin 
		raise @shader.log unless @shader.compiled?
		@shader.end
		@renderer = ShapeRenderer.new(6, @shader)
	end
	def render
		Gdx.gl.glClearColor(0.2, 0.2, 0.2, 1);
		Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
		@renderer.begin(ShapeRenderer::ShapeType::Filled)
		@renderer.rect(0,0,640,480)
		@renderer.end
	end

	def resize (width, height) 
	end

	def dispose
	end

end

custom_window(MyGame.new, 640, 480)

$stdin.read