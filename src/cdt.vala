using Gtk;
using GSound;

namespace Countdowntimer {
	public class MyTimer : Object {

		private uint handler = 0;
		private SourceFunc f;

		public MyTimer(owned SourceFunc f){
			this.f = (owned) f;
			this.handler = GLib.Timeout.add_full(GLib.Priority.HIGH, 1000, ()=>{return this.f();});
		}

		public void stop(){
			if (this.handler != 0){
				if (GLib.Source.remove(this.handler)){
					this.handler = 0;
				}
			}
		}

		public void start(){
			if (this.handler == 0){
				this.handler = GLib.Timeout.add_full(GLib.Priority.HIGH, 1000, ()=>{return this.f();});
			}
		}
	}


	[GtkTemplate (ui = "/org/gnome/CountDownTimer/cdtwin.ui")]
	public class MyWindow : Gtk.ApplicationWindow {

		private uint second = 8;

	    public string text {
                get { return label.label; }
                set { label.label = value; }
		}
		
		public signal void timeout(uint interval);

		[GtkChild]
		Gtk.Label label;

		[GtkChild]
		Gtk.EventBox evbox;

		[GtkChild]
		Gtk.SpinButton spinbutton;

		public MyWindow (Gtk.Application app) throws GLib.Error{
			Object (application: app);
			this.text = second.to_string();
			var sound_ctx = new GSound.Context();
			sound_ctx.init();
			sound_ctx.cache(GSound.Attribute.EVENT_ID, "message");
			sound_ctx.cache(GSound.Attribute.EVENT_ID, "complete");

			var timer = new MyTimer(()=>{
				this.timeout(1);
				return true;
			});
			timer.stop(); // 

			this.timeout.connect((t, i) => {
				t.second -= i;
				t.text = t.second.to_string();
				if (t.second == 5) {
					sound_ctx.play_full.begin(null, null, GSound.Attribute.EVENT_ID, "message");
				}
				if (t.second == 0 ){
					timer.stop();
					t.second = this.spinbutton.get_value_as_int();
					t.text = t.second.to_string();
					sound_ctx.play_full.begin(null, null, GSound.Attribute.EVENT_ID, "complete");
				}
			});
			
			this.evbox.button_release_event.connect((t, e) => {
				timer.start();
				return true;
			});

			this.spinbutton.value_changed.connect((t) => {
				this.second = t.get_value_as_int();
				this.text = this.second.to_string();
			});

		}
	}

	
}
