#!/bin/bash

mkdir -p build
export BUILDDIR="$(pwd)/build"

if cd geph2; then git pull; else git clone https://github.com/geph-official/geph2.git; cd geph2; fi
go mod vendor

# Release build
export VERSION=$(git describe --tags)
export LDFLAGS="-X main.GitVersion=$VERSION -s -w -buildid="
cd cmd/geph-client

go clean -cache

echo "Building for Win32..."
GOOS=windows GOARCH=386 CGO_ENABLED=0 go build -v -ldflags "$LDFLAGS" -trimpath .
mv geph-client.exe $BUILDDIR/geph-client-windows-i386-$VERSION.exe

echo "Building for Lin32..."
GOOS=linux GOARCH=386 CGO_ENABLED=0 go build -v -trimpath -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-i386-$VERSION

echo "Building for Lin64..."
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -trimpath  -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-amd64-$VERSION

echo "Building for Lin64 [EXIT]..."
cd ../geph-exit
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -trimpath  -ldflags "$LDFLAGS" .
mv geph-exit $BUILDDIR/geph-exit-linux-amd64-$VERSION
cd ../geph-client

echo "Building for Lin64 [BRIDGE]..."
cd ../geph-bridge
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -trimpath  -ldflags "$LDFLAGS" .
mv geph-bridge $BUILDDIR/geph-bridge-linux-amd64-$VERSION
cd ../geph-client


echo "Building for LinArm32..."
GOOS=linux GOARCH=arm CGO_ENABLED=0 go build -v -trimpath -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-armeabi-$VERSION

echo "Building for LinArm64..."
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -v -trimpath -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-arm64-$VERSION

echo "Building for Mac64..."
GOOS=darwin GOARCH=amd64 CGO_ENABLED=0 go build -v -trimpath -ldflags "$LDFLAGS"
mv geph-client $BUILDDIR/geph-client-macos-amd64-$VERSION

echo "Building for Android..."
xgo -go 1.13.1 --targets=android-21/arm,android-21/arm64 -ldflags="$LDFLAGS" github.com/geph-official/geph2/cmd/geph-client
mv geph-client-android-21-arm $BUILDDIR/geph-client-android-armeabi-$VERSION
mv geph-client-android-21-arm64 $BUILDDIR/geph-client-android-arm64-$VERSION
