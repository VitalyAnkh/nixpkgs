{
  lib,
  awscrt,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  jmespath,
  python-dateutil,
  urllib3,

  # tests
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.38.32"; # N.B: if you change this, change boto3 and awscli to a matching version
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boto";
    repo = "botocore";
    tag = version;
    hash = "sha256-KW9EAeunL3+pccGsrFitonc5EHdm2Cd+7dM3kdvdkvM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jmespath
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/functional"
  ];

  pythonImportsCheck = [ "botocore" ];

  optional-dependencies = {
    crt = [ awscrt ];
  };

  meta = {
    description = "Low-level interface to a growing number of Amazon Web Services";
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
