FROM hadoop-base:3.3.6

COPY startup.sh .

ENV PYTHON_CMD=/usr/bin/python

RUN chmod +x startup.sh

EXPOSE 50111

CMD [ "./startup.sh" ]