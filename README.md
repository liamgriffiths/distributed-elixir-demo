# Distributed Elixir Demo 🔮

Hi, I made this little demo to show an example of how to setup a distributed Elixir
app that you can run on a local Kubernetes cluster.

Some of the things in this demo:
* Setting up a simple websocket-based Phoenix app
* Creating releases with Distillery
* Packaging a release inside a Docker container
* Running containers inside a Kubernetes cluster in distributed mode

## How to run this thing

### Download this stuff first

I'm using OSX, so the installation instructions are based on this.

```
# Make sure you have Elixir installed
$ brew install elixir

# Install node and npm (needed for Phoenix app)
$ brew install node

# Install Docker
# (download the installer from the website and run it)

# Install VirtualBox
# (download the installer from the website and run it)

# Install Minikube (mini kubernetes that runs on VirtualBox)
$ brew cask install minikube

# Install kubectl (command line tool to interact with Kubernetes)
$ brew install kubectl

# Clone this repo
$ git clone <this-repo>
```

### Get the Phoenix app up and running

Make sure the app works by running it on your local host first.

```
# Install Elixir && JS app dependencies
$ mix deps.get
$ (cd assets && npm i)

# Run the app
$ mix phx.server

# See that it works in the browser
$ open http://localhost:4000
```

### Creating a Distillery release

For this project I'm using
[distillery](https://github.com/bitwalker/distillery) to create an Elixir
release. A release is a single, deployable binary that contains all the
compiled app code as well as the Erlang runtime required to run it.  Distillery
automates this process and gives us a simple command line tool to do it.

```
# Build all the frontend assets, then create a manifest file for them
$ (cd assets && npm i && npm run deploy)
$ mix phx.digest

# Create a release with distillery
$ MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm mix release --env=prod --verbose

# Run the release it produced
$ MIX_ENV=prod PORT=4000 REPLACE_OS_VARS=true _build/prod/rel/hello/bin/hello foreground

# See that it works in the browser
$ open http://localhost:4000
```

### Creating a Distillery release in a Docker container

If we want to deploy this release to a Linux machine, we'll need to make sure that we
also _create_ our release in the same enviornment. This is because the release is
built using various system dependencies that may be wildly different on OSX than your
deployment target. We can use a Docker container to help us here. The trick here is
to use the Docker container to describe a environment that we will create
our release in which will be the same environment we eventually run our code in.

I used this
[Dockerfile](https://github.com/GoogleCloudPlatform/community/blob/master/tutorials/elixir-phoenix-on-kubernetes-google-container-engine/Dockerfile)
that I got from Google to create a docker image that creates our distillery
release and then uses that compiled code to expose an http port and run the
app.

```
# Create an image using the Dockerfile
$ docker build --no-cache -t hello .

# Run the docker image we just created like this
$ docker run -it --rm -p 8080:8080 hello

# See that it works in a browser
$ open http://localhost:8080

# Stop the running container (lookup the container id, then kill it)
$ docker ps
$ docker kill <container-id>
```


### Running the container in Minikube

Running a container one at a time is pretty cool, but our goal here is to run
many containers with our app. This is where Kubernetes comes in. Using
[Minikube](https://github.com/kubernetes/minikube) we can play around with a
local Kubernetes cluster. In addition, to just running mulitple containerized
instances of our app we would also like to let our app instances to be able to
"talk" to each other and share resources. This example repo is configured to
allow us to do this using a few tricks that I'll describe in detail later on.
But for now, let's see what it looks like to run it.

```
# Start up Minikube (takes a minute or two)
$ minikube start

# See that we're up and running the cluster
$ minikube status

# Let Minikube talk to our local Docker daemon
$ eval $(minikube docker-env)

# Build another image for our app (like we did before)
$ docker build --no-cache -t hello .

# Tag the image with a name we can use in our Kubernetes config
$ docker tag hello:latest liamgriffiths/hello:17

# Edit ./k8s/hello/deployment and change the "image" entry to be the new tag we just used
# (in this example it is "liamgriffiths/hello:17")

# Apply our kubernetes config to the cluster (more on this later)
$ ./apply-hello

# Checkout this awesome built-in dashboard to inspect it (see namespace "hello")
$ minikube dashboard

# Open the our kubernetes "service" in a web browser
$ minikube service service --namespace=hello

# Trash our Minikube cluster (if you don't want it anymore)
$ minikube delete
```

### Seeing what is going on with the cluster

... todo ...

## How this all works

### Phoenix websockets, channels, Elixir processes

... todo ...

* Card state, global processes (and why it might be a bad idea in prod :D)
* Phoenix channels, PG2

### Distributed Elixir/Erlang

... todo ...

* Erlang cookie
* Node names
* Peerage
* vm.args and build steps

### Kubernetes configuration

... todo ...

* About docker containers, tagging, versioning
* About the "namespace" config
* About the "deployment" config
* About the "service" config
* About the "headless-service" config

## Thanks ❤️

Big thanks to all the free projects out there that let me put this together:
Elixir, Phoenix, React, Docker, Kubernetes, Distillery, Peerage, and all people
who write about these things on the internet.

Some great blogs and tutorials that helped me out in particular:
* https://medium.com/polyscribe/a-complete-guide-to-deploying-elixir-phoenix-applications-on-kubernetes-part-1-setting-up-d88b35b64dcd
* https://cloud.google.com/community/tutorials/elixir-phoenix-on-kubernetes-google-container-engine
* https://hackernoon.com/state-of-the-art-in-deploying-elixir-phoenix-applications-fe72a4563cd8
* https://www.cogini.com/blog/best-practices-for-deploying-elixir-apps/
* http://0length.com/posts/Erlang-Clustering-on-Kubernetes.html
