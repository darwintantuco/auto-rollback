# auto-rollback

[![Build Status](https://travis-ci.org/dcrtantuco/auto-rollback.svg?branch=master)](https://travis-ci.org/dcrtantuco/auto-rollback)

Custom `post-checkout` git hook to auto rollback new migrations on git checkout

`git config` is used to set rollback status

Backup existing `post-checkout` hook

![sample](demo.gif)

## Installation

### npm

```
npm install -g auto-rollback
```

## Usage

Execute `auto-rollback` on a git repository

Supported apps:

- rails

### Show current rollback status

```
auto-rollback status
```

### Enable auto migrate on git checkout

```
auto-rollback enable
```

### Disable auto migrate on git checkout

```
auto-rollback disable
```

## How auto rollback on rails work?

After `git checkout`:

1. Checkout `db/migrate/` from previous branch
1. Get migration versions
1. Execute `bundle exec rake db:migrate:down VERSION=<version>` for each version
1. Undo all changes in `db/migrate/` and `db/schema.rb`

The flow will be less complicated if `pre-checkout` git hook exist

### Note

- Assumes all migration are reversible
- `bundle exec rake db:migrate:down VERSION=<version>` fails silently

## License

MIT
