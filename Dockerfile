FROM nvidia/cuda:12.6.0-cudnn-runtime-rockylinux9

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
