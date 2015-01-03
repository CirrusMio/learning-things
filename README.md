This is a list of tutorials and guides
for becoming a better teammate within CirrusMio.
We're sharing it publicly because we think the internet may like it.

[Visit the site][site]

## Contributing

Contributions welcome! Make pull requests on GitHub.

Even if you don't feel authoritative on a subject,
just start writing.
We'll use your pull request for discussion and build a rough consensus.

### Spellchecking

I, @xtoddx, make tons of typos.
I've used aspell to check the spelling of my markdown files.
The `spellcheck.sh` script can be used
to check all of the markdown pages in the repository.
There is a custom dictionary for this project (`aspell.dict`)
where we can add words that are correct for this project.

You can add a pre-commit hook in `.git/hooks/post-commit`:

```bash
#!/usr/bin/env bash

truth=0
falsehood=1
passed=$truth

file_list=`git diff --cached --name-status --diff-filter=ACMR | grep .md`
file_list=`echo $file_list | awk '{print $2}'`

for file in $file_list ; do
  for word in `aspell --per-conf=./aspell.conf list < $file`; do
    echo "${file}: ${word}"
    passed=$falsehood
  done
done
if $passed ; then
  exit $truth
fi

echo "YOU MAY HAVE SPELLING ERRORS"
```


[site]: http://learning-things.cirrusmio.com/
