#!/usr/bin/env python3

import configparser
from pathlib import Path
import os
import argparse

CONFIG_FNAME = 'vim_plugins.ini'

CONFIG_PATH = Path(__file__).parent / CONFIG_FNAME
if not CONFIG_PATH.is_file():
    print("{CONFIG_FNAME} not found, exiting...")
    exit(1)


parser = argparse.ArgumentParser(description="Install vim plugins using git clone or downloading the zip file from github")
parser.add_argument('-i', dest='interactive_mode', action='store_true', default=False, help='Asks before installing')
parser.add_argument('-m', dest='manual_mode', action='store_true', default=False, help='Manual download the github repository zip file and move to destination folders')
args = parser.parse_args()

interactive_mode = args.interactive_mode
manual_mode = args.manual_mode

config = configparser.ConfigParser()
config.read(CONFIG_PATH)
print(f"List of plugins in {CONFIG_FNAME}: {config.sections()}")

VIMCONFIG = os.getenv("VIMCONFIG")
HOME = os.getenv("HOME")

EXT_PATH = Path(VIMCONFIG) / config['DEFAULTS']['extensions_path']
DOWNLOAD_PATH = Path(HOME) / config['DEFAULTS']['download_path']

START_PATH = Path(EXT_PATH) / 'start'
START_PATH.mkdir(exist_ok=True, parents=True)
OPT_PATH = Path(EXT_PATH) / 'opt'
OPT_PATH.mkdir(exist_ok=True, parents=True)

for plugin_name in config.sections():
    if plugin_name != 'DEFAULTS':
        print(f"Installing {plugin_name}")
        plugin_config = config[plugin_name]
        scope = plugin_config['scope']
        mode = plugin_config['mode']
        url = plugin_config['url']
        url_zip = plugin_config['url_zip']
        zip_file = plugin_config['zip_file']
        destination_folder_name = plugin_config['destination_folder_name']
        extra_cmd = None
        if 'extra_cmd' in plugin_config:
            extra_cmd = plugin_config['extra_cmd']
        
        if interactive_mode:
            yes_or_no = input("Should install plugin_name:")
            if yes_or_no.lower().strip() in ['n', 'no']:
                continue

        print(f'Download {url_zip} waiting for it under {DOWNLOAD_PATH} with filename: {zip_file}')


