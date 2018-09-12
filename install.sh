nix-shell https://github.com/rycee/home-manager/archive/release-18.03.tar.gz -A install
echo "home-manager installed. To build config, run \"home-manager switch\"."
echo "Do not forget to add ssh-keys afterwards. (./sshKeys/id_rsa and ./sshKeys/id_rsa.pub)"
