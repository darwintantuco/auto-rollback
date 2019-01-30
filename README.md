# Rollback

[![Build Status](https://travis-ci.org/dcrtantuco/rollback.svg?branch=master)](https://travis-ci.org/dcrtantuco/rollback)

Custom `post-checkout` git hook to auto revert any migration when performing git checkout

Backup existing `post-checkout` hook

## Installation

### npm

```
npm install -g rollback
```

## Usage

Execute `rollback` on a git repository

Supported apps:

- rails

### Enable auto migrate on git checkout

```
rollback --enable
```

### Disable auto migrate on git checkout

```
rollback --disable
```

## How auto revert on rails work?

1. It compares the HEAD and previous branch, then get all unique migrations versions
1. Execute `bundle exec rake db:migrate:down VERSION=<version>` on each version
1. Undo any changes on `db/schema.rb`
1. Proceed with `git checkout`

### Notes

- Assumes all migration are reversible
- `bundle exec` fails silently

## License

MIT
