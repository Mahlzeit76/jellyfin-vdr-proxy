# Jellyfin VDR Streamdev & XMLTV Proxy

An automated, standalone Python 3 networking environment designed to map standard IPTV interfaces on a Jellyfin media framework directly onto a VDR (Video Disk Recorder) backend running `streamdev-server`.

## Features
 **Online VDR EPG to XMLTV conversion** On the fly conversion of epg.data to XMLTV structure perfectly usable in Jellyfin's Live-TV EPG provider
- **Playlist creation from VDR channels** Providing a m3u file to use in Jellyfin's Live-TV m3u tuner or directly with e.g. VLC.
- **SSL / TLS Integration:** Native secure listener layer configurable right inside the core configuration file.

## Quickstart Deployment

1. Unpack the compressed project files.
2. Execute the self-checking interactive bash script:
   ```bash
   chmod +x install.sh
   sudo ./install.sh --install
   ```
3. Update parameters according to your specific environment within your new default configuration layout directory at `/etc/jellyfin_vdr_proxy/config.ini` and restart jellyfin-vdr-proxy.
4. Add <PROXYADDRESS>/channels.m3u as Jellyfin Live-TV tuner (m3u tuner)
5. Add <PROXYADDRESS>/epg.xml as Jellyfin Live.TV EPG provider (xmltv)

## Restless Uninstallation
To clear the suite and revert system elements safely, execute:
```bash
sudo ./install.sh --uninstall
```
