# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update -y && apt-get install -y \
    munge \
    mariadb-server

# configure mariadb by issuing a couple of commands in the mysql shell
RUN service mysql start && \
    printf "create database slurm_acct_db;\n\
    create user 'slurm'@'localhost';\n\
    set password for 'slurm'@'localhost' = password('slurmdbpass');\n\
    grant usage on *.* to 'slurm'@'localhost';\n\
    grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';\n\
    flush privileges;" \
    | mysql -u root

RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    slurmd \
    slurm-client \
    slurmctld

# copy configuration files
COPY ./slurm.conf /etc/slurm-llnl/slurm.conf
COPY ./cgroup.conf /etc/slurm-llnl/cgroup.conf

WORKDIR /home/app
COPY ./entrypoint* ./

CMD ["./entrypoint-worker.sh"]
