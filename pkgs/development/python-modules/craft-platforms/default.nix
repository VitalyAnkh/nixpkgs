{
  lib,
  buildPythonPackage,
  annotated-types,
  distro,
  fetchFromGitHub,
  nix-update-script,
  hypothesis,
  pytest-check,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "craft-platforms";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-platforms";
    tag = version;
    hash = "sha256-BFs+LqcJWqKMgEr7IzyP5qME+zaV6EFc79ustOB1Cno=";
  };

  postPatch = ''
    substituteInPlace craft_platforms/__init__.py --replace-fail "dev" "${version}"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    annotated-types
    distro
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-check
  ];

  pythonImportsCheck = [ "craft_platforms" ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage platforms and architectures for charm applications";
    homepage = "https://github.com/canonical/craft-platforms";
    changelog = "https://github.com/canonical/craft-platforms/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
