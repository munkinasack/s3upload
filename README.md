s3upload
========

Upload files with s3cmd and cron

Required- S3cmd, unzip

-Make S3cmd config file. Make readable for root. Set config file location under S3CMD
-Set local upload directory for DIR
-Set bucket and optional folder for BUCKET
-Make Cron to run script

All folders and files within the directory will be uploaded then deleted. Zip files will unzip, upload, then delete.

TODO:
-Check for files/folders that have uploaded before deleting. (Then blacklist files/folders that were not uploaded to
prevent reuploading)??
-Better zip handling
-Add additional compression extension to decrompress before uploading (rar, etc)

