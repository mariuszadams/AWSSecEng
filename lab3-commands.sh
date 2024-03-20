### Task 1: Verify you can use the secret to connect to the Amazon RDS database
# connect to EC2 host https://us-west-2.console.aws.amazon.com/systems-manager/session-manager/i-0a93f8e38ddab0344
cd $HOME; pwd

DB_ENDPOINT=rds-instance.cwwiholokbab.us-west-2.rds.amazonaws.com
mysql -u dbadmin -p -h $DB_ENDPOINT -e 'SELECT * FROM labdb.colors;'


### Task 2: Create an AWS KMS key
# On the AWS Key Management Service page, choose Create a key.


### Task 3: Create an AWS Secrets Manager secret and encrypt it with an AWS KMS key
# On the AWS Secrets Manager page, choose Store a new secret.
# Secret name, enter dbadmin_secret, for Description, enter RDS database administrator credentials


### Task 4: Use an encrypted secret to connect to an Amazon RDS instance

# Run the following command to retrieve the rds-dbadmin-secret secret value:
aws secretsmanager get-secret-value --secret-id dbadmin_secret

# Create a script that:
## Defines a shell function named getsecretvalue() that does the following:
## - Uses the AWS CLI secretsmanager get-secret-value command to retrieve the value of the AWS Secrets Manager secret that is identified by a script input.
## - Uses the jq utility to isolate the JSON-formatted text inside of the SecretString property of the secret.
## Uses the jq utility to further parse the username, password, endpoint, and port values from the SecretString property and stores each in its own variable.
## Runs the mysql command with the appropriate flags, using the variables defined, to connect to the Amazon RDS database.
cat<<'EOF'>> get-secret.sh
getsecretvalue() {
  aws secretsmanager get-secret-value --secret-id $1 | \
    jq .SecretString | \
    jq fromjson
}

secret=`getsecretvalue $1`

user=$(echo $secret | jq -r .username)
password=$(echo $secret | jq -r .password)
endpoint=$(echo $secret | jq -r .host)
port=$(echo $secret | jq -r .port)

mysql \
-p$password \
-u $user \
-P $port \
-h $endpoint
EOF

sh ./get-secret.sh dbadmin_secret
mysql -u dbadmin -p -h $DB_ENDPOINT -e 'SELECT * FROM labdb.colors;'

### Task 5: Rotate the secret and connect to the Amazon RDS instance again
# CONFIGURE SECRET ROTATION
# GRANT PERMISSIONS FOR THE SECRET ROTATION FUNCTION TO ACCESS THE AWS KMS KEY
# PERFORM A SECRET ROTATION
# CONNECT TO THE DATABASE WITH THE UPDATED SECRET
mysql -u dbadmin -p -h DB_ENDPOINT
# The output should display an access denied error message, similar to this: ERROR 1045 (28000): Access denied for user 'dbadmin'@'10.10.10.254' (using password: YES)

# Reget secret from AWS Secrets Manager
sh ./get-secret.sh dbadmin_secret
mysql -u dbadmin -p -h $DB_ENDPOINT -e 'SELECT * FROM labdb.colors;'
