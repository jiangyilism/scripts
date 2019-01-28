#!/usr/bin/env bash

set -xueo pipefail

top_dir="${PWD}"

ln -sf "${top_dir}/vimrc" ~/.vimrc
ln -sf "${top_dir}/bashrc" ~/.bashrc
