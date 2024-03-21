### Retrieve an RDS password in AWS Secrets Manager
### parameter: secret name

## The script defines a shell function named getsecretvalue() that does the following:
## - Uses the AWS CLI secretsmanager get-secret-value command to retrieve the value of the AWS Secrets Manager secret that is identified by a script input.
## - Uses the jq utility to isolate the JSON-formatted text inside of the SecretString property of the secret.
## Uses the jq utility to further parse the username, password, endpoint, and port values from the SecretString property and stores each in its own variable.
## Runs the mysql command with the appropriate flags, using the variables defined, to connect to the Amazon RDS database.

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