docker build -t programmer26/multi-client:latest -t programmer26/multi-client:$SHA -f ./client/Dockerfile ./client

docker push programmer26/multi-client:latest

docker push programmer26/multi-client:$SHA

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=programmer26/multi-client:$SHA
