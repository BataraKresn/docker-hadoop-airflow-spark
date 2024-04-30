FROM hadoop-base:3.3.6

HEALTHCHECK CMD netstat -tuplen | grep 9083 || exit 1

COPY startup.sh .
RUN chmod +x startup.sh

EXPOSE 9083

CMD [ "./startup.sh" ]