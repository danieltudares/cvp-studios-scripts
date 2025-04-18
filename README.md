# Cloudvision Studios API scripts

## Setup

1. Install requirements (Skip this if you run the devcontainer).

```shell
pip install -r requirements.txt
```

2. Authenticating with CloudVision.

- Create folder `cred` and add empty `token.tok` file.
```shell
mkdir cred
touch cred/token.tok
```

- Generate a token: [Token based authentication](https://aristanetworks.github.io/cloudvision-apis/connecting/#token-based-authentication) and paste token inside `token.tok`.

- For on-prem CVP you also need the SSL certificate. This can be downloaded by login in CVP and go to `Setting` > `Certificates` > `Export`.[Certificate export instructions](https://www.arista.io/help/2025.1/articles/c2V0dGluZ3MuQWxsLkNlcnRpZmljYXRlcw==#certificates). 
Place the certificate inside the `cred` folder as `CVP.crt`.

```shell
ls cred/
  CVP.crt  
  token.tok
```

## Instructions

1. Run the `studio_update.py` script with the `--operation get` flag to import the Campus Studio inputs as YAML.

```python
python studios_scripts/studio_update.py --server 10.18.167.70:443 --token-file cred/token.tok --operation get --cert-file cred/CVP.crt --studio-id studio-avd-campus-fabric
```

This will automatically create a file named `studios-avd-campus-fabric-inputs.yaml`. This is an [example exported file](studios_scripts/studio-avd-campus-fabric-inputs.yaml).

2. Create and assign tags by modifying the `tag_scripts/tags.yaml` file. You need to create all required tags that are used by the Campus Studios. This is an [example tags YAML file](tag_scripts/tags.yaml).


3. Run the `manage_tags.py` script with the flag `--create-and-assign`.

```python
python tag_scripts/manage_tags.py --server 10.18.167.70:443 --token-file cred/token.tok --cert-file cred/CVP.crt --file tag_scripts/tags.yaml --create-and-assign
```

4. Modify the exported Campus Studios YAML file to add new changes. This is an [example modified file](studios_scripts/studio-avd-campus-fabric-inputs-new.yaml).


5. Run the `manage_tags.py` script to import the new input YAML file into CVP

```python
python studios_scripts/studio_update.py --server 10.18.167.70:443 --token-file cred/token.tok --operation set --cert-file cred/CVP.crt --studio-id studio-avd-campus-fabric --yaml-file=studios_scripts/studio-avd-campus-fabric-inputs-new.yaml
```

This should create a change control in CVP. At this point, login into CVP to review and execute the changes. 


## Makefile shorcuts and examples

```text
get-tags                       Get CVP tags via Python script and save to file
create-tags                    Create CVP tags via Python script based on YAML file
assign-tags                    Assign CVP tags to devices via Python script based on YAML file
create-assign-tags             Create and Assign CVP tags to devices via Python script based on YAML file
unassign-tags                  Unassign CVP tags from devices via Python script based on YAML file

get-studios-input              Get Studios input (export) in for Campus fabric in YAML file
set-studios-input              Set Studios inputs (import) for Campus fabric based on YAML file

curl-active-streaming          Get all CVP devices actively streaming via Curl
curl-create-workspace          Create a workspace via Curl
curl-get-studios-config        Get Studios config via Curl
curl-inventory-all             Get all CVP inventory hostnames via Curl
curl-tags-getall               Get all device tags via Curl
```

## References and other examples

- [Studios GRPC/REST demo](https://github.com/noredistribution/studios-demo)
- [CloudVision APIs](https://aristanetworks.github.io/cloudvision-apis/)
- [CloudVision Studios and Workspace API examples](https://aristanetworks.github.io/cloudvision-apis/examples/rest/studios-and-workspaces/)
- [CloudVision python library](https://github.com/aristanetworks/cloudvision-python)
- [CVP Python tags V2 examples](https://github.com/aristanetworks/cloudvision-python/tree/trunk/examples/resources/tag/v2)
- [CVP Service Account Token creation](https://www.arista.io/help/articles/c2V0dGluZ3MuQWxsLmFjY2Vzc0NvbnRyb2wuc2VydmljZUFjY291bnRzLnRva2Vucw==)
