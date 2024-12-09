browser.proxy.onRequest.addListener(
	requestInfo => {
		const url = new URL(requestInfo.url)
		if (url.hostname.endsWith(".i2p")) {
			return { type: "http", host: "127.0.0.1", port: 4444 };
		} else {
			return { type: "http", host: "127.0.0.1", port: 65535 };
		}
	},
	{ urls: ["<all_urls>"] }
);

