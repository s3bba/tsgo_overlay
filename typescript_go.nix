{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  nix-update-script,
}:

let
  buildGoModule = buildGo126Module;
in
buildGoModule {
  pname = "typescript-go";
  version = "0-unstable-2026-03-12";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "417cc2007438c6b6fc610e44a60f2415416e96e1";
    hash = "sha256-6Kdhu3hR/GPLMl+vNDHzRh+8zzmmpzfgxgjxAUPI9nE=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-dUO6rCw8BrIJ+igFrntTIro4k1PH69G2J1IWPKsGzfM=";

  ldflags = [
    "-s"
    "-w"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [
    "cmd/tsgo"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    version="$("$out/bin/tsgo" --version)"
    [[ "$version" == *"7.0.0"* ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Go implementation of TypeScript";
    homepage = "https://github.com/microsoft/typescript-go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "tsgo";
  };
}
