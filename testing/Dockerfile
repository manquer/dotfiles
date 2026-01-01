FROM python:3.12-slim

LABEL maintainer="dotfiles-testing"
LABEL description="Ansible control node for dotfiles testing"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    openssh-client \
    git \
    curl \
    sshpass \
    rsync \
    make \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible and dependencies
RUN pip install --no-cache-dir \
    ansible>=9.0.0 \
    ansible-lint \
    jmespath

# Create ansible user and directories
RUN useradd -m -s /bin/bash ansible && \
    mkdir -p /ansible/{playbooks,inventories,vars,templates,logs} && \
    chown -R ansible:ansible /ansible

# Set up SSH for ansible user
RUN mkdir -p /home/ansible/.ssh && \
    ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -N "" && \
    chown -R ansible:ansible /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    chmod 600 /home/ansible/.ssh/id_rsa

# Configure SSH client
RUN echo "Host *" >> /etc/ssh/ssh_config && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    echo "    UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config

# Set working directory
WORKDIR /ansible

# Switch to ansible user
USER ansible

# Set environment variables
ENV ANSIBLE_CONFIG=/ansible/ansible.cfg
ENV ANSIBLE_HOST_KEY_CHECKING=False
ENV ANSIBLE_STDOUT_CALLBACK=yaml

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD ansible --version || exit 1

CMD ["/bin/bash"]
