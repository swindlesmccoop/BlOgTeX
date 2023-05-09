# BlOgTeX
A blog that compiles LaTeX documents to HTML and creates an index in reverse-chronological order

## Dependencies
- `pandoc`

## How To Use
Edit the variables at the top of the script to point to your source `.tex` files, then where you want to output the final compiled blog. Note that the destination directory WILL BE WIPED UPON INVOKING THE SCRIPT. This is for cleanliness purposes.

You will need to have a `header.html` file in your `$SOURCE` directory. This is so when the script gets run and it gets the title, date, and filename of each file and creates an index, there is actually something doing things like creating a title for the page. Take a look at my example [header.html](blog-tex/header.html) so you can see what is required.

## Things That Are Supported
- Links
- **Bold** and *Italic* text
- Images
- Math
  - The math is generated using `latex.codecogs.com` which by default makes all of the math black. You can work around this by importing `\usepackage{xcolor}`, then using the `\color{}` tag (make sure to put a color between those {curly brackets}) to change it to a color that is readable. This was releavnt to me because the background of my blog is black, which made the math impossible to read.
  - Also, the reason that the math is done through CodeCogs is because a lot of the rendering of math simply cannot be done with plain HTML (see: fractions, sqrt, etc.) but CodeCogs provides a super quick way to do it that is *automatically handled by the script*, so your math equations will just werk.
- Sections, subsections, etc.
- Code syntax highlighting with `\usepackage{minted}`

## To-do
[ ] Fix sorting by date in index
