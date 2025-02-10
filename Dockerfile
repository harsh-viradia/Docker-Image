FROM alpine:3.20.1

# Install required dependencies
RUN apk add --no-cache \
    curl \
    unzip \
    gnupg \
    wget \
    python3 \
    py3-pip \
    py3-virtualenv \
    bash \
    git \
    libc6-compat \
    openssl  \
    jq

# Install AWS CLI
RUN apk add curl aws-cli --no-cache

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.9.2/terraform_1.9.2_linux_amd64.zip && \
    wget https://releases.hashicorp.com/terraform/1.9.2/terraform_1.9.2_SHA256SUMS && \
    grep terraform_1.9.2_linux_amd64.zip terraform_1.9.2_SHA256SUMS | sha256sum -c && \
    unzip terraform_1.9.2_linux_amd64.zip -d /usr/local/bin && \
    rm terraform_1.9.2_linux_amd64.zip terraform_1.9.2_SHA256SUMS

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Keda CLI
RUN curl -LO "https://github.com/kedacore/keda/releases/download/v2.11.2/keda-linux-amd64" && \
    mv keda-linux-amd64 /usr/local/bin/keda && \
    chmod +x /usr/local/bin/keda

# Create a Python virtual environment and install boto3
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --no-cache-dir boto3

# Ensure that the virtual environment is activated by default
ENV PATH="/opt/venv/bin:$PATH"

CMD ["sleep", "infinite"]
