FROM tensorflow/tensorflow:1.14.0-py3

RUN pip3 install sentencepiece

COPY ./ /app
COPY ./docker/entrypoint.sh /app
WORKDIR /app

RUN cd /app/server && python3 setup.py install
RUN cd /app/client && python3 setup.py install

EXPOSE 5555
EXPOSE 5556
EXPOSE 6006

ENV BERT_SERVER_MODEL_DIR /app/model
ENV BERT_SERVER_TMP_DIR /app/tmp
ENV TENSORFLOW_LOGS_DIR /app/logs

ENTRYPOINT ["/app/entrypoint.sh"]
CMD []