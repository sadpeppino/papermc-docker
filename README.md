# Paper Spigot Dockerized

Build your image using:

```sh
$ docker build -t minecraft-server .
```

Run the server using:

```sh
$ docker run -name minecraft-server -d -e MEMORY_ALLOC=1G minecraft-server
```

# Accessing the Console

If you want to type a command in your minecraft console, use the following:

```sh
$ docker exec -it minecraft-server sh
# inside the container shell then use
$ screen -list
# find the only screen open and copy its id
$ screen -x <screen-id>
```
