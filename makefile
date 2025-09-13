.PHONY: setup build deploy destroy status test logs all

MINIKUBE_IP := $(shell minikube ip 2>/dev/null)
K8S_DIR := k8s
FRONTEND_IMAGE := mern-social-g47-secdevops-frontend
BACKEND_IMAGE := mern-social-g47-secdevops-mern-backend

setup:
	minikube start --driver=docker
	minikube addons enable ingress

build:
	eval $$(minikube docker-env) && \
	docker build -f Dockerfile.frontend -t $(FRONTEND_IMAGE) . && \
	docker build -f Dockerfile.backend -t $(BACKEND_IMAGE) .

deploy:
	kubectl apply -f $(K8S_DIR)/mongo-deployment.yml
	kubectl apply -f $(K8S_DIR)/mongo-service.yml
	kubectl apply -f $(K8S_DIR)/backend-deployment.yml
	kubectl apply -f $(K8S_DIR)/backend-service.yml
	kubectl apply -f $(K8S_DIR)/frontend-deployment.yml
	kubectl apply -f $(K8S_DIR)/frontend-service.yml
	kubectl apply -f $(K8S_DIR)/mongo-express-deployment.yml
	kubectl apply -f $(K8S_DIR)/mongo-express-service.yml
	kubectl apply -f $(K8S_DIR)/ingress.yml
	sudo sed -i '/mern-app.local/d' /etc/hosts 2>/dev/null || true
	echo "$(MINIKUBE_IP) mern-app.local" | sudo tee -a /etc/hosts

status:
	kubectl get deployments
	kubectl get services
	kubectl get pods
	kubectl get ingress

test:
	curl -k https://mern-app.local/
	curl -k https://mern-app.local/api/
	curl -k https://mern-app.local/mongo-express/

logs:
	kubectl logs -l app=mongodb --tail=10
	kubectl logs -l app=mern-backend --tail=10
	kubectl logs -l app=mern-frontend --tail=10
	kubectl logs -l app=mongo-express --tail=10

destroy:
	kubectl delete -f $(K8S_DIR)/ --ignore-not-found=true
	sudo sed -i '/mern-app.local/d' /etc/hosts 2>/dev/null || true

all: setup build deploy
	@echo "Deployment complete. Access: https://mern-app.local/"