#!/usr/bin/env python2

import sys

import yaml
import jinja2
import getopt

def print_usage():
    print "yaml2jinja2.py -f <yamlfile> < template.jinja"

def main():
    yamlfile = None
    optlist, args = getopt.getopt(sys.argv[1:], 'hf:')
    for k, v in optlist:
        if k=='-h':
            print_usage()
            sys.exit(0)
        elif k=='-f':
            yamlfile = v
    if not yamlfile:
        print_usage()
        sys.exit(1)

    with open(yamlfile) as infile:
        template_data = yaml.load(infile)

    template = jinja2.Template(sys.stdin.read())
    print template.render(template_data)


if __name__ == "__main__":
    main()

