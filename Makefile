#REPO_HOST=docker.io
REPO_HOST=127.0.0.1:30500
IMAGE_NAME:=${REPO_HOST}/alta3/nginx_test

build_image:
	sudo docker build --force-rm=true -t $(IMAGE_NAME) .

push_to_registry:
	sudo docker push $(IMAGE_NAME)

create_deployment:
	@kubectl apply -f nginx-test-deployment.yaml -n default

delete_deployment:
	@kubectl delete -f nginx-test-deployment.yaml --ignore-not-found -n default

describe_pod:
	@POD_NAME=$$(kubectl get pods -l app=nginx-test -n default | sed -e '1d'|awk '{print $$1}') && kubectl describe pod $${POD_NAME} -n default

