{
  buildRubyGem,
  fetchFromGitHub,
  makeWrapper,
  lib,
  bundler,
  nix,
  nix-prefetch-git,
}:

buildRubyGem rec {
  inherit (bundler) ruby;

  name = "${gemName}-${version}";
  gemName = "bundix";
  version = "6599974b1b6afa8ac9c51d84f5b6c178a275d2c5";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "bundix";
    rev = version;
    hash = "sha256-zJQKsC9sId+ui2wZ0nUaDRP1SmzrNTWoDJxUdLoATqI=";
  };

  buildInputs = [
    ruby
    bundler
  ];
  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/bundix \
                --prefix PATH : "${nix.out}/bin" \
                --prefix PATH : "${nix-prefetch-git.out}/bin" \
                --prefix PATH : "${bundler.out}/bin" \
                --set GEM_HOME "${bundler}/${bundler.ruby.gemPath}" \
                --set GEM_PATH "${bundler}/${bundler.ruby.gemPath}"
  '';

  meta = {
    description = "Creates Nix packages from Gemfiles";
    longDescription = ''
      This is a tool that converts Gemfile.lock files to nix expressions.

      The output is then usable by the bundlerEnv derivation to list all the
      dependencies of a ruby package.
    '';
    homepage = "https://github.com/nix-community/bundix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      manveru
      zimbatm
    ];
    platforms = lib.platforms.all;
  };
}
