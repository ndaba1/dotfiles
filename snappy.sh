#!/bin/bash

STEP=0

function execute() {

	if [[ -f $1 ]]; then		
		STEP=$(($STEP + 1))

		echo "[$STEP]: $2"
		for ext in $(cat "./$1")
		 do
		 	$3 ext
		 done
		echo "  ✔ Done."
	fi
}

function restore() {
	# Setup all configured apps
	if [[ -f "winget.conf" ]]; then
		echo "Installing apps from winget.conf... This may take a while"
		winget import -i ./winget.conf

		echo "  ✔ Done."
	else
		echo "WARN: No winget configuration found. Skipping this step."
	fi	

	# install vscode extensions if any
	execute "vsc.conf" "Installing Vscode extensions...." "code --install-extension"
	# node & npm
	execute "npm.conf" "Installing global npm tools...." "npm install -g"
	# golang
	execute "go.conf" "Installing golang packages...." "go install"
	# ruby
	execute "ruby.conf" "Installing ruby gems...." "gem install"
	# rust
	execute "rust.conf" "Fetching rust crates...." "cargo install"
	# global python modules
	execute "py.conf" "Installing python packages...." "python -m pip install"
}

function create() {
	echo "Unimplemented"
}

if [[ $1 == "create" ]]; then
	#statements
	create
elif [[ $1 == "restore" ]]; then
	restore
fi
