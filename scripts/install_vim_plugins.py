#!/usr/bin/env python3
import configparser
from pathlib import Path
import os
import argparse
import zipfile
import time
import shutil

CONFIG_FNAME = 'vim_plugins.ini'
SECONDS_TO_CHECK_FOR_DOWNLOAD_FILES = 1
SKIP_SECTIONS = ['DEFAULTS', 'EXAMPLE']
EXPECTED_SCOPE_LIST = ['system', 'vim']
EXPECTED_MODE_LIST = ['start', 'opt']

def ask(question_message):
    yes_or_no = input(question_message + ' [Y/n] ')
    if yes_or_no.lower().strip() in ['n', 'no']:
        return 0
    return 1

CONFIG_PATH = Path(__file__).parent / CONFIG_FNAME
if not CONFIG_PATH.is_file():
    print("{CONFIG_FNAME} not found, exiting...")
    exit(1)

def unzip(file_path, output_directory):
    with zipfile.ZipFile(file_path, 'r') as f:
        f.extractall(output_directory)

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
print(f"Plugins folder: {EXT_PATH} \n")
DOWNLOAD_PATH = Path(HOME) / config['DEFAULTS']['download_path']

START_PATH = Path(EXT_PATH) / 'start'
START_PATH.mkdir(exist_ok=True, parents=True)
OPT_PATH = Path(EXT_PATH) / 'opt'
OPT_PATH.mkdir(exist_ok=True, parents=True)


for plugin_name in config.sections():
    if plugin_name != SKIP_SECTIONS:
        print(f"\nInstalling {plugin_name}")
        plugin_config = config[plugin_name]

        scope = plugin_config['scope']
        assert scope in EXPECTED_SCOPE_LIST

        mode = plugin_config['mode']
        assert mode in EXPECTED_MODE_LIST

        url = plugin_config['url']
        url_zip = plugin_config['url_zip']

        zip_file = Path(plugin_config['zip_file'])
        assert zip_file.suffix == ".zip"

        destination_folder_name = plugin_config['destination_folder_name']
        extra_cmd = None
        if 'extra_cmd' in plugin_config:
            extra_cmd = plugin_config['extra_cmd']
        
        if interactive_mode:
            if ask("Should install plugin_name:") == 0:
                continue

        if manual_mode:
            # No git clone in this mode
            print(f'Download {url_zip} waiting for it under {DOWNLOAD_PATH} with filename: {zip_file}')
            file_path = DOWNLOAD_PATH/zip_file
            while True:
                if file_path.is_file():
                    print(f"Found {file_path}")
                    unzip(file_path, DOWNLOAD_PATH)
                    DESTINATION_PATH = EXT_PATH / mode / destination_folder_name
                    if DESTINATION_PATH.is_dir():
                        if ask(f"{DESTINATION_PATH} already exists, should remove it?") == 1:
                            shutil.rmtree(DESTINATION_PATH)
                    shutil.move(DOWNLOAD_PATH/ zip_file.with_suffix(''), DESTINATION_PATH)
                    break
                time.sleep(SECONDS_TO_CHECK_FOR_DOWNLOAD_FILES)

