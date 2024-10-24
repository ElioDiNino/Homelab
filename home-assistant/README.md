# Home Assistant

Home Assistant is an open-source home automation platform. I use it to manage my smart home devices and services, notably old smartphones running [IP Webcam](https://play.google.com/store/apps/details?id=com.pas.webcam) for security cameras.

## Commands

### Start services

```sh
sudo docker compose up -d
```

### Stop services

```sh
sudo docker compose down
```

### Update services

```sh
sudo docker compose pull
sudo docker compose up -d
```
