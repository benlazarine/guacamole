#!/bin/bash

help() {
echo "ERROR: One of the required vars has not been passed, please refer to the following help

USAGE:
docker run -it -p 8080:8080 guacamole:<tag> <option>

REQUIRED ENVIRONMENT VARIABLES:

GUAC_USERNAME - username to authenticate with guac
GUAC_PASSWORD - password to authenticate with guac
RDP_HOST - target RDP server
RDP_USERNAME - username to authenticate with RDP server
RDP_PASSWORD - password to authenticate with RDP server

OPTIONAL ENVIRONMENT VARIABLES:

RDP_IGNORE_CERT - ignore warnings that service can't verify remote computer
RDP_SECURITY - security mode for RDP, options are \"rdp, nla, tls, any\", default is nla

For more information see: https://github.com/cyverse/guacamole"
}

default() {
  echo \
"<user-mapping>
    <authorize username=\"$GUAC_USERNAME\" password=\"$GUAC_PASSWORD\">
        <connection name=\"RDP\">
            <protocol>rdp</protocol>
            <param name=\"hostname\">$RDP_HOST</param>
            <param name=\"username\">$RDP_USERNAME</param>
            <param name=\"password\">$RDP_PASSWORD</param>
            <param name=\"ignore-cert\">$RDP_IGNORE_CERT</param>
            <param name=\"security\">$RDP_SECURITY</param>
        </connection>
    </authorize>
</user-mapping>" > /etc/guacamole/user-mapping.xml

  echo \
"*==================================================================*
  For RDP: http://localhost:8080/?username=$GUAC_USERNAME&password=$GUAC_PASSWORD
*==================================================================*" > /etc/help-msg
}




# if not defined, define these:

: ${RDP_IGNORE_CERT:="true"}
: ${RDP_SECURITY:="nla"}

# if not defined, print help and exit:
if [[ -z ${GUAC_USERNAME} || -z ${GUAC_PASSWORD} || -z ${RDP_HOST} || -z ${RDP_USERNAME} || -z ${RDP_PASSWORD} ]] ; then
    help
    exit 1
else
    default
fi

service tomcat8 start; \
cat /etc/help-msg && \
guacd -L debug -f
