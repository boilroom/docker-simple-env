# === MAIN SETTINGS ===========================================================

stack_name=my-great-app             # Docker stack name
replicas=2                          # Docker service replicas count (see compose file)

# =============================================================================

timeout=600                         # Max time to deploy. Process canceled if timeout reached

timeout_counter=0                   # Timeout counter
error=""                            # Error message

service_name=$(docker service ls --filter "name=$stack_name" --format "{{.Name}}") # Get full service name

if [[ -z $service_name ]]
then
  echo "Error: service not found"
  exit 1 # Exit with error
else
  docker rm $(docker ps --filter "name=$service_name" --filter "status=exited" -q) # Remove old (previous) exited containers
  docker service update --force $service_name # Update service

  while :
  do
    printf "."; # Show "progress"
    timeout_counter=$(( timeout_counter + 1 )) # Increment timeout counter

    if [ $timeout_counter -gt $timeout ]; then # If timeout reached, then set error message and break loop
      error="build and run timeout reached"
      break
    fi

    # Count exited containers
    exited_containers_count=$(docker ps --filter "name=$service_name" --filter "status=exited" --format "{{.ID}}" | wc -l)

    # If exited containers count equal replicas count, then remove exited containers and break loop
    if [ $(($exited_containers_count)) -ge $replicas ]; then
      docker rm $(docker ps --filter "name=$service_name" --filter "status=exited" -q) # Remove exited containers
      break
    fi

    sleep 1
  done

  if [ ! -z "${error}" ]; then # If error message is not empty, then show error message and rollback
    echo "Error: $error"
    exit 1; # Exit with error
  fi

  exit 0; # Exit with success
fi
