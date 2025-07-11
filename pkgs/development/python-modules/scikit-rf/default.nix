{
  stdenv,
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  pandas,
  matplotlib,
  nbval,
  pyvisa,
  networkx,
  ipython,
  ipykernel,
  ipywidgets,
  jupyter-client,
  sphinx-rtd-theme,
  sphinx,
  nbsphinx,
  openpyxl,
  setuptools,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "scikit-rf";
  version = "1.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-rf";
    repo = "scikit-rf";
    tag = "v${version}";
    hash = "sha256-Ovrr1U7VuuGKDNSBSCyYSz3DNpaJrA57ccl4AFdzC5E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    pandas
  ];

  optional-dependencies = {
    plot = [ matplotlib ];
    xlsx = [ openpyxl ];
    netw = [ networkx ];
    visa = [ pyvisa ];
    docs = [
      ipython
      ipykernel
      ipywidgets
      jupyter-client
      sphinx-rtd-theme
      sphinx
      nbsphinx
      openpyxl
      nbval
    ];
  };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { MPLBACKEND = "Agg"; };

  nativeCheckInputs = [
    pytest-mock
    matplotlib
    pyvisa
    openpyxl
    networkx
    pytestCheckHook
    pytest-cov-stub
  ];

  # test_calibration.py generates a divide by zero error on darwin
  # https://github.com/scikit-rf/scikit-rf/issues/972
  disabledTestPaths = lib.optional (
    stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin
  ) "skrf/calibration/tests/test_calibration.py";

  pythonImportsCheck = [ "skrf" ];

  meta = with lib; {
    description = "Python library for RF/Microwave engineering";
    homepage = "https://scikit-rf.org/";
    changelog = "https://github.com/scikit-rf/scikit-rf/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lugarun ];
  };
}
