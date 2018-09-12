let 
	custom = import ./utils.nix;
in
{
  allowUnfree = true;

  packageOverrides = pkgs: rec {
	customlib = custom;
  };
}
