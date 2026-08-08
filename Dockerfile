FROM jellyfin/jellyfin:latest

# Instala o rclone
RUN apt-get update && \
    apt-get install -y rclone ca-certificates && \
    rm -rf /var/lib/apt-get/lists/*

# Cria a pasta dentro de /media e ajusta permissões
RUN mkdir -p /media/musicas && chmod -R 777 /media

# Script para puxar do OneDrive para /media/musicas
RUN echo '#!/bin/sh\n\
if [ -f /etc/secrets/rclone.conf ]; then\n\
    echo "Sincronizando músicas do OneDrive..."\n\
    rclone copy onedrive:Musicas /media/musicas --config /etc/secrets/rclone.conf --transfers 4\n\
fi\n\
exec /jellyfin/jellyfin' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
