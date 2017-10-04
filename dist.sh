#!/bin/bash
# build binary distributions for linux/amd64 and darwin/amd64
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "working dir $DIR"
mkdir -p $DIR/dist
mkdir -p $DIR/.godeps
export GOPATH=$DIR/.godeps:$GOPATH
GOPATH=$DIR/.godeps gpm install

os=$(go env GOOS)
arch=$(go env GOARCH)
version=$(cat $DIR/version.go | grep "const VERSION" | awk '{print $NF}' | sed 's/"//g')
goversion=$(go version | awk '{print $3}')

echo "... skipping tests"
#echo "... running tests"
#./test.sh

for os in linux; do
    echo "... building v$version for $os/$arch"
    EXT=
    BUILD=/go/bin
    GOOS=$os GOARCH=$arch CGO_ENABLED=0 \
        go build -ldflags="-s -w" -o $BUILD/oauth2_proxy$EXT || exit 1
done
