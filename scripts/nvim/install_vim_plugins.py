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

configs_dict = {
    "SKIP_SECTIONS" : ['DEFAULTS', 'EXAMPLE'],
    "EXPECTED_MODE_LIST" : ['start', 'opt'],
}

def ask(question_message):
    yes_or_no = input(question_message + ' [Y/n] ')
    if yes_or_no.lower().strip() in ['n', 'no']:
        return 0
    return 1

def ask_dir_exists(DESTINATION_PATH):
    if DESTINATION_PATH.is_dir():
        if ask(f"{DESTINATION_PATH} already exists, should remove it?") == 1:
            shutil.rmtree(DESTINATION_PATH)

def unzip(file_path, output_directory):
    with zipfile.ZipFile(file_path, 'r') as f:
        f.extractall(output_directory)

def setup_args():
    parser = argparse.ArgumentParser(description="Install vim plugins using git clone or downloading the zip file from github")
    parser.add_argument('-i', dest='interactive_mode', action='store_true', default=False, help='Asks before installing')
    parser.add_argument('-m', dest='manual_mode', action='store_true', default=False, help='Manual download the github repository zip file and move to destination folders')
    args = parser.parse_args()

    interactive_mode = args.interactive_mode
    manual_mode = args.manual_mode

    return interactive_mode, manual_mode

CONFIG_PATH = Path(__file__).parent / CONFIG_FNAME
if not CONFIG_PATH.is_file():
    print("{CONFIG_FNAME} not found, exiting...")
    exit(1)

config = configparser.ConfigParser()
config.read(CONFIG_PATH)
plugins_list = [s for s in config.sections() if s not in configs_dict['SKIP_SECTIONS']]
print(f"List of plugins in {CONFIG_FNAME}: {plugins_list}")

VIMCONFIG = os.getenv("VIMCONFIG")
HOME = Path(os.getenv("HOME"))
if VIMCONFIG is None:
    if ask(f"Environment variable: {VIMCONFIG} not set, should use `~/.config/nvim`?") == 1:
        VIMCONFIG = HOME / ".config/nvim"
    else:
        exit(1)



EXT_PATH = Path(VIMCONFIG) / config['DEFAULTS']['extensions_path']
print(f"Plugins folder: {EXT_PATH} \n")
DOWNLOAD_PATH = Path(HOME) / config['DEFAULTS']['download_path']

START_PATH = Path(EXT_PATH) / 'start'
START_PATH.mkdir(exist_ok=True, parents=True)
OPT_PATH = Path(EXT_PATH) / 'opt'
OPT_PATH.mkdir(exist_ok=True, parents=True)

interactive_mode, manual_mode = setup_args()
existing_plugins_dict = {}
all_plugins_dict = {}
for plugin_name in plugins_list:


    plugin_config = config[plugin_name]

    mode = plugin_config['mode']
    assert mode in configs_dict["EXPECTED_MODE_LIST"], f"{plugin_name}: check 'mode'"

    url = plugin_config['url']
    url_zip = plugin_config['url_zip']

    zip_file = Path(plugin_config['zip_file'])
    assert zip_file.suffix == ".zip", f"{plugin_name}: check 'zip'"

    destination_folder_name = plugin_config['destination_folder_name']

    # optionals extra_cmd = plugin_config.get('extra_cmd')
    just_in_manual = plugin_config.get('just_in_manual')


    DESTINATION_PATH = EXT_PATH / mode / destination_folder_name

    all_plugins_dict[plugin_name] = DESTINATION_PATH
    if interactive_mode:
        ask_dir_exists(DESTINATION_PATH)
    elif DESTINATION_PATH.is_dir():
        existing_plugins_dict[plugin_name] = DESTINATION_PATH
        continue

    print(f"\nInstalling {plugin_name}")
    if manual_mode:
        # No git clone in this mode
        print(f'Download {url_zip} waiting for it under {DOWNLOAD_PATH} with filename: {zip_file}')
        file_path = DOWNLOAD_PATH/zip_file
        while True:
            if file_path.is_file():
                print(f"Found {file_path}")
                try:
                    unzip(file_path, DOWNLOAD_PATH)
                except zipfile.BadZipFile:
                    # Bad zip wait 2 seconds and try a second time. Maybe it was still saving the file.
                    time.sleep(2)
                    unzip(file_path, DOWNLOAD_PATH)
                shutil.move(DOWNLOAD_PATH/ zip_file.with_suffix(''), DESTINATION_PATH)
                break
            time.sleep(SECONDS_TO_CHECK_FOR_DOWNLOAD_FILES)
    else:
        cmd = f"git clone --recursive --depth 1 {url} {DESTINATION_PATH}"
        r = os.system(cmd)

# update helptag"s
os.system("nvim -u NONE -c 'helptags ALL' -c q")

if len(existing_plugins_dict) > 0:
    existing_plugins_str = '\n'.join([k + ': ' + str(v) for k,v in existing_plugins_dict.items()])
    print(f"\nThe following plugins directories exists and can be replaced using interactive mode (-i): \n\n{existing_plugins_str}\n")



# check if there are old plugins in the destination folders

def get_found_plugins(BasePath: Path):
    """ get all the plugins folders in the destination folders """
    found_plugins_folders_dict = {}
    modes_folders = BasePath.iterdir()
    for mode in modes_folders:
        for dir_ in (BasePath / mode).iterdir():
            if dir_.is_dir():
                found_plugins_folders_dict[dir_.name] = dir_
    return found_plugins_folders_dict

def found_old_plugins(all_plugins_dict: dict, found_plugins_folders_dict: dict):
    """ check if there are old plugins in the destination folders """
    all_paths = all_plugins_dict.values()
    for found_plugin_name, found_plugin_path in found_plugins_folders_dict.items():
            if found_plugin_path not in all_paths:
                print("found path", found_plugin_path)
                if ask(f"{found_plugin_name} not found in {CONFIG_FNAME}, should remove it?") == 1:
                    shutil.rmtree(found_plugin_path)
found_plugins_folders_dict = get_found_plugins(EXT_PATH)
found_old_plugins(all_plugins_dict, found_plugins_folders_dict)
