# Useful nix hacks from:
# http://chriswarbo.net/projects/nixos/useful_hacks.html

let
	pkgs = import <nixpkgs> {};
	lib = pkgs.lib;
in
	rec {
		conditionalInclude = envVar: file:
			if builtins.getEnv envVar != ""
				then builtins.trace "Including: ${file} because ${envVar} is set" [ file ]
			else builtins.trace "Not including: ${file} because ${envVar} is not set" [];

		sanitiseName = lib.stringAsChars (c: if builtins.elem c (lib.lowerChars ++ lib.upperChars)
				then c
				else "");

		latestGitCommit = { url, ref ? "HEAD" }:
			pkgs.runCommand "repo-${sanitiseName ref}-${sanitiseName url}"
			{
				# Avoids caching. This is a cheap operation and needs to be up-to-date
				version = toString builtins.currentTime;

				# Required for SSL
				GIT_SSL_CAINFO = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

				buildInputs = [ pkgs.git pkgs.gnused ];
			}
			''
			  REV=$(git ls-remote "${url}" "${ref}") || exit 1
			  printf '"%s"' $(echo "$REV"        |
					  head -n1           |
					  sed -e 's/\s.*//g' ) > "$out"
			'';

		fetchLatestGit = { url, ref ? "HEAD" }@args:
			with { rev = import (latestGitCommit { inherit url ref; }); };
			fetchGit (removeAttrs (args // { inherit rev; }) [ "ref" ]);
	}
