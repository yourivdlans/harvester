# README

Are you using [Harvest](https://harvestapp.com) and [Moneybird](https://moneybird.com)? Then this is a solution for you.

Combining the excellent time tracking of Harvest with the amazing invoicing (and bookkeeping) of Moneybird Harvester will allow you to create invoices in Moneybird based on your uninvoiced hours from Harvest.

## Installation

Ensure a java runtime is available

`brew install openjdk@11`

Then run `bin/setup`.

### Moneybird

Create a [new API token](https://moneybird.com/user/applications/new) for personal use. For this app we only use the "Sales invoices" permission.

After saving the API token go back to edit it and set the Redirect URI to `http://localhost:3000/moneybird`.

Now edit `.env` and set `MONEYBIRD_CLIENT_ID` and `MONEYBIRD_CLIENT_SECRET`. Also set `MONEYBIRD_ADMINISTRATION_ID` with the id found in the url after logging in to Moneybird.

### Harvest

Create a [new API token](https://id.getharvest.com/oauth2/access_tokens/new) and edit `.env` and set `HARVEST_ID` and `HARVEST_TOKEN`.

## Usage

Start a rails server with `bin/rails s` and navigate your browser to `http://localhost:3000`.

You will be presented with a table of projects with uninvoiced hours from harvest. To authenticate the app with Moneybird you have to follow the instructions.

After you return to the app you will be able to select projects using a checkbox and picking a contact to create the invoice for.

Once you click `Create invoice` and a success message has been shown your invoice will have been created with Moneybird.
