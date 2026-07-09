
# How this doc is built

Documentation is written using `mkdocs` and `mkdocs-material`; the site can be served with `mkdocs serve`, with the Python env synced. All documentation is written in a separate git branch `gh-pages`, which allows for static serving using GitHub Pages.

??? question "How do git branches work?"

    Each branch is a different version of the repo. With branch changes, git replaces files in the working directory to match the branch. This means files are added or removed automatically, pulled from the internal database.

mkdocs can [automatically compile and push to Pages](https://www.mkdocs.org/user-guide/deploying-your-docs/). The `docs/` dir and `mkdocs.yml` lives in the `master` source branch, and the `mkdocs gh-deploy` command builds and commits to the `gh-pages` branch of GitHub.

Ideally, all this documentation would follow a similar (simpler) approach to all this [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code)

## `journal/` directory

Este directorio es un cuaderno de bitácora. Contiene archivos `YYYY-MM-DD.md` que llevan el registro de los cambios aplicados sobre el sistema. Cada uno de estos archivos tiene la forma

This directory is a logbook. It contains `YYYY-MM-DD.md` files that record the changes applied to the system. Each of these lines has the following form

```markdown
# YYYY-MM-DD

## Overview

Summary with the applied changes and the main reasong behind it.

Also, a brief list of notes and todo things.

## Details

More thoughtful description of the procedure and steps taken. These are the traces we would use if we need to trace back changes, see the state of the system or know why we did something.

## Snapshots

Report any snapshot, to be able to identify snapshots themselves.
```

This reports are the traces we would use to recover the state of the system or the reason behind any change, so ensure all this is in the document at the moment of writing.

Como nota, creo que estos archivos no deberían ser públicos. Los escribo rápido mientras trabajo, es más fácil que se me cuele algo que no debería hacer público. Así puedo controlar más granularmente también qué información se hace pública, de forma más manual. Esto también implica incluirlos en los backups "externos" a git, o encriptarlos en git-crypt.
