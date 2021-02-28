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
    ],
    "environment": [
      {
        "name": "DATABASE_HOST",
        "value": "${DATABASE_HOST}"
      }, 
      {
        "name": "DATABASE_PORT",
        "value": "${DATABASE_PORT}"
      },
      {
        "name": "DATABASE_USER",
        "value": "${DATABASE_USER}"
      },
      {
        "name": "DATABASE_PASSWORD",
        "value": "${DATABASE_PASSWORD}"
      },
      {
        "name": "DATABASE_NAME",
        "value": "${DATABASE_NAME}"
      }
    ]
  }
]