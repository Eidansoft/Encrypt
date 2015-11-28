# Encrypt
Easy to use interface to encrypt and decrypt files just before push to the cloud.

The main idea is to create a multi-plattform driver configurable with
a directory on the system. The driver will create a virtual device
into the system and any application could read or write into this virtual
device.
The driver will perform the read and write operations into the folder
configured, but encrypting and decrypting all the data. With this solution
the user can upload the encrypted folder easely to the cloud.

I'm intereseted on create this solution to let users encrypt their data by
themselves without any other third parts involved, just the user and the
cloud solution selected by him.

There are other solution to do this:
 * Truecrypt (deprecated)
 * VeraCrypt (https://veracrypt.codeplex.com/)
 * SO built-in encryption system (http://www.howtogeek.com/200211/6-popular-operating-systems-offering-encryption-by-default/)

But I reckon there is a lack on those systems. This systems encrypt a full unit
or device, this is an issue because many times I just only need to modify only
one single file, then encrypt everythin and upload a huge file to the cloud.
I want a system that just only re-encrypt the modified files; with this solution
I only need to upload to the cloud the files I had modified.

# CHANGELOG
28/11/2015
 * After some tests, I have decided to start creating a simple shellscript.
   It take a folder and encrypt or decrypt all of it's content. With this early
   approximation I can just upload the files (or folders) I know had some modification.
