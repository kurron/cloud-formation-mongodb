#!/bin/bash

# creates a stack in AWS via CloudFromation

STACKNAME=${1:-Weapon-X-ECS}
PROJECTNAME=${2:-Weapon-X}
SECURITYGROUPS=${3:-sg-510e4729}
SUBNETS=${4:-subnet-9b330ac3,subnet-f639bc91,subnet-59459a10,subnet-9c330ac4,subnet-f739bc90,subnet-46459a0f}
INSTANCETYPE=${5:-m4.large}
SPOTPRICE=${6:-0.025}
ENVIRONMENT=${7:-development}
CREATOR=${8:-CloudFormation}
TEMPLATELOCATION=${9:-file://$(pwd)/ecs.yml}

VALIDATE="aws cloudformation validate-template --template-body $TEMPLATELOCATION"
echo $VALIDATE
$VALIDATE

CREATE="aws cloudformation create-stack --stack-name $STACKNAME \
                                        --template-body $TEMPLATELOCATION \
                                        --capabilities CAPABILITY_NAMED_IAM \
                                        --parameters ParameterKey=Project,ParameterValue=$PROJECTNAME \
                                                     ParameterKey=Environment,ParameterValue=$ENVIRONMENT \
                                                     ParameterKey=Creator,ParameterValue=$CREATOR \
                                                     ParameterKey=InstanceType,ParameterValue=$INSTANCETYPE \
                                                     ParameterKey=SpotPrice,ParameterValue=$SPOTPRICE \
                                                     ParameterKey=Subnets,ParameterValue=\"$SUBNETS\" \
                                                     ParameterKey=SecurityGroups,ParameterValue=\"$SECURITYGROUPS\" \
                                        --tags Key=Project,Value=$PROJECTNAME \
                                               Key=Environment,Value=$ENVIRONMENT \
                                               Key=Creator,Value=$CREATOR"
echo $CREATE
$CREATE
