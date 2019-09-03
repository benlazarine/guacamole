# Guacamole

### About

This container has a Guacamole installation configured for RDP only. It allows a user to connect to a remote Windows host through their web browser.

### Usage

#### Getting the image:

Clone this repository and build it:

```
docker build -t guacamole .
```

Alternatively pull from Docker Hub:

```
docker pull cyverse/guacamole
```

#### Run Method 1: Specifying All Environment Variables

Run the following, replacing vars:

```
docker run -ti -p 8080:8080 \
  -e GUAC_USERNAME=REPLACETHIS \
  -e GUAC_PASSWORD=REPLACETHIS \
  -e RDP_HOST=REPLACETHIS \
  -e RDP_USERNAME=REPLACETHIS \
  -e RDP_PASSWORD=REPLACETHIS \
  -e RDP_IGNORE_CERT=REPLACETHIS \
  -e RDP_SECURITY=REPLACETHIS \
  guacamole
```


`RDP_IGNORE_CERT` and `RDP_SECURITY` are optional and can be ignored unless there's errors.  Refer to the guacamole docs here:

https://guacamole.apache.org/doc/gug/configuring-guacamole.html#rdp

When the container finishes starting up, it will present you with a link to access guacamole.  Ctrl+C to stop the container.

#### Method 2: Specifying IPLANT_USER to Copy Local Configs

Create folders for usernames, storing user-mapping.xml.  As an example:

```
find /users
/users
/users/user2
/users/user2/user-mapping.xml
/users/user1
/users/user1/user-mapping.xml
/users/user3
/users/user3/user-mapping.xml
```

Run the following:

```
docker run -ti -p 8080:8080 -v /users:/guacamole-user-settings -e IPLANT_USER=user1 guacamole

```
