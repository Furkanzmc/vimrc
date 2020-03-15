#!/usr/bin/env python3

# Python
import argparse
from typing import List

# Thid Party
from pynvim import attach
from psutil import (
    process_iter,
    NoSuchProcess,
    AccessDenied,
    ZombieProcess,
    Process,
)


def get_nvim_processes() -> List[Process]:
    processes: List[Process] = []

    process: Process
    for process in process_iter():
        try:
            process_name = process.name()
        except (
            NoSuchProcess,
            AccessDenied,
            ZombieProcess,
        ):
            pass
        else:
            if process_name == "nvim":
                processes.append(process)

    return processes


def create_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Helper functions to interact with NeoVim"
    )
    parser.add_argument(
        "--change-background",
        type=str,
        help="Change the background of all the NeoVim instances.",
    )

    return parser


def change_background(mode: str):
    processes = get_nvim_processes()

    process: Process
    for process in processes:
        server = "/tmp/nvim/nvim{}.sock".format(process.pid)
        try:
            nvim = attach("socket", path=server)
        except FileNotFoundError:
            pass
        else:
            nvim.command("set background={}".format(mode))


def main():
    args = create_argparser().parse_args()
    if args.change_background:
        change_background(args.change_background)


if __name__ == "__main__":
    main()
