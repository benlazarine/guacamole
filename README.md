# Guacamole

### About

This container has a Guacamole installation configured for RDP only. It allows a user to connect to a remote Windows host through their web browser.

### Usage

Clone this repository and build it:

```
docker build -t guacamole .
```

Alternatively pull from Docker Hub:

```
docker pull cyverse/guacamole
```

Run it:

```
docker run -ti -p 8080:8080 \
  -e GUAC_USERNAME=REPLACETHIS \
  -e GUAC_PASSWORD=REPLACETHIS \
  -e RDP_HOST=REPLACETHIS \
  -e RDP_USERNAME=REPLACETHIS \
  -e RDP_PASSWORD=REPLACETHIS \
  -e RDP_IGNORE_CERT=REPLACETHIS \
  -e RDP_SECURITY=REPLACETHIS \
  guacamole-test
```

RDP_IGNORE_CERT and RDP_SECURITY are optional and can be ignored unless there's errors.  Refer to the guacamole docs here:

https://guacamole.apache.org/doc/gug/configuring-guacamole.html#rdp

When the container finishes starting up, it will present you with a link to access guacamole.  Ctrl+C to stop the container.

