class WebsocketClient : Object {
	private Soup.Session session;
	private Soup.WebsocketConnection connection;
	private string user_token;
	public Json.Array ready_users { get; set;}

	public WebsocketClient (Soup.Session global_session, string user_token) {
		this.session = global_session;
		this.user_token = user_token;
	}

	public async void ws_connect () {
		Soup.Message request = new Soup.Message ("GET", @"wss://ws.revolt.chat?token=$(user_token)");

		connection = yield session.websocket_connect_async (request, null, null, 1, null);
		connection.keepalive_interval = 20;
		connection.set_max_incoming_payload_size (0);

		connection.error.connect (on_error);
		connection.closed.connect (on_closed);
		connection.message.connect (on_message);
	}

	private void on_message (int type, Bytes msg) {
		if (type != Soup.WebsocketDataType.TEXT) return;

		string response = (string) msg.get_data ();
		// message(response);

		Json.Parser parser = new Json.Parser ();
		parser.load_from_data (response);
		var root = parser.get_root().get_object ();

		if (root.get_string_member ("type") == "Ready") {
			this.ready_users = root.get_array_member ("users");
		};
	}

	private void on_error (Error err) {
		message (@"Websocket error: $(err.message)");
	}

   //  private void on_open () {
		 // message ("open");
   //  }

	private void on_closed () {
		message ("closed");
	}
}

