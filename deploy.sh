# exit on error
set -e
REGION=$1; EnvironmentName=$2;

aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} --profile default
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY} --profile default
aws configure set default.region ${REGION} --profile default

#function for cloudformation deploy
function deploy() {
    TEMPLATE_FILE=$1; shift
    STACKNAME=$1; shift

    ( set -x ; aws cloudformation deploy \
      --region "${REGION}" \
      --template-file "${TEMPLATE_FILE}" \
      --stack-name "${STACKNAME}" \
      --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
      --no-fail-on-empty-changeset \
      --parameter-overrides "$@" )

    echo ""
}


deploy VPC.yaml websvr EnvironmentName="${EnvironmentName}" --no-fail-on-empty-changeset

deploy EC2.yaml websvrEC2 KeyPairName="websvr" --no-fail-on-empty-changeset

