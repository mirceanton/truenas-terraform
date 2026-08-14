# NOTE: terraform-proxy is intentionally NOT managed here. Nexus 3.94.0+
# (we're on 3.95.1) added fields to proxy repository API responses that the
# sonatyperepo provider doesn't parse, even at latest (v1.14.0) -- import
# fails with `json: unknown field ...`. Known, open, currently-blocked
# upstream issue:
# https://github.com/sonatype-nexus-community/terraform-provider-sonatyperepo/issues/443
# The repo still exists and works in Nexus, it's just unmanaged for now.
