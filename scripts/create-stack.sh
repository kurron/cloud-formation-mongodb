#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-MongoDB}
PROJECTNAME=${2:-Weapon-X}
VPC=${3:-vpc-3db4d95a}
SUBNETS=${4:-subnet-b290a9ea,subnet-6803870f,subnet-f23ce2bb}
ENVIRONMENT=${5:-development}
CREATOR=${6:-CloudFormation}
TEMPLATELOCATION=${7:-file://$(pwd)/mongodb.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=VPC,ParameterValue=$VPC \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
