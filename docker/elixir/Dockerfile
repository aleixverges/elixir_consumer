FROM elixir:1.8.0

# Copy source code
COPY ./src/ /opt/app

# Set up the app
WORKDIR /opt/app

# Install hex & rebar
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
