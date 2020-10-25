docker build -t dwemer/multi-client:latest -t dwemer/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t dwemer/multi-server:latest -t dwemer/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t dwemer/multi-worker:latest -t dwemer/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# dont have to login we already did that in travis
docker push dwemer/multi-client:latest
docker push dwemer/multi-server:latest
docker push dwemer/multi-worker:latest

# we push tags. So we have to push these too
docker push dwemer/multi-client:$SHA
docker push dwemer/multi-server:$SHA
docker push dwemer/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=dwemer/multi-server:$SHA
kubectl set image deployments/client-deployment client=dwemer/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=dwemer/multi-worker:$SHA