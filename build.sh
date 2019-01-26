docker build -t programmer26/multi-client:latest -t programmer26/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t programmer26/multi-server:latest -t programmer26/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t programmer26/multi-worker:latest -t programmer26/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push programmer26/multi-client:latest
docker push programmer26/multi-server:latest
docker push programmer26/multi-worker:latest

docker push programmer26/multi-client:$SHA
docker push programmer26/multi-server:$SHA
docker push programmer26/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=programmer26/multi-server:$SHA
kubectl set image deployments/client-deployment client=programmer26/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=programmer26/multi-worker:$SHA