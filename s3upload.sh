#!/bin/bash

S3CMD="/usr/bin/s3cmd --config=/root/s3cmd.conf"
S3CMD_UPLOAD="put -r --rr"
S3CMD_ACL="setacl -r -P"
DIR="Your/full/directory/location"
BUCKET="Your/Bucket"

# Check for s3cmd
if [[ -z ${S3CMD} ]]; then
	printf "\ns3cmd not found.\n....Fix it\n"
	exit 1
fi

# Check to see if folders/files are in folder
#....Find better way to make S3DIR happen
if [ "$(ls -A $DIR)" ]; then
	for i in $DIR/*;  do
	S3DIR=$(basename $i)
	${S3CMD} ${S3CMD_UPLOAD} ${i} ${BUCKET}
	${S3CMD} ${S3CMD_ACL} ${BUCKET}/${S3DIR}
done

#Delete all the files once they've been uploaded to S3
printf "\nDeleting all folders/files....."
rm -rf $DIR/*
printf "Done\n"
	
else
	exit 1
fi
