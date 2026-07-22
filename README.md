Readme in progress

Simple for now

Do this:

1. make image
2. make clone
3. make build

Output will be:

* `RetroArch<-label><-commit><-suffix>.AppImage`
* `RetroArch<-label><-suffix>.AppImage`
* `RetroArch<-date><-suffix>.AppImage`

Based on what's passed to `make build`.

Available parameters (envars):  

* COMMIT: Which commit to build  
(will build master branch if not provided)
* LABEL: Replaces the auto-generated date/time  
* SUFFIX: Suffix applied to output name  

`make build COMMIT="a1b2c3d4" LABEL="dev" SUFFIX="2"` will produce: RetroArch-dev-a1b2c3d4-2.AppImage

AppImages will appear in the `output` directory.

To clear out the git repo that gets pulled by `make clone`, you can use `make clean` to remove it.
