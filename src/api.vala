public errordomain FetchError {
    FAILED_REQUEST,
    FAILED_TO_PARSE,
}

class RevoltApi : Object {
    static string api_url = "https://api.revolt.chat";
    private Soup.Session session;

    public RevoltApi (Soup.Session global_session) {
		this.session = global_session;
    }

    public async Json.Array fetchDMs() throws Error {
		Soup.Message request = new Soup.Message ("GET", @"$(api_url)/users/dms");
		request.get_request_headers ().append ("X-Session-Token", "TOKEN");

		Bytes request_bytes = yield session.send_and_read_async (request, Priority.DEFAULT, null);

		if (request.status_code != 200) {
            throw new FetchError.FAILED_REQUEST(@"Failed request. HTTP Status: $(request.status_code)");
        }

	    string json_data = (string) request_bytes.get_data ();

	    Json.Parser parser = new Json.Parser ();
	    parser.load_from_data (json_data);

        return parser.get_root().get_array ();
    }
}

