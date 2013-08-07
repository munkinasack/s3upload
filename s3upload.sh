#!/bin/bash

S3CMD="/usr/bin/s3cmd --config=/root/s3cmd.conf"
S3CMD_UPLOAD="put -r --rr"
S3CMD_ACL="setacl -r -P"
DIR="/home/ubuntu/videos"
BUCKET="s3://munkinasackvideos"

# Check for s3cmd
if [[ -z ${S3CMD} ]]; then
	printf "\ns3cmd not found.\n....Fix it\n"
	exit 1
fi

# Check for s3cmd running
if pidof -x s3cmd > /dev/null
then
    exit 1
fi

if [ "$(ls -A $DIR)" ]; then # Check to see if folders/files are in folder
	for i in $DIR/*;  do # Process each item
	 case $i in
          *.zip) # Is file a zip?
	   printf "\nUnpacking $i..."
	   uni=${i##*/} # Get var for just zip file name
	   uni=${uni%.zip} # Strip away extension
	   unzip -d "$i" "$DIR/$uni" # Unzip everything put in folder
	   printf "done.\n Uploading $uni\n"
           ${S3CMD} ${S3CMD_UPLOAD} "${uni}" ${BUCKET}
           ${S3CMD} ${S3CMD_ACL} ${BUCKET}/"${uni}"
	   printf "\nDeleting $i and $uni..." # Delete both folder and zip
	   rm "$i"
	   rm -r "$uni"
	   printf "done.\n"
	   ;;
	  *)
	   if [ -f "$i" ]; then # Is file?
           printf "\nUploading ${i##*/}\n"
           ${S3CMD} ${S3CMD_UPLOAD} "${i}" ${BUCKET}
           ${S3CMD} ${S3CMD_ACL} ${BUCKET}/"${i##*/}"
            printf "\nDeleting ${i##*/}..."
            rm "$i"
            printf "done.\n"

	   elif [ -d "$i" ]; then # Is folder?
	   S3DIR=${i##*/} # Get folder name for setting ACL
	   printf "\nUploading folder $S3DIR\n"
	   ${S3CMD} ${S3CMD_UPLOAD} "${i}" ${BUCKET}
	   ${S3CMD} ${S3CMD_ACL} ${BUCKET}/"${S3DIR}"
	    printf "\nDeleting folder $S3DIR..." # Delete folder
	    rm -r "$i"
	    printf "done.\n"
	   fi
	   ;;
	esac
done

else
	exit 1
fi
