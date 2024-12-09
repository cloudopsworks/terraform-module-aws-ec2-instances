SHELL := /bin/bash
TRONADOR_AUTO_INIT := true
define PROVIDER_CHOMP
provider "aws" {
  alias = "default"
}
provider "aws" {
  alias = "account"
}
endef
export PROVIDER_CHOMP

# List of targets the `readme` target should call before generating the readme
export README_DEPS ?= docs/targets.md docs/terraform.md

-include $(shell curl -sSL -o .tronador "https://cowk.io/acc"; echo .tronador)

temp_provider:
	echo "$$PROVIDER_CHOMP" > provider.temp.tf

## Lint terraform code
lint: temp_provider
	$(SELF) tofu/install tofu/get-modules tofu/get-plugins tofu/lint tofu/validate
