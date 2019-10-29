#!/bin/bash

mkdir -p build
export BUILDDIR="$(pwd)/build"

if cd geph2; then git pull; else git clone https://github.com/geph-official/geph2.git; cd geph2; fi

# Release build
export VERSION=$(git describe --long)
export LDFLAGS="-X main.GitVersion=$VERSION -w -s"
cd cmd/geph-client

echo "Building for Win32..."
GOOS=windows GOARCH=386 CGO_ENABLED=0 go build -v -ldflags "$LDFLAGS" -asmflags -trimpath .
mv geph-client.exe $BUILDDIR/geph-client-windows-i386-$VERSION.exe

echo "Building for Lin32..."
GOOS=linux GOARCH=386 CGO_ENABLED=0 go build -v -asmflags -trimpath -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-i386-$VERSION

echo "Building for Lin64..."
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -v -asmflags -trimpath  -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-amd64-$VERSION

echo "Building for LinArm32..."
GOOS=linux GOARCH=arm CGO_ENABLED=0 go build -v -asmflags -trimpath -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-armeabi-$VERSION

echo "Building for LinArm64..."
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -v -asmflags -trimpath -ldflags "$LDFLAGS" .
mv geph-client $BUILDDIR/geph-client-linux-arm64-$VERSION
