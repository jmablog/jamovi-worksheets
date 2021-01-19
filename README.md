# Jamovi Worksheets

A series of worksheets for basic statistical testing with [Jamovi](https://www.jamovi.org/). The HTML versions can be live previewed via GitHub pages at:

[https://jmablog.github.io/jamovi-worksheets/](https://jmablog.github.io/jamovi-worksheets/)

## Building the Word and PDF versions

These are written in Markdown for building via [Pandoc](https://pandoc.org/) and [Pandocomatic](https://heerdebeer.org/Software/markdown/pandocomatic/) into Word, HTML, and PDF formats. They also include a [Pandoc lua filter](https://pandoc.org/lua-filters.html) to make use of some formatting shortcodes, namely `::: Aside` and `::: Questions` for alert and question boxes.

To build:

1. First make sure Pandoc and Pandocomatic are installed
2. Move `shortcodes.lua` from the `templates` folder to the filters folder in your Pandoc data directory (by default, `~/.local/share/pancoc/filters`).
3. In the terminal navigate into the project directory and either run `./build.sh` or, if you'd like to customise the build location, the full Pandocomatic command:

```
pandocomatic -i input -o docs -c config.yaml --modified-only
```

Change `docs` to your desired output folder.

**Note:** The other templates are navigated to from the input files in the config.yaml file. If you want, you can move them elsewhere - into your Pandoc data directory, for example - but you'll need to change their file location in config.yaml as well. I suggest checking out [this section in the Pandocomatic manual](https://heerdebeer.org/Software/markdown/pandocomatic/#specifying-paths) for help on specifying file paths in the config.