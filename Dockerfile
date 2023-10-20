FROM python:3.9.5-slim-buster
LABEL author="Lan"
LABEL email="vast@tom.com"
LABEL version="6"


COPY . /app
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
#RUN apt-get install gcc libffi-devel python3-devel openssl-devel -y

##


# pip
COPY constraints.txt .
COPY requirements.inference.armv7.txt .
RUN LLVM_CONFIG=/usr/bin/llvm-config-9 pip3 install -r requirements.inference.armv7.txt -c constraints.txt 

##
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 12345
CMD ["python","main.py"]
