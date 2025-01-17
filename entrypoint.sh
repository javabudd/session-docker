#!/bin/bash

DATA_DIR=/var/lib/oxen/stagenet
LOG_FILE=/var/log/oxen/stagenet.log

if [ -z "$SERVICE_NODE_IP_ADDRESS" ]; then
  if [ -z "$AS_FARGATE" ]; then
    # For AWS EC2
    TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    SERVICE_NODE_IP_ADDRESS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
  else
    # For AWS Fargate
    TASK_METADATA=$(curl -s "${ECS_CONTAINER_METADATA_URI_V4}/task")
    TASK_ARN=$(echo "$TASK_METADATA" | jq -r '.TaskARN')
    ECS_CLUSTER_NAME=$(echo "$TASK_METADATA" | jq -r '.Cluster')

    # Get the list of services in the cluster
    SERVICE_ARNS=$(aws ecs list-services --cluster "$ECS_CLUSTER_NAME" --query "serviceArns[]" --output text)

    # Loop through each service to find which one is associated with the task
    for SERVICE_ARN in $SERVICE_ARNS; do
      # Check if this service has the task
      TASK_ARNS=$(aws ecs list-tasks --cluster "$ECS_CLUSTER_NAME" --service-name $(basename $SERVICE_ARN) --query "taskArns[]" --output text)

      if echo "$TASK_ARNS" | grep -q "$TASK_ARN"; then
        ECS_SERVICE_NAME=$(basename $SERVICE_ARN)
        break
      fi
    done

    TASK_DETAILS=$(aws ecs describe-tasks --cluster "$ECS_CLUSTER_NAME" --task "${TASK_ARN}" --query 'tasks[0].attachments[0].details')
    ENI=$(echo "$TASK_DETAILS" | jq -r '.[] | select(.name=="networkInterfaceId").value')
    SERVICE_NODE_IP_ADDRESS=$(aws ec2 describe-network-interfaces --network-interface-ids "${ENI}" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)
  fi

  export SERVICE_NODE_IP_ADDRESS
fi

if [ -n "$AS_FARGATE" ]; then
  DATA_DIR=/var/lib/oxen/stagenet-${ECS_SERVICE_NAME}
  LOG_FILE=/var/lib/oxen/stagenet-${ECS_SERVICE_NAME}/logs/stagenet.log
fi

export DATA_DIR
export LOG_FILE

envsubst < /etc/oxen/stagenet_template.conf > /etc/oxen/stagenet.conf

exec "$@"