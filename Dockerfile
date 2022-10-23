FROM alpine:latest

RUN apk add --update curl

COPY main.sh /
RUN ["chmod", "+x", "/main.sh"]

ENTRYPOINT ["sh","/main.sh"]