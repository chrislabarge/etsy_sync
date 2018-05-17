# Etsy Store Sync

This is a Ruby program I made in order to sync a customers Etsy store with a seperate static website.

The code is currently designed for my specific use case, but if you have any need for similar functionality, drop me a line and I will make it alittle more modular.

## Current Workflow
- Customer adds new products to their Etsy shop/store.
- Program is ran.
- Uses Etsy API to ask for item data.
- Generates markdown files of any new items.
- Saves the files to the development repo

## Instructions - for me :)

- git pull in "development" static generator folder (sync with master)
- git pull in "public" static generator folder (sync with master)
- run `rake sync`
- run `rake import new` for first 25 synced
- *If there are any changes in the development repo, then compile to production repo and commit changes in both.*
- git push in "development"
- git push in "public/production"

## TODO
- Automate the process of compiling to production and push the changes. One command bliss.
- Allow for more generic use cases.
- Rather then generating mardown, have it generate JSON or sanitize/format the incoming JSON from Etsy API to cut out acouple steps.
