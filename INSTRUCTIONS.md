# Cloning this repository

The Source repo uses two submodules, the [EpiDoc Example Stylesheets](https://github.com/EpiDoc/Stylesheets), and the TEI Stylesheets. To clone a copy, run:

```bash
git clone --recurse-submodules git@github.com:EpiDoc/Source.git
```

If you cloned without the `--recurse-submodules` flage, then (inside the `Source` repo) run:

```bash
git submodule update --init --recursive
```

The submodules can be updated as needed using the `git submodule update --recursive` command. Or you can change to the submodule directory and run `git pull`.
