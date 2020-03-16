Installation of the translation files
=====================================

```bash
source /usr/local/oecore-x86_64/environment-setup-armv7vet2hf-neon-oe-linux-gnueabi
/usr/local/oecore-x86_64/sysroots/x86_64-oesdk-linux/usr/bin/qmake alarmpresenter.pro
lrelease alarmpresenter.pro
cd i18n
scp *.qm root@192.168.2.15:/usr/share/translations/
```
