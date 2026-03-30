
```bash
mkdir homelab
cd homelab

git init

uv venv
uv pip install mkdocs mkdocs-material
# activate venv
mkdocs --version # requires to be in the venv
```

Two different git branches exist: the `master`, and a `gh-pages` which only contains the static files (compiled HTML, CSS, JS) that Pages serve. They're independent, coexist, with no file sharing unless merged.

Note: how branches work. Each branch is a different version of the repo. With branch changes, git replaces files in the working directory to match the branch. This means files are added or removed automatically, pulled from the internal database.