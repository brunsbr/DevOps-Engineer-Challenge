# In the Azure Pipelines, line 5b, I could use an explicit timeout for the health check, 
# but I prefer to use the default settings for simplicity.

timeoutInMinutes: 1  # 1 minute = 60 seconds (add at the job level)

- stage: Rollback
  dependsOn: HealthCheck
condition: failed()  # Runs only if the HealthCheck fails
  jobs:
  - job: RollbackToBlue
    timeoutInMinutes: 1  # FORCES THE JOB TO FINISH WITHIN 60s
    steps:
    - script: |
        echo "Health check failed! Initiating rollback to BLUE within 60s..."
        terraform apply -auto-approve \
          -target=aws_lb_listener.prod \  # OPTIMIZATION: APPLIES ONLY THE CRITICAL RESOURCE
          -var="active_target_group=blue"
      displayName: 'Rollback to BLUE target group'