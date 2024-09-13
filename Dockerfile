FROM nvidia/cuda:12.6.0-cudnn-runtime-rockylinux9

# EPEL
RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm -y

RUN crb enable

# RPM Fusion
RUN dnf install https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm -y
RUN dnf install https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm -y

# Install Packages
RUN dnf install wget make automake gcc gcc-c++ kernel-devel ffmpeg sox cuda-toolkit-12-3 -y

# Install Python
RUN wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
RUN tar xzf Python-3.9.16.tgz
RUN cd Python-3.9.16 && ./configure --enable-optimizations && make install

# Update PIP
# RUN python3 -m pip install pip == 24

# Move Files
RUN mkdir /app
WORKDIR /app
COPY . .

# Install Dependencies
RUN python3 -m pip install --no-cache-dir -r requirements.txt
RUN python3 -m pip install --no-cache-dir tensorboardX

RUN python3 /app/src/download_models.py

# Expose and Run
EXPOSE 8000
CMD ["python3", "src/webui.py", "--listen-host", "0.0.0.0", "--listen-port", "8000", "--listen"]
