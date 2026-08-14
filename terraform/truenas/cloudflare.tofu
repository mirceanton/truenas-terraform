provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

data "cloudflare_zone" "mirceanton" {
  filter = { name = "mirceanton.com" }
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "zipline" {
  account_id = var.cloudflare_account_id
  name       = "zipline"
  config_src = "cloudflare"
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "zipline" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.zipline.id

  config = {
    ingress = [
      {
        hostname = "send.mirceanton.com"
        service  = "http://zipline:3000"
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "zipline" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.zipline.id
}

resource "cloudflare_dns_record" "zipline" {
  zone_id = data.cloudflare_zone.mirceanton.id
  name    = "send"
  type    = "CNAME"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.zipline.id}.cfargotunnel.com"
  ttl     = 1
  proxied = true
}
