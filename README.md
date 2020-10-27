# Github action: Publish to Forgebox

This GitHub Action publishes your Github project to Forgebox.

## Setup

### Project secret variables

First off, you will need to create at least a single **secret** variable in your Github project for the action:

* `FORGEBOX_PASS`

See [Creating encrypted secrets for a repository](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-a-repository) for a guide from Github.

This will be used to authenticate your user for publishing to Forgebox. You may also wish to hide your user name this way, but it is not essential.

## Usage in Github actions workflow

Create a github workflow to publish your project (or add the steps below to your existing flows):

```yml
# .github/workflows/publish.yml
name: Publish to forgebox
# you may wish to trigger this for other specifics, this is an example
on: 
  push:
    tags: 
      - v*

jobs:
  publish:
    name: Publish to forgebox
    runs-on: ubuntu-latest
    steps:

    # this step gets your code checked out!
    - uses: actions/checkout@v2
        with:
          fetch-depth: 0
    
    # this is the usage of this box publish action
    - uses: pixl8/github-action-box-publish@v1
      env:
      	FORGEBOX_USER: myforgeboxuser
      	FORGEBOX_PASS: ${{ secrets.FORGEBOX_PASS }}
```

## Environment variable substition

By default, this action attempts to replace any variables in your `box.json` file with environment variables before publishing. For example, in your `box.json` you may have:

```json
{
    "name":"Test package",
    "slug":"test-my-package",
    "type":"modules",
    "version":"${VERSION_NUMBER}",
    "location":"${DOWNLOAD_URL}"
}
```

Then, in your Github actions workflow you could do:

```yml
steps:
  - uses: actions/checkout@v2
    with:
      fetch-depth: 0
  
  # add extra steps here that set VERSION_NUMBER and 
  # DOWNLOAD_URL env vars

  - uses: pixl8/github-action-box-publish@v1
    env:
      FORGEBOX_USER: pixl8
      FORGEBOX_PASS: ${{ secrets.FORGEBOX_PASS }}
      DOWNLOAD_URL: ${{ env.DOWNLOAD_URL }}
      VERSION_NUMBER: ${{ env.VERSION_NUMBER }}
```

## Additional env vars

### `DO_ENV_SUBSTITUTION`

This defaults to `true` and means that you can pass in environment variables to replace in your `box.json` file before it is published (see above). Set this to `false` if you do not wish this substitution to run.

### `BOXJSON_DIR`

If your `box.json` file does not live in the root of your project, set this variable to the directory that contains it, relative to the project root. e.g.

```yml
- uses: pixl8/github-action-box-publish@v1
  env:
    FORGEBOX_USER: pixl8
    FORGEBOX_PASS: ${{ secrets.FORGEBOX_PASS }}
    BOXJSON_DIR: /build
```

**Note:** must start with `/` and have no trailing slash.