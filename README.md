# paas-submit

Embedable form widgets for product page

## Usage

* Deploy to somewhere.
* Visit the app in browser for instructions on how to embed the various form widgets.

## Configuration

The following environment variables should be set for correct deployment

| variable | required | description |
|---|---|---|
| `DESKPRO_API_KEY` | yes | agent api key |
| `DESKPRO_ENDPOINT` | yes | endpoint url (ie "https://accountname.deskpro.com") |
| `DESKPRO_TEAM_ID` | no | id of team to assign tickets to |

## Development

To start the server locally in development mode:

```
DESKPRO_TEAM_ID=1 DESKPRO_API_KEY='REDACTED' DESKPRO_ENDPOINT='https://account.deskpro.com' make dev
```

For info on other tasks such as rebuilding css assets:

```
make help
```

