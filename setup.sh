#!/bin/bash

set -xueo pipefail

function link_to_home_dir() {
	local filename=${1}
	local src_path=${PWD}/${filename}
	local dst_path=~/.${filename}

	ln --symbolic --force ${src_path} ${dst_path}
}

function main() {
	for filename in bashrc gitconfig shrc_common vimrc zshrc; do
		link_to_home_dir ${filename}
	done
}

main
