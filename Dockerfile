# Use official Ruby 3.3 slim image for compatibility
FROM ruby:3.3-slim

LABEL maintainer="Amir Pourmand"

# Set locale
RUN apt-get update -y && \
    apt-get install -y locales && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8  

# Install system dependencies for Jekyll and native gems (mini_racer, etc.)
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        g++ \
        pkg-config \
        git \
        curl \
        python3 \
        imagemagick \
        unzip \
        xz-utils \
        libv8-dev \
        zlib1g-dev \
        libxml2-dev \
        libxslt1-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create working directory
RUN mkdir /srv/jekyll
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock first (for caching)
COPY Gemfile Gemfile.lock ./

# Install bundler and gems
RUN gem install bundler && bundle install

# Copy the rest of the site
COPY . .

# Expose default Jekyll port
EXPOSE 4000

# Default command
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
