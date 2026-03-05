## Setup Instructions

Create the symbolic link:

```bash
ln -sf "$PWD/gemini/.gemini/".* "$PWD/gemini/.gemini/"* ~/.gemini/ 2>/dev/null
```

Note that the .* is for hidden files and the null piping for if files/hidden files are not found.
Also this needs to be run each time you add new files to the .gemini directory.
