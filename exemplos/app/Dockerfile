FROM nginx:1.27-alpine

RUN apk add --no-cache gettext

ARG IMAGE_TAG=local
ENV IMAGE_TAG=${IMAGE_TAG}
ENV APP_ENV=dev

COPY index.html /usr/share/nginx/html/index.html.template

EXPOSE 80
CMD ["/bin/sh", "-c", "envsubst '${APP_ENV} ${HOSTNAME} ${IMAGE_TAG}' < /usr/share/nginx/html/index.html.template > /usr/share/nginx/html/index.html && exec nginx -g 'daemon off;'"]
