#FROM python:3.9.5-slim-buster
FROM python:3.9.5-buster
LABEL author="Lan"
LABEL email="vast@tom.com"
LABEL version="6"


COPY . /app
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 12345
CMD ["python","main.py"]
