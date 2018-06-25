{ pkgs, lib, config, options }:

{
  programs = {
	home-manager = {
		enable = true;
		path = https://github.com/rycee/home-manager/archive/release-18.03.tar.gz;
	};
	git = {
		enable = true;
		userName = "steffen";
		userEmail = "steffen@wir-hassen-menschen.de";
	};
	ssh = {
		enable = true;
		matchBlocks = {
			"whm" = {
				hostname = "wir-hassen-menschen.de";
				user = "steffen";
			};
		};
	};
	zsh = {
		enable = true;
		sessionVariables = {
			ZSH_TMUX_AUTOSTART = "true";
		};
		initExtra = ''
		'';
		plugins = [
			{
				name = "zsh-syntax-highlighting";
				src = pkgs.customlib.fetchLatestGit {
					url = "https://github.com/zsh-users/zsh-syntax-highlighting.git";
				};
			}
			{
				name = "zsh-completions";
				src = pkgs.customlib.fetchLatestGit {
					url = "https://github.com/zsh-users/zsh-completions.git";
				};
			}
			{
				name = "zsh-autosuggestions";
				src = pkgs.customlib.fetchLatestGit {
					url = "https://github.com/zsh-users/zsh-autosuggestions.git";
				};
			}
			{
				name = "zsh-tmux-plugin";
				file = "tmux.plugin.zsh";
				src = (pkgs.customlib.fetchLatestGit {
					url = "https://github.com/robbyrussell/oh-my-zsh.git";
				}) + "/plugins/tmux";
			}
			{
				name = "zsh_custom_conf";
				file = "init.zsh";
				src = pkgs.customlib.fetchLatestGit {
					url = "https://github.com/sdevmaster/zsh_custom_conf.git";
				};
			}		
		];
	};
  };
  home = {
	file = {
		".tmux.conf".text = pkgs.lib.readFile ./dotfiles/tmux.conf + ''
source "${pkgs.python27Packages.powerline}/share/tmux/powerline.conf"
			'';
		".ssh/id_rsa".source = ./sshKeys/id_rsa;
		".ssh/id_rsa.pub".source = ./sshKeys/id_rsa.pub;
		# ".zshrc".source = ./zsh/zshrc
	};
	packages = [ pkgs.tmux pkgs.python27Packages.powerline pkgs.powerline-fonts ];
  };
  nixpkgs.overlays = [(self: super: {
    }
  )];
}
