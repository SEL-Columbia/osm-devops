FROM java:8
MAINTAINER Flávio Briz

ADD ./src /project
WORKDIR /project
RUN ./gradlew assemble
CMD ["./package/bin/osmosis"]
