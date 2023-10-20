FROM python:3.9.5-slim-buster
LABEL author="Lan"
LABEL email="vast@tom.com"
LABEL version="6"


COPY . /app
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
#RUN apt-get install gcc libffi-devel python3-devel openssl-devel -y

##
# general python
RUN apt-get update && apt-get install python3 python3-dev python3-yaml python3-pip python3-setuptools

# reqs
RUN apt-get install libatlas-base-dev openmpi-bin libopenblas-dev libblas-dev m4 cmake cython python3-dev

# torch
RUN pip3 install https://github.com/radimspetlik/pytorch_rpi_builds/raw/master/torch-1.6.0a0%2B9d7a79a-cp37-cp37m-linux_armv7l.whl
RUN apt-get install libgomp1 libatomic1

# more reqs
RUN apt-get install -y llvm git

# python basics
RUN python3 -m pip install packaging wheel setuptools Cython


# install torchaudio
RUN apt-get install -y build-essential pkg-config
RUN git clone https://github.com/pytorch/audio && cd audio && git checkout v0.6.0 && BUILD_SOX=1 python3 setup.py install


# wrap pip command + reqs
RUN BLIS_ARCH="generic" python3 -m pip install spacy --no-binary blis

# llvm-9
RUN apt-get purge llvm-7
RUN apt-get install -y llvm-9 llvm-9-dev

# pip
COPY constraints.txt .
COPY requirements.inference.armv7.txt .
RUN LLVM_CONFIG=/usr/bin/llvm-config-9 pip3 install -r requirements.inference.armv7.txt -c constraints.txt 

# fixes
RUN apt-get install -y libsndfile1 libsndfile1-dev libjpeg-dev libopenjp2-7 libtiff5 libxcb1
RUN apt-get install -y llvm llvm-dev
RUN LLVM_CONFIG=/usr/bin/llvm-config pip3 install numba==0.49.1

##
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 12345
CMD ["python","main.py"]
