package commands.api;

using StringTools;

class Github {
	public static function authenticate(url:String, http:sys.Http) {
		if(url.startsWith("https://github.com/") || url.startsWith("https://api.github.com/") || url.startsWith("http://github.com/") || url.startsWith("http://api.github.com/")) {
			if(Sys.getEnv("GITHUB_TOKEN") != null)
				http.setHeader("Authorization", "token " + Sys.getEnv("GITHUB_TOKEN"));
		}
	}

	public static var userAgent:String = "CodenameEngineUpdater";
	public static function requestText(url:String)
	{
		var r = null;
		var h = new sys.Http(url);
		h.setHeader("User-Agent", userAgent);
		authenticate(url, h);

		h.onStatus = function(s)
		{
			if(s == 403 || s == 429) {
				Sys.println('Github API rate limit exceeded, please wait a few minutes and try again.');
				Sys.exit(1);
			}
			if (isRedirect(s))
				r = requestText(h.responseHeaders.get("Location"));
		};

		h.onData = function(d)
		{
			if (r == null)
				r = d;
		}
		h.onError = function(e)
		{
			throw e;
		}

		h.request(false);
		return r;
	}

	public static function requestBytes(url:String)
	{
		var r = null;
		var h = new sys.Http(url);
		h.setHeader("User-Agent", userAgent);
		authenticate(url, h);

		h.onStatus = function(s)
		{
			if (isRedirect(s))
				r = requestBytes(h.responseHeaders.get("Location"));
		};

		h.onBytes = function(d)
		{
			if (r == null)
				r = d;
		}
		h.onError = function(e)
		{
			throw e;
		}

		h.request(false);
		return r;
	}

	private static function isRedirect(status:Int):Bool
	{
		switch (status)
		{
			// 301: Moved Permanently, 302: Found (Moved Temporarily), 307: Temporary Redirect, 308: Permanent Redirect  - Nex
			case 301 | 302 | 307 | 308:
				//Logs.traceColored([Logs.logText('[Connection Status] ', BLUE), Logs.logText('Redirected with status code: ', YELLOW), Logs.logText('$status', GREEN)], WARNING);
				return true;
		}
		return false;
	}

	public static function getLatestCommit(repo:String, branch:String = "master"):String {
		var url = 'https://api.github.com/repos/$repo/branches/$branch';

		var data:String = requestText(url);
		var json:Dynamic = haxe.Json.parse(data);
		return json.commit.sha;
	}
}