FROM jellyfin/jellyfin:latest

# Instala o rclone
RUN apt-get update && \
    apt-get install -y rclone ca-certificates && \
    rm -rf /var/lib/apt-get/lists/*

# Script para puxar as músicas do OneDrive e iniciar o Jellyfin
RUN echo '#!/bin/sh\n\
mkdir -p /jellyfin/media/musicas\n\
if [ -f /etc/secrets/rclone.conf ]; then\n\
    echo "Sincronizando músicas do OneDrive..."\n\
    rclone copy onedrive:Musicas /jellyfin/media/musicas --config /etc/secrets/rclone.conf --transfers 4\n\
fi\n\
exec /jellyfin/jellyfin' > /entrypoint.sh && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
