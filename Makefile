# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: ballscoin android ios ballscoin-cross swarm evm all test clean
.PHONY: ballscoin-linux ballscoin-linux-386 ballscoin-linux-amd64 ballscoin-linux-mips64 ballscoin-linux-mips64le
.PHONY: ballscoin-linux-arm ballscoin-linux-arm-5 ballscoin-linux-arm-6 ballscoin-linux-arm-7 ballscoin-linux-arm64
.PHONY: ballscoin-darwin ballscoin-darwin-386 ballscoin-darwin-amd64
.PHONY: ballscoin-windows ballscoin-windows-386 ballscoin-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

ballscoin:
	build/env.sh go run build/ci.go install ./cmd/ballscoin
	@echo "Done building."
	@echo "Run \"$(GOBIN)/ballscoin\" to launch ballscoin."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/ballscoin.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/ballscoin.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

ballscoin-cross: ballscoin-linux ballscoin-darwin ballscoin-windows ballscoin-android ballscoin-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-*

ballscoin-linux: ballscoin-linux-386 ballscoin-linux-amd64 ballscoin-linux-arm ballscoin-linux-mips64 ballscoin-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-*

ballscoin-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/ballscoin
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep 386

ballscoin-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/ballscoin
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep amd64

ballscoin-linux-arm: ballscoin-linux-arm-5 ballscoin-linux-arm-6 ballscoin-linux-arm-7 ballscoin-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep arm

ballscoin-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/ballscoin
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep arm-5

ballscoin-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/ballscoin
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep arm-6

ballscoin-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/ballscoin
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep arm-7

ballscoin-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/ballscoin
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep arm64

ballscoin-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/ballscoin
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep mips

ballscoin-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/ballscoin
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep mipsle

ballscoin-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/ballscoin
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep mips64

ballscoin-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/ballscoin
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-linux-* | grep mips64le

ballscoin-darwin: ballscoin-darwin-386 ballscoin-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-darwin-*

ballscoin-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/ballscoin
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-darwin-* | grep 386

ballscoin-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/ballscoin
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-darwin-* | grep amd64

ballscoin-windows: ballscoin-windows-386 ballscoin-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-windows-*

ballscoin-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/ballscoin
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-windows-* | grep 386

ballscoin-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/ballscoin
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/ballscoin-windows-* | grep amd64
