# css

This private repository contains many branches corresponding to customer-specific designs to be placed (usually) in the CSS directories of the Chamilo portals BeezNest implements for them.

Some of these CSS will be accompanied by a corresponding branch in the https://github.com/beeznest/templates/ project.

## Creating a new branch

To create a new branch called "example" in a working Chamilo installation:
```
cd app/Resources/public/css/themes
git clone -b example  https://github.com/aragonc/loica_css.git example 
cd example
git checkout -b example
vim README.md
# Change the contents of the README file as explained above
# Add all files corresponding to this template
git add .
git commit -m "Initial import for 'example' CSS"
git push origin example
```

## Downloading an existing template

To download an existing template 'example', get into an existing Chamilo installation and do:
```
cd app/Resources/public/css/themes
git clone -b example https://github.com/aragonc/css example
```
That's all. Don't forget to add the name of the destination folder, otherwise it will be called 'css'.
