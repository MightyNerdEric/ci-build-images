FROM fedora:32

# required for lftools to work
ENV LC_ALL=en_US.utf-8 \
  LANG=en_US.utf-8

RUN dnf install -y git python3 python3-devel make automake gcc kernel-devel sudo
RUN dnf install -y https://github.com/MightyNerdEric/sigul/releases/download/0.209/sigul-0.209-1.fc32.x86_64.rpm

RUN curl "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py \
    && python get-pip.py \
    && rm -rf get-pip.py
RUN pip install --no-cache-dir --upgrade pip setuptools

RUN pip install --no-cache-dir -I lftools[openstack]
