FROM ortussolutions/commandbox:lucee5-3.1.0
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y gettext --no-install-recommends
RUN apt-get clean autoclean && apt-get autoremove -y

ENTRYPOINT ["/entrypoint.sh"]
