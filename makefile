.PHONY: help setup build deploy destroy status test all

MINIKUBE_IP := $(shell minikube ip 2>/dev/null)
K8S_DIR := k8s
FRONTEND_IMAGE := mern-social-g47-secdevops-frontend
BACKEND_IMAGE := mern-social-g47-secdevops-mern-backend

help:
	@echo "Available targets:"
	@echo "  setup    - Setup Minikube and ingress"
	@echo "  build    - Build Docker images"  
	@echo "  deploy   - Deploy all components"
	@echo "  destroy  - Delete all resources"
	@echo "  status   - Check deployment status"
	@echo "  test     - Test services"
	@echo "  all      - Complete deployment"

setup:
	minikube start --driver=docker
	minikube addons enable ingress

build:
	eval $$(minikube docker-env) && \
	docker build -f docker/Dockerfile.frontend -t $(FRONTEND_IMAGE) . && \
	docker build -f docker/Dockerfile.backend -t $(BACKEND_IMAGE) .

deploy:
	kubectl apply -f $(K8S_DIR)/configmap.yml
<<<<<<< HEAD
	kubectl apply -f $(K8S_DIR)/tls-secret.yml
	kubectl apply -f $(K8S_DIR)/all-deployments-services.yml
	kubectl apply -f $(K8S_DIR)/ingress.yml
	sudo sed -i '/mern-app.local/d' /etc/hosts 2>/dev/null || true
	echo "$(MINIKUBE_IP) mern-app.local" | sudo tee -a /etc/hosts
=======
	kubectl create secret tls mern-tls-secret --cert=$(K8S_DIR)/tls.crt --key=$(K8S_DIR)/tls.key --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f $(K8S_DIR)/all-deployments-services.yml
	kubectl apply -f $(K8S_DIR)/ingress.yml
	@echo "Deployment complete. Add the following to your hosts file:"
	@echo "$(MINIKUBE_IP) mern-app.local"
>>>>>>> 6ef44bd19680cdfdbde0b0551697e5042064419c

status:
	kubectl get configmaps
	kubectl get secrets
	kubectl get deployments
	kubectl get services  
	kubectl get pods
	kubectl get ingress

test:
	curl -k https://mern-app.local/
	curl -k https://mern-app.local/api/
	curl -k https://mern-app.local/mongo-express/

destroy:
	kubectl delete -f $(K8S_DIR)/ --ignore-not-found=true
	sudo sed -i '/mern-app.local/d' /etc/hosts 2>/dev/null || true

all: setup build deploy
	@echo "Deployment complete. Access: https://mern-app.local/"