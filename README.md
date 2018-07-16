# Github Repository Downloader

This project will download all of the repositories for a specific team under an organization.

## Setup

Create a ```config/prod.exs``` file with the necessary configuration variables.
To get an access token from GitHub, [click here](https://github.com/settings/tokens)

Example ```prod.exs``` file:
```
config :github_repo_downloader,
  access_token: "1234567890",
  organization: "MyOrganization"
```

You can also place this in the ```config/config.exs``` if you prefer.

## Run

To run the program, run the following command: ```mix start```.

If you've placed the configuration in ```config/prod.exs```, run ```MIX_ENV=prod mix start```.