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
  version = "7.0.0-dev.20260412.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "cf6d69d83c999e5e12ec9d81aec3883fe8d8b110";
    hash = "sha256-S0HrmAlyarEWGswmRnK0L1UYIarBW2y+QfdPxD1ppE8=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-YmKVn9fc7dKMBiXnutI15mg/BFCyvyXntr7QaxJ7qU8=";

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
