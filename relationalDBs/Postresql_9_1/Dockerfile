FROM eric.djatsa/ubuntu_12_04
# IMAGE TAG will be : eric.djatsa/postgresql:9.1

RUN apt-get update && apt-get install -y -q --force-yes postgresql=9.1+129ubuntu1 \
	postgresql-contrib=9.1+129ubuntu1 

# Expose postgres default port
EXPOSE 5432 

# Start the database
CMD ["postgres " "-c " "/etc/init.d/postgresql " "start" ]
