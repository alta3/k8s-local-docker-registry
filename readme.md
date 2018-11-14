# k8s-local-docker-registry

For development and testing purposes, sometimes its useful to build images locally and push them directly to a Kubernetes cluster.

This can be achieved by running a docker registry in the cluster and using a special repo prefix such as "127.0.0.1:30500" 

## Configuration

The kubernetes manifest `docker-private-registry.yaml` does not come with the key and cert needed to run an https registry.
Insert these as base64 encoded values into the tls.cert and tls.key respectively

```
base64 -w0 ~/k8s-certs/registry-web.pem
base64 -w0 ~/k8s-certs/registry-web-key.pem
```

## Start/Stop private registry in cluster

If you don't like getting your hands dirty and would prefer not to type `kubectl` these two helper scripts will launch the registry

### start private registry

    `./start-docker-private-registry`

### stop private registry

    `./stop-docker-private-registry`

## Access the registry via port forwarding

Use the docker-private-registry pod to forward the port

    ./localhost-port-forward-registry

Then use the address/port

    127.0.0.1:30500

## Test the registry

Check if the registry catalog can be accessed and the ability to push an image.

    ```
    set -x && curl -X GET http://127.0.0.1:30500/v2/_catalog && sudo docker pull busybox && sudo docker tag busybox 127.0.0.1:30500/busybox && sudo docker push 127.0.0.1:30500/busybox
    curl -X GET --cacert ~/k8s-certs/ca.pem https://127.0.0.1:30500/v2/_catalog
    ```

## Example Build and Deployment

Feel free to extract the commands from the Makefile.  They are very simple.
build and push the example image to the registry
    
    `make build_image`  
    `make push_to_registry`  

Create a simple deployment

    `make create_deployment`

Check details of the deployed pod to ensure its using the built image
    
    `make describe_pod`
