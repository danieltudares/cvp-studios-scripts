### Generic Variables
SHELL := /bin/zsh

.PHONY: help
help: ## Display help message (*: main entry points / []: part of an entry point)
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


################################################################################
# cURL API CALLS EXAMPLES
################################################################################

.PHONY: curl-inventory-all
curl-inventory-all: ## Get all CVP inventory hostnames via Curl
	curl -L -kX GET --header 'Accept: application/json' -b access_token=`cat cred/token.tok` 'https://10.18.167.70/api/resources/inventory/v1/Device/all' | jq '.result.value | with_entries(select(.[])) | select(.streamingStatus=="STREAMING_STATUS_ACTIVE") | .hostname'

.PHONY: curl-active-streaming
curl-active-streaming: ## Get all CVP devices actively streaming via Curl
	curl -sS -kX GET --header 'Accept: application/json' -b access_token=`cat cred/token.tok` 'https://10.18.167.70/api/resources/inventory/v1/Device/all' -d '{"partialEqFilter": [{"streamingStatus":2}]}'

.PHONY: curl-tags-getall
curl-tags-getall: ## Get all device tags via Curl
	curl -sS -kX POST --header 'Accept: application/json' -b access_token=`cat cred/token.tok` 'https://10.18.167.70/api/resources/tag/v2/Tag/all' -d '{"partialEqFilter": [{"key":{"elementType":"ELEMENT_TYPE_DEVICE"}}]}'

.PHONY: curl-create-workspace
curl-create-workspace: ## Create a workspace via Curl
	curl -L -vvv -kX POST --header 'Accept: application/json, content-Type: application/json' -b access_token=`cat cred/token.tok` "https://10.18.167.70/api/resources/workspace/v1/WorkspaceConfig" -d @ws.json

################################################################################
# Studios API CALLS EXAMPLES
################################################################################

.PHONY: get-tags
get-tags: ## Get CVP tags via Python script and save to file
	python tag_scripts/get_tags.py --server 10.18.167.70:443 --token-file cred/token.tok --cert-file cred/CVP.crt >> tag_scripts/cvp_tags.txt

.PHONY: get-studios-input
get-studios-input: ## Get Studios input (export) in for Campus fabric in YAML file
	python studios_scripts/studio_update.py --server 10.18.167.70:443 --token-file cred/token.tok --operation get --cert-file cred/CVP.crt --studio-id studio-avd-campus-fabric 

.PHONY: set-studios-input
set-studios-input: ## Set Studios inputs (import) for Campus fabric based on YAML file
	python studios_scripts/studio_update.py --server 10.18.167.70:443 --token-file cred/token.tok --operation set --cert-file cred/CVP.crt --studio-id studio-avd-campus-fabric --yaml-file=studios_scripts/studio-avd-campus-fabric-inputs-new.yaml --build-only=True

.PHONY: create-tags
create-tags: ## Create CVP tags via Python script based on YAML file
	python tag_scripts/manage_tags.py --server 10.18.167.70:443 --token-file cred/token.tok --cert-file cred/CVP.crt --file tag_scripts/tags.yaml --create

.PHONY: assign-tags
assign-tags: ## Assign CVP tags to devices via Python script based on YAML file
	python tag_scripts/manage_tags.py --server 10.18.167.70:443 --token-file cred/token.tok --cert-file cred/CVP.crt --file tag_scripts/tags.yaml --assign

.PHONY: create-assign-tags
create-assign-tags: ## Create and Assign CVP tags to devices via Python script based on YAML file
	python tag_scripts/manage_tags.py --server 10.18.167.70:443 --token-file cred/token.tok --cert-file cred/CVP.crt --file tag_scripts/tags.yaml --create-and-assign

.PHONY: unassign-tags
unassign-tags: ## Unassign CVP tags from devices via Python script based on YAML file
	python tag_scripts/manage_tags.py --server 10.18.167.70:443 --token-file cred/token.tok --cert-file cred/CVP.crt --file tag_scripts/tags.yaml --unassign
