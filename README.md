# This read me is still WIP

# Cloudvision Studios API scripts

## Setup

1. Install requirements (Skip this if you run the devcontainer)

```shell
pip install -r requirements.txt
```

2. Authenticating with CloudVision

- Create folder `cred` and add empty `token.tok` file
```shell
mkdir cred
touch cred/token.tok
```

- Generate a token: [Token based authentication](https://aristanetworks.github.io/cloudvision-apis/connecting/#token-based-authentication) and paste token inside `token.tok`

- For on-prem CVP you also need the SSL certificate. This can be downloaded by login in CVP and go to `Setting` > `Certificates` > `Export`. Place the certificate inside the `cred` folder as `CVP.crt`

```shell
ls cred/
  CVP.crt  
  token.tok
```




