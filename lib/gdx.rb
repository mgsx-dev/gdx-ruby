
require 'java'

require 'thread'

libdir = File.dirname(__FILE__) + '/../jars'
p libdir
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require libdir+'/gdx.jar'

require libdir+'/gdx-backend-lwjgl.jar'
require libdir+'/gdx-platform-natives-desktop.jar'
#require libdir+'/gdx-backend-lwjgl-natives.jar'
require libdir+'/lwjgl-platform-natives-linux.jar'
require libdir+'/lwjgl.jar'

java_import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
java_import com.badlogic.gdx.backends.lwjgl.LwjglApplication
java_import com.badlogic.gdx.ApplicationAdapter

def import(i)
	java_import i
end

import com.badlogic.gdx.Gdx;
import com.badlogic.gdx.graphics.GL20;
import com.badlogic.gdx.graphics.Texture;
import com.badlogic.gdx.graphics.glutils.ShapeRenderer;
import com.badlogic.gdx.graphics.glutils.ShaderProgram;
import com.badlogic.gdx.graphics.g2d.TextureRegion;
import com.badlogic.gdx.graphics.g2d.BitmapFont;
import com.badlogic.gdx.scenes.scene2d.Stage;
import com.badlogic.gdx.scenes.scene2d.ui.Image;
import com.badlogic.gdx.scenes.scene2d.ui.SelectBox;
import com.badlogic.gdx.scenes.scene2d.ui.Label;
import com.badlogic.gdx.scenes.scene2d.ui.TextButton;
#import com.badlogic.gdx.scenes.scene2d.ui.TextButton.TextButtonStyle;
import com.badlogic.gdx.scenes.scene2d.ui.Skin;
import com.badlogic.gdx.scenes.scene2d.ui.Table;
import com.badlogic.gdx.utils.Scaling;

import com.badlogic.gdx.scenes.scene2d.actions.Actions;
import com.badlogic.gdx.scenes.scene2d.utils.ClickListener;
import com.badlogic.gdx.scenes.scene2d.utils.ChangeListener;
import com.badlogic.gdx.utils.Align;
import com.badlogic.gdx.math.Interpolation;

module Java
	module ComBadlogicGdxScenesScene2dUi
		class Image
			def on_click(&block)
				addListener(listener = Class.new(ClickListener) {
				  def clicked(event, x, y)
				    on_click.call(event,x,y)
				  end
				}.new)
				listener.class.module_eval { attr_accessor :on_click}
  				listener.on_click = block
			end
		end
	end
end

module GDX

	class MyApp < ApplicationAdapter
		attr_accessor :skin, :stage
		def initialize(&block) ; @created_callback = block ; end
		def table ; @root ; end

		def create
			@stage = Stage.new;
			Gdx.input.setInputProcessor(@stage);

			skin = @skin = Skin.new

			defaultFont = BitmapFont.new
			skin.add "default", defaultFont
			
			style = Label::LabelStyle.new
			style.font = defaultFont
			skin.add "default", style

			style = TextButton::TextButtonStyle.new
			style.font = defaultFont
			skin.add "default", style

			@root = Table.new(skin)
			@root.setFillParent true
			@stage.addActor @root
			# @root.debug
			
			begin
			@created_callback.call(self) if @created_callback
			rescue java.lang.Throwable => e
				e.printStackTrace
				return
			rescue Exception => e
				puts e # XXX
				return
			end
		end

		def dispose 
			@stage.dispose();
		end

		def render 
			Gdx.gl.glClearColor(0.2, 0.2, 0.2, 1);
			Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT);
			@stage.act([Gdx.graphics.getDeltaTime(), 1 / 30.0].min);
			@stage.draw
		end

		def resize (width, height) 
			@stage.getViewport().update(width, height, true);
		end

		def add(actor)
			@root.add actor
		end
	end

	def window(width = nil, height = nil, &block)
		custom_window(MyApp.new(&block))
	end

	def custom_window(app, width = nil, height = nil)
		config = LwjglApplicationConfiguration.new
		config.width = width if width
		config.height = height if height
		config.forceExit = true
		LwjglApplicationConfiguration.disableAudio = true
		$game = app
		$queue = Queue.new
		Thread.new{
			LwjglApplication.new($game, config);
		}
		$game
	end

	def image(path)
		img = Image.new TextureRegion.new Texture.new Gdx.files.internal(path)
	end

	def array(elements)
		array = Java::ComBadlogicGdxUtils::Array.new
		elements.each{|e|array.add e}
		array
	end

	def select_box(*items, &block)
		actor = SelectBox.new($game.skin)
		actor.items = array(items)
		actor.add_listener(on_change(&lambda{|e,a|block.call(a.selected)}))
		actor
	end

	def text_button(text, &block)
		bt = TextButton.new(text, $game.skin)
		bt.addListener(on_change(&block))
		return bt
	end

	def on_change(&block)
		listener = Class.new(ChangeListener) {
		  def changed(event, actor)
		    listener.call(event,actor)
		  end
		}.new
		listener.class.module_eval { attr_accessor :listener}
		listener.listener = block
		listener
	end

	def game(&block)
		Gdx.app.postRunnable(runnable{
			begin
				block.call($game)
			rescue java.lang.Throwable => e
				e.printStackTrace
			rescue Exception => e
				puts e # XXX
			end
			})
	end

	def runnable(&block)
		listener = Class.new(Java::JavaLang::Object) {
			include Java::JavaLang::Runnable
		  def run
		    block.call
		  end
		}.new
		listener.class.module_eval { attr_accessor :block}
		listener.block = block
		listener
	end


end