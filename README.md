# homebrew-tap

## findutils

- add /Volumes to PRUNEPATHS
- to install, `brew install sharl/tap/findutils`

### 500.updatedb

to use,

```
$ brew install sharl/tap/findutils --default-names
$ wget -q https://gist.github.com/sharl/4592024/raw/9a834d9d9394cfb2d84c947e0581d1d928ee5b9f/batt -O /usr/local/bin/batt
$ sudo cp -p 500.updatedb /etc/periodic/daily/
```
