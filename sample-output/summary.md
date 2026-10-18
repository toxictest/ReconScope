# ReconScope Report — `example.com`

**Generated:** 2026-10-17 10:23:24  |  **Duration:** 00:00:00  |  **Tool:** ReconScope v1.0.0

## Overview

| Metric | Value |
|---|---:|
| Unique subdomains | 13 |
| Hosts probed | 13 |
| Live hosts (filter `200,301,302,403`) | 13 |
| High-value targets | 8 |

## Status breakdown

| Status | Count |
|---|---:|
| 200 | 10 |
| 301 | 1 |
| 302 | 1 |
| 403 | 1 |
| Other | 0 |

## High-value targets

- `admin.example.com`
- `api.example.com`
- `dev.example.com`
- `mail.example.com`
- `old.example.com`
- `portal.example.com`
- `staging.example.com`
- `vpn.example.com`

## Top technologies

| Technology | Hosts |
|---|---:|
| Nginx | 7 |
| PHP | 2 |
| WordPress | 1 |
| MySQL | 1 |
| Kubernetes | 1 |
| Go | 1 |
| Express | 1 |
| Apache | 1 |

## Live hosts

```
https://admin.example.com	403	Admin Login	1204	PHP,MySQL	nginx	https://admin.example.com	10.0.0.11	cname.admin.example.com
https://api.example.com	200	API Gateway	2048	Go,Kubernetes	envoy	https://api.example.com	10.0.0.13	cname.api.example.com
https://blog.example.com	200	Homepage	4210	Nginx	nginx	https://blog.example.com	10.0.0.10	cname.blog.example.com
https://cdn.example.com	200	Homepage	4210	Nginx	nginx	https://cdn.example.com	10.0.0.10	cname.cdn.example.com
https://dev.example.com	200	Dev Environment	8812	Express	nodejs	https://dev.example.com	10.0.0.12	cname.dev.example.com
https://mail.example.com	200	Homepage	4210	Nginx	nginx	https://mail.example.com	10.0.0.10	cname.mail.example.com
https://old.example.com	301		120	Apache	apache	https://old.example.com	10.0.0.15	cname.old.example.com
https://portal.example.com	200	Homepage	4210	Nginx	nginx	https://portal.example.com	10.0.0.10	cname.portal.example.com
https://shop.example.com	200	Shop	54321	WordPress	nginx	https://shop.example.com	10.0.0.16	cname.shop.example.com
https://staging.example.com	302	Staging	340	PHP	apache	https://staging.example.com	10.0.0.14	cname.staging.example.com
https://vpn.example.com	200	Homepage	4210	Nginx	nginx	https://vpn.example.com	10.0.0.10	cname.vpn.example.com
https://wildcard.example.com	200	Homepage	4210	Nginx	nginx	https://wildcard.example.com	10.0.0.10	cname.wildcard.example.com
https://www.example.com	200	Homepage	4210	Nginx	nginx	https://www.example.com	10.0.0.10	cname.www.example.com
```
