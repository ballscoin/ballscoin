.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/ballscoin/ballscoin/cmd/swarm
	go build -o bin/geth     github.com/ballscoin/ballscoin/cmd/geth
	go build -o bin/bootnode github.com/ballscoin/ballscoin/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/ballscoin/ballscoin/swarm/...
