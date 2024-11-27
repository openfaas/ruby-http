FROM ghcr.io/openfaas/of-watchdog:0.10.6 as watchdog

FROM ruby:3.3.6-slim

# AE: This step can take a few moments, however the resulting image
# is half the size of the non-slim image
RUN apt-get update && apt-get install -qqy \
    build-essential \
    libssl-dev \
    libffi-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

ARG ADDITIONAL_PACKAGE
RUN apt-get update \
  && apt-get install -qy --no-install-recommends ${ADDITIONAL_PACKAGE}

WORKDIR /home/app

COPY Gemfile    		.
COPY index.rb       .
COPY function       function

RUN bundle install \
  && mkdir -p /home/app/function

WORKDIR /home/app/function

RUN bundle install 

# Create a non-root user
RUN addgroup --system app \
    && adduser --system --ingroup app app

RUN chown app:app -R /home/app

USER app

WORKDIR /home/app

ENV fprocess="ruby index.rb"
EXPOSE 8080

HEALTHCHECK --interval=2s CMD [ -e /tmp/.lock ] || exit 1

ENV upstream_url="http://127.0.0.1:5000"
ENV mode="http"

CMD ["fwatchdog"]
