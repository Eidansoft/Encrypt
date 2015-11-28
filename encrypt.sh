#!/bin/bash

# @Project: Encrypt
# @author: Alejandro Lorente
# @author: eidansoft at gmail dot com
# @Description: An early concept-prove for encrypt and decrypt files to upload to the cloud.
function encrypt {
	operation=$1
	password=$2
	file=$3
	doneFiles=$4

	if [ "$1" = "encrypt" ]; then
		echo >&2 Encrypting $(pwd)/$file
		echo $password | gpg2 --batch --passphrase-fd 0 -o $file.gpg -c $file
	elif [ "$1" = "decrypt" ]; then
		echo >&2 Decrypting $(pwd)/$file
		decryptedName=$(echo $file | sed 's/\.gpg$//g')
		echo $password | gpg2 --batch --passphrase-fd 0 -o $decryptedName -d $file
	fi
	if [ "$?" = "0" ]; then #Note her I'm checking the result for GPG command
		echo "$(pwd)/$file" >> $doneFiles
	else
		echo "ERROR with file $(pwd)/$file" >> $doneFiles
	fi
}

function setOperation {
	echo >&2 "Encrypt (E) or Decrypt (D)?"
	read op
	if [ "$op" = "e" -o "$op" = "E" ]; then
		res="encrypt"
	elif [ "$op" = "d" -o "$op" = "D" ]; then
		res="decrypt"
	else
		echo >&2 "Wrong option"
		res="error"
	fi
	echo $res
}

function setFolder {
	echo >&2 "Folder? [$(pwd)]"
	read folder
	if [ "$folder" = "" ]; then
		res=$(pwd)
	elif [ -d $folder ]; then
		res=$folder
	else
		echo >&2 "The folder '$folder' is NOT valid"
		res="error"
	fi
	echo $res
}

function processFolder {
	operation=$1
	password=$2
	folder=$3
	doneFiles=$4

	pushd $folder
	ls -1 | while read file
	do
		if [ -d $file ]; then
			processFolder $operation $password $file $doneFiles
		elif [ -f $file ]; then
			encrypt $operation $password $file $doneFiles
		else
			echo >&2 "File NOT processed '$(pwd)/$file'"
		fi
	done
	popd
}

function deleteFiles {
	doneFiles=$1

	while read file
	do
		rm $file
	done < $doneFiles
}

function _init {
	doneFiles="/tmp/doneFiles.tmp.$(date +%s)"
	
	operation=$(setOperation)
	while [ $operation = "error" ]; do
		operation=$(setOperation)
	done
	
	folder=$(setFolder)
	while [ $folder = "error" ]; do
		folder=$(setFolder)
	done
	echo "${operation}ing folder $folder"

	echo "Password: "
	read -s pw
	processFolder $operation $pw $folder $doneFiles

	# Check for errors
	grep "ERROR with file" $doneFiles
	if [ "$?" != 0 ]; then # If was no errors
		deleteFiles $doneFiles
		rm $doneFiles
		echo "Files SUCCESSFULLY ${operation}ed !"
	else
		echo "Some ERRORS found, please check the log at $doneFiles"
	fi
}

_init
