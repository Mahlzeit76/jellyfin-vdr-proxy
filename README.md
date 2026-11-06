# Jellyfin VDR Streamdev & XMLTV Proxy

A standalone server designed to map standard IPTV interfaces on a Jellyfin media framework directly onto a VDR (Video Disk Recorder) backend running `streamdev-server`.

## Features

- **Online VDR EPG to XMLTV conversion** On the fly conversion of epg.data to XMLTV structure perfectly usable in Jellyfin's Live-TV EPG provider
- **Playlist creation from VDR channels** Providing a m3u file to use in Jellyfin's Live-TV m3u tuner or directly with e.g. VLC.

## Quickstart Deployment

1. Unpack the compressed project files.
2. Execute the self-checking interactive bash script:

   ```bash
   chmod +x install.sh
   sudo ./install.sh --install
   ```

3. Update parameters according to your specific environment (see Configuration) within your new default configuration layout directory at `/etc/jellyfin_vdr_proxy/config.ini` and restart jellyfin-vdr-proxy.
4. Add <PROXYADDRESS>/channels.m3u as Jellyfin Live-TV tuner (m3u tuner)
5. Add <PROXYADDRESS>/epg.xml as Jellyfin Live.TV EPG provider (xmltv)

## Restless Uninstallation

To clear the suite and revert system elements safely, execute:

```bash
sudo ./install.sh --uninstall
```

## Configuration

### Section [VDR]

| Parameter | Value |
| :--- | :--- |
| vdr_protocol | "http" or "https", depending on your VDR setup. Default "http" |
| vdr_ip | IP of VDR to use as streaming server and EPG source. Must be accessible from streaming client. |  
| streamdev_port | streamdev-server port. Default "3000" |
| epg_mode | "file" (to use epg.data) or "svdrp" (to directly use VDR LSTE command). Default svdrp |
| epg_data_path | Path to "epg.data" if "epg_mode=file". Default "/var/lib/vdr/epg.data" |
| svdrp_port | SVDRP Port if "epg_mode=svdrp". Default "6419" |
| svdrp_timeout | Timeout for SVDRP connection if "epg_mode=svdrp". Default "30" |

### Section [PROXY]

| Parameter | Value |
| :--- | :--- |
| listen_ip | Proxy listen IP. Default "0.0.0.0" |
| proxy_protocol | http or https. Default "http" |
| listen_port | Proxy listen port. Default "8080" |
| ssl_cert_file | Path to SSL certificate file. For https only - UNTESTED |
| ssl_key_file | Path to SSL key file. For https only - UNTESTED |
