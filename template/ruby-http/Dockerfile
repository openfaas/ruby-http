FROM openfaas/of-watchdog:0.5.3 as watchdog

FROM ruby:2.4-alpine3.8

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

ARG ADDITIONAL_PACKAGE

RUN apk --no-cache add ${ADDITIONAL_PACKAGE}

WORKDIR /home/app

COPY Gemfile    		.
COPY index.rb       .
COPY function       function

RUN bundle install \
  && mkdir -p /home/app/function

WORKDIR /home/app/function

RUN bundle install 

RUN addgroup -S app \
  && adduser app -S -G app

RUN chown app:app -R /home/app

USER app

WORKDIR /home/app

ENV fprocess="ruby index.rb"
EXPOSE 8080

HEALTHCHECK --interval=2s CMD [ -e /tmp/.lock ] || exit 1

ENV upstream_url="http://127.0.0.1:5000"
ENV mode="http"

CMD ["fwatchdog"]

