# Jamovi Worksheets

A series of worksheets for basic statistical testing with [Jamovi](https://www.jamovi.org/). The HTML versions can be live previewed via GitHub pages at:

[https://jmablog.github.io/jamovi-worksheets/](https://jmablog.github.io/jamovi-worksheets/)

## Building the Word and PDF versions

These are written in Markdown for building via [Pandoc](https://pandoc.org/) and [Pandocomatic](https://heerdebeer.org/Software/markdown/pandocomatic/) into Word, HTML, and PDF formats. To do so, make sure Pandoc and Pandocomatic are installed, then in the terminal navigate into the project directory and either run `./build.sh` or, if you'd like to customise the build location, the full Pandocomatic command:

```
pandocomatic -i input -o docs -c config.yaml --modified-only
```

**Note:** The templates are navigated to from the input files in the config.yaml file. If you want, you can move them elsewhere - into your Pandoc data directory, for example - but you'll need to change their file location in config.yaml as well. I suggest checking out [this section in the Pandocomatic manual](https://heerdebeer.org/Software/markdown/pandocomatic/#specifying-paths) for help on specifying file paths in the config.