#!/bin/bash

set -eu -o pipefail

unpriv(){
  sudo -u nobody "${@}"
}

dl() {
  unpriv curl -s --proxy http://127.0.0.1:8082 "${1}" | sudo tee "${2}" > /dev/null
}
