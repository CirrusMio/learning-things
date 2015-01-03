#!/usr/bin/env bash
#for markdown_file in "pages/beginning-html5.md" ; do
for markdown_file in `ls pages/*.md` ; do
	aspell --per-conf=./aspell.conf check ${markdown_file}
done
