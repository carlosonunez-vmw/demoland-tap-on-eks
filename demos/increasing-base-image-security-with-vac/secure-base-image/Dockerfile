# This app demonstrates how one can create a Dockerfile-based
# workflow within TAP.
# Since we're using the base NGINX image from the VMware Application Catalog,
# this app has fewer security vulnerabilities than one that used
# the open-source variant.
FROM harbor.tanzufederal.com/base-images/nginx:1.25.1

COPY ./index.html /app/index.html

EXPOSE 8080
