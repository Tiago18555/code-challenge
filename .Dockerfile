FROM apache/airflow:2.1.0
ARG EMBULK_VERSION=0.9.23
USER root
RUN apt-get update && apt-get install -y \
    default-jre \
    && rm -rf /var/lib/apt/lists/*
RUN curl -L https://dl.embulk.org/embulk-${EMBULK_VERSION}.jar -o /bin/embulk \
    && chmod +x /bin/embulk
USER airflow
COPY ./embulk_config /opt/airflow/embulk_config
COPY ./dags /opt/airflow/dags
COPY ./plugins /opt/airflow/plugins
COPY ./requirements.txt /opt/airflow/requirements.txt
RUN pip install --no-cache-dir -r /opt/airflow/requirements.txt
WORKDIR /opt/airflow
CMD ["tail", "-f", "/dev/null"]