FROM alpine:3.20.1
# Install aws-cli
RUN apk add curl aws-cli --no-cache
 
# Install kubectl cli
RUN curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl
 
# Install terraform
RUN apk add --update --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/1.9.2/terraform_1.9.2_linux_amd64.zip && \
    wget https://releases.hashicorp.com/terraform/1.9.2/terraform_1.9.2_SHA256SUMS && \
    wget https://releases.hashicorp.com/terraform/1.9.2/terraform_1.9.2_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify terraform_1.9.2_SHA256SUMS.sig terraform_1.9.2_SHA256SUMS && \
    grep terraform_1.9.2_linux_amd64.zip terraform_1.9.2_SHA256SUMS | sha256sum -c && \
    unzip /tmp/terraform_1.9.2_linux_amd64.zip -d /tmp && \
    mv /tmp/terraform /usr/local/bin/terraform && \
    rm -f /tmp/terraform_1.9.2_linux_amd64.zip terraform_1.9.2_SHA256SUMS 1.9.2/terraform_1.9.2_SHA256SUMS.sig && \
    apk del .deps

# Install necessary tools including Python3 and venv
RUN apk add --no-cache python3 py3-pip py3-virtualenv curl aws-cli gnupg unzip

# Create a virtual environment and install boto3
RUN python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --no-cache-dir boto3

# Ensure that the virtual environment is activated by default
ENV PATH="/opt/venv/bin:$PATH"

CMD ["sleep", "infinite"]