SHELL := /bin/bash

MODULE := github.com/gabeduke/goleet
PROC_CMD := :golang:E::go::/usr/local/bin/gorun:OC
BINFMT_MISC := /proc/sys/fs/binfmt_misc
BINFMT_MISC_GO := $(BINFMT_MISC)/golang
GORUN := /usr/local/bin/gorun

BIN := $(abspath bin)
SCRIPTS := $(shell basename $(dir $(wildcard ./scripts/*/)))
SCRIPTS_ABS := $(foreach script,$(SCRIPTS),$(BIN)/$(script))

.DEFAULT_GOAL = help

asdf:
	@echo $(shell basename $(SCRIPTS_ABS))

##########################################################
##@ INIT
##########################################################
.PHONY: init

init: $(GORUN) $(BINFMT_MISC_GO)						## Download golang tool 'gorun' and register the extension in /proc

$(GORUN):
	$(info installing gorun..)
	@$(shell go get -u github.com/erning/gorun)
	@$(shell sudo mv ~/go/bin/gorun /usr/local/bin/)

$(BINFMT_MISC_GO):
	$(info installing binary proc extension..)
	@echo '$(PROC_CMD)' | sudo tee /proc/sys/fs/binfmt_misc/register

##########################################################
##@ GO
##########################################################
.PHONY: build clean

build: $(BIN) $(SCRIPTS_ABS)							## Build all of the scripts in `scripts/`
	$(info Build directory is $(BIN))


clean: check											## Remove the `bin/` directory
	$(info deleting $(BIN)..)
	@rm -r $(BIN)
	$(info success)

check:
	$(info Delete $(BIN)? [Y/n])
	@read line; if [[ $$line == "n" ]]; then echo aborting; exit 1 ; fi

$(BIN):
	@mkdir -p $(BIN)

$(SCRIPTS_ABS):
	$(info building $(shell basename $@)..)
	@go build -o $(BIN) ./scripts/$(shell basename $@)
	$(info build $(shell basename $@) success!)

##########################################################
##@ TEST
##########################################################
.PHONY: fmt test lint

fmt:													## fmt project
	go fmt ./...

test:													## test project
	go test ./... -race -coverprofile=coverage.txt -covermode=atomic

lint:													## lint project
	golangci-lint run

##########################################################
##@ DOCS
##########################################################
.PHONY: docs

docs:													## Serve package godocs
	$(info http://localhost:6060/pkg/$(MODULE))
	godoc -http=localhost:6060

##########################################################
##@ UTIL
##########################################################
.PHONY: help

help:													## show help
		@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m 	%s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)