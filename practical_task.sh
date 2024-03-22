#!/bin/bash

PROJECT_NAME=$1

gcloud compute networks create script-network \
    --subnet-mode=custom \
    --bgp-routing-mode=regional \
    --mtu=1460

gcloud compute networks subnets create script-subnet-1 \
    --network=script-network \
    --range=10.0.1.0/24 \
    --region=us-central1-b

gcloud compute networks subnets create script-subnet-2 \
    --network=script-network \
    --range=10.0.2.0/24 \
    --region=us-central1-c

gcloud artifacts repositories create script-repo \
    --repository-format=docker \
    --location=us-central1

docker tag spring-petclinic us-central1-docker.pkg.dev/${PROJECT_NAME}/script-repo/spring-petclinic:latest

docker push us-central1-docker.pkg.dev/${PROJECT_NAME}/script-repo/spring-petclinic:latest

gcloud compute instances creat-with-container script-instance \
    --machine-type=e2-medium \
    --zone=us-central1-b \
    --network=script-network \
    --subnet=script-subnet-1 \
    --container-image=us-central1-docker.pkg.dev/${PROJECT_NAME}/script-repo/spring-petclinic:latest
