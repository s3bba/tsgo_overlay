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
  version = "7.0.0-dev.20260403.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typescript-go";
    rev = "281b3d0720ab3de6d330d211705cb0383b47500b";
    hash = "sha256-schtpN2X47LY64opPiLBKs3M3XpmwGeiSQpn7Ju5d1E=";
    fetchSubmodules = false;
  };

  vendorHash = "sha256-RlO+dSEXy0939Wcqe7wa3/hakNMqWHwvUwVQzn3JHgs=";

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
