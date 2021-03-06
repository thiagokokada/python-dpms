with import <nixpkgs> {};
let
  venvDir = "./venv";
  pythonEnv = python38.withPackages (ps: with ps; [
    pip
    setuptools
    wheel
  ]);
in mkShell {
  name = "i3pyblocks";
  buildInputs = [
    binutils
    gcc
    glib
    pythonEnv
    xorg.libX11
    xorg.libXext
  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)

    echoerr() { echo "$@" 1>&2; }

    if [ -d "${venvDir}" ]; then
      echoerr "Skipping venv creation, '${venvDir}' already exists"
    else
      echoerr "Creating new venv environment in path: '${venvDir}'"
      ${pythonEnv.interpreter} -m venv "${venvDir}" 1>&2
    fi

    source "${venvDir}/bin/activate"

    pip install -e .
  '';
}

