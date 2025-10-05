# Handover Notes

- Separated docker, kube, and mern-social files.
- Created yml files listed in kube handover notes.
- Created makefile for lab demo.

## Install Minikube and kubectl

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube with Ingress
minikube start --driver=docker
minikube addons enable ingress
```

## Build Docker Images in Minikube

```bash
# Configure Docker to use Minikube
eval $(minikube docker-env)

# Build images from project root
docker build -f Dockerfile.frontend -t mern-social-g47-secdevops-frontend .
docker build -f Dockerfile.backend -t mern-social-g47-secdevops-mern-backend .

# Verify images
docker images
```

## Deploy Services

```bash
# Deploy MongoDB (backend dependency)
kubectl apply -f k8s/mongo-deployment.yml
kubectl apply -f k8s/mongo-service.yml

# Deploy backend (frontend dependency)  
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/backend-service.yml

# Deploy frontend
kubectl apply -f k8s/frontend-deployment.yml
kubectl apply -f k8s/frontend-service.yml

# Deploy Mongo Express
kubectl apply -f k8s/mongo-express-deployment.yml
kubectl apply -f k8s/mongo-express-service.yml

# Deploy Ingress
kubectl apply -f k8s/ingress.yml
```

## Verify

```bash
# Check deployments
kubectl get deployments

# Check services
kubectl get services

# Check pods
kubectl get pods

# Check ingress
kubectl get ingress
```

## Access

```bash
# Remove old entries
sudo sed -i '/mern-app.local/d' /etc/hosts

# Add new entry with Minikube IP
echo "$(minikube ip) mern-app.local" | sudo tee -a /etc/hosts

# Frontend: https://mern-app.local/
# Backend API: https://mern-app.local/api/
# Mongo Express: https://mern-app.local/mongo-express/
```

## Testing

```bash
# Test services
kubectl get all

# Check ingress status
kubectl get ingress

# Test frontend 
curl -k https://mern-app.local/

# Test backend 
curl -k https://mern-app.local/api/

# Test MongoDB 
kubectl exec -it $(kubectl get pods -l app=mongodb -o jsonpath='{.items[0].metadata.name}') -- mongo --eval "db.adminCommand('ismaster')"

# Test Mongo Express
curl -k https://mern-app.local/mongo-express/
```
