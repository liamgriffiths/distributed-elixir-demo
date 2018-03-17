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
