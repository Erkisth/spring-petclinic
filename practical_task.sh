#!/bin/bash

PROJECT_NAME=$1

gcloud compute networks create script-network \
    --subnet-mode=custom \
    --bgp-routing-mode=regional \
    --mtu=1460

gcloud compute networks subnets create script-subnet-1 \
    --network=script-network \
    --range=10.0.1.0/24 \
    --region=us-central1

gcloud compute networks subnets create script-subnet-2 \
    --network=script-network \
    --range=10.0.2.0/24 \
    --region=us-central1

gcloud artifacts repositories create script-repo \
    --repository-format=docker \
    --location=us-central1

docker tag spring-petclinic us-central1-docker.pkg.dev/${PROJECT_NAME}/script-repo/spring-petclinic:latest

docker push us-central1-docker.pkg.dev/${PROJECT_NAME}/script-repo/spring-petclinic:latest

gcloud compute instances create-with-container script-instance \
    --machine-type=e2-medium \
    --zone=us-central1-a
    --network=script-network \
    --subnet=script-subnet-1 \
    --container-image=us-central1-docker.pkg.dev/${PROJECT_NAME}/script-repo/spring-petclinic:latest \
    --tags=http-server

gcloud compute firewall-rules create allow-http \
    --allow tcp:80 --target-tags http-server

gcloud compute firewall-rules create allow-ssh \
    --allow tcp:22 --target-tags http-server
