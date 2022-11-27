#!/bin/sh
pandoc -V classoption=oneside -V geometry:vmargin=14.5mm -V lang:de --fail-if-warnings --output=merge.pdf md/*.md