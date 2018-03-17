# Hello



## Setup

* https://cloud.google.com/community/tutorials/elixir-phoenix-on-kubernetes-google-container-engine


## Make a new image and run with Docker

```
# build a new image
docker build --no-cache -t hello .

# run the image with docker
docker run -it --rm -p 8080:8080 hello

# open http://localhost:8080
```

## Run the container in Minikube
```
# start up minikube
minikube start

# let minikube and docker talk to each other
eval $(minikube docker-env)

# build the image (again?)

# test run from minikube (no deployment, just seeing if we can access the container via mini)
docker run -it --rm -p 8080:8080 hello

# see that it is running
open http://$(minikube ip):8080

# not sure a good way to kill this now, since <C-c> doesn't seem to work...
(open another termninal)
eval $(minikube docker-env)
docker kill <pid>
```

## Run k8s cluster in Minikube

Setup a local image registry with Docker (See: https://github.com/googlefonts/fontbakery-dashboard/issues/3)
```
# 1. start minikube that knows about the local registry
minikube start --insecure-registry localhost:5000

# 2. hook into docker
eval $(minikube docker-env)

# 3. create local registry
docker run -d -p 5000:5000 --restart=always --name registry   -v /data/docker-registry:/var/lib/registry registry:2
```

Publish image to local registry
```
# tag our image
docker tag hello:latest localhost:5000/hello/1

# publish our image
docker push localhost:5000/hello/1
```

Run k8s cluster
```
# create config files in ./k8s/
# (pod config) hello-deployment.yaml
# (load balancer service) hello-service.yaml

# create the deployment and service in minikube
minikube create -f k8s/hello-deployment.yaml
minikube create -f k8s/hello-service.yaml

# (later) when updating the configs, apply the changes
minikube apply -f k8s/hello-deployment.yaml
minikube apply -f k8s/hello-service.yaml

# open the service
minikube service hello-service

# check out the minikube dashboard
minikube dashboard

# peep the service using kubectl
kubectl get service
```

Making changes and pushing them (steps)
```
# edit some code

# re-build image
docker build --no-cache -t hello .

# re-tag our image
docker tag hello:latest localhost:5000/hello/<next-version>

# re-publish our image
docker push localhost:5000/hello/<next-version>

# update k8s deployment
# (edit image field to use next image)

# apply new deployment
minikube apply -f k8s/hello-deployment.yaml
```



To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
