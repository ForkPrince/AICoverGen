FROM nvidia/cuda:12.6.0-cudnn-runtime-rockylinux9

# RPM Fusion
RUN dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
RUN dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Update System
RUN dnf update && dnf upgrade

# Install Packages
RUN dnf install wget build-essential ffmpeg sox cuda-toolkit-12-3 -y

# Install Python
RUN wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
RUN tar xzf Python-3.9.16.tgz
RUN cd Python-3.9.16
RUN ./configure --enable-optimizations
RUN make altinstall

# Update PIP
RUN python -m pip install --upgrade pip

# Move Files
RUN mkdir /app
WORKDIR /app
COPY . .

# Install Dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir tensorboardX

RUN python /app/src/download_models.py

# Expose and Run
EXPOSE 8000
CMD ["python3", "src/webui.py", "--listen-host", "0.0.0.0", "--listen-port", "8000", "--listen"]
