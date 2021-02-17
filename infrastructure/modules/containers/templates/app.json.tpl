[
  {
    "essential": true,
    "memory": 256,
    "name": "${APP_NAME}",
    "cpu": 256,
    "image": "${REPOSITORY_URL}:latest",
    "workingDirectory": "/app",
    "portMappings": [
        {
            "containerPort": ${CONTAINER_PORT},
            "hostPort": ${CONTAINER_PORT}
        }
    ]
  }
]