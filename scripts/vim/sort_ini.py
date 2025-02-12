#!/usr/bin/env python3
# Based on https://angelosalexopoulos.medium.com/sort-ini-configuration-files-in-python-60e83c02b5b8
# raw github link: https://gist.githubusercontent.com/alexopoulos7/0f30c092d6ca26c6a08504a98de338ce/raw/72fb5fc050f9ab1bc0b87886763419dd37cb3b67/sort_ini.py

import sys
from configparser import ConfigParser

FIRST_SECTIONS = ['DEFAULTS']

def parse_sections(parser, sorted_parser, sections):
    for s in sections:
        sorted_parser.add_section(s)
        items = sorted(parser._sections[s].items())
        for i in items:
            sorted_parser.set(s, i[0], i[1])
    return sorted_parser

def sort_file(parser, file_name='vim_plugins.ini'):
    sorted_parser = ConfigParser()

    sorted_parser = parse_sections(parser, sorted_parser, FIRST_SECTIONS)

    sections = [ s for s in sorted(parser._sections) if s not in FIRST_SECTIONS ]
    sorted_parser = parse_sections(parser, sorted_parser, sections)
        
    write_sorted_configuration_to_file(file_name, sorted_parser)


def write_sorted_configuration_to_file(file_name, sorted_parser):
    with open(file_name, 'w') as configfile:
        sorted_parser.write(configfile)


def read_file(file_path):
    parser = ConfigParser()
    parser.read(file_path)
    return parser


if __name__ == "__main__":
    ini_file_path = 'vim_plugins.ini'
    out_file = 'vim_plugins_sorted.ini'
    if len(sys.argv[1:]) >= 1:
        ini_file_path = sys.argv[1:][1]
    if len(sys.argv[1:]) >= 2:
        out_file = sys.argv[1:][2]
    parser_config = read_file(ini_file_path)
    sort_file(parser_config, out_file)
    print(f'Wrote sorted file here: {out_file}!')
