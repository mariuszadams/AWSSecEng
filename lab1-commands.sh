### Connect to EC2 host session at https://us-west-2.console.aws.amazon.com/systems-manager/session-manager/i-02bcdb14c35161086

# set env
cd $HOME; pwd; DataBucket=data-bucket-us-west-2-428135087; BackupBucket=backup-bucket-us-west-2-428135087

# go to lab files
cd /home/ec2-user/lab1

### Task 2: Validate permissions granted to the EC2 instance

# list all buckets
aws s3 ls
# upload files to data bucket
aws s3 cp /home/ec2-user/lab1/file1.txt s3://$DataBucket
#upload: ./file1.txt to s3://data-bucket-us-west-2-556254614/file1.txt
aws s3 ls $DataBucket
#2024-03-19 18:39:05         61 file1.txt
# upload files to data bucket
aws s3 cp /home/ec2-user/lab1/file1.txt s3://$BackupBucket
aws s3 ls $BackupBucket
# try to delete file from bucket
aws s3 rm s3://$DataBucket/file1.txt
#delete failed: s3://data-bucket-us-west-2-556254614/file1.txt An error occurred (AccessDenied) when calling the DeleteObject operation: Access Denied

### Task 3: Apply a resource-based policy to an S3 bucket to deny file uploads

aws s3 cp file2.txt s3://$DataBucket
#upload: ./file2.txt to s3://data-bucket-us-west-2-556254614/file2.txt

aws s3 cp file2.txt s3://$BackupBucket
#upload failed: ./file2.txt to s3://backup-bucket-us-west-2-556254614/file2.txt An error occurred (AccessDenied) when calling the PutObject operation: Access Denied
# Note: The first command to upload file2.txt to data-bucket is successful, but the upload to backup-bucket fails. Even though the EC2 instance profile allows file uploads (s3:PutObject) to any bucket, the bucket policy on backup-bucket denies file uploads. The end result is that you can upload to data-bucket from the instance, but not to backup-bucket.

### Task 4: Apply an IAM permissions boundary

# only file3.txt will be accepted
aws s3 cp file3.txt s3://$DataBucket
#upload: ./file3.txt to s3://data-bucket-us-west-2-556254614/file3.txt

aws s3 cp file4.txt s3://$DataBucket
#Expected output: The output should display an upload failed and AccessDenied message, similar to this:
#upload failed: ./file4.txt to s3://data-bucket-us-west-2-556254614/file4.txt An error occurred (AccessDenied) when calling the PutObject operation: Access Denied