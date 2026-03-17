# cert-manager Runbook

A brief runbook for what to do when some of the alerts from this mixin start firing. This is a bit of a WIP - if you spot anything that needs tweaking contributions are welcome!

- [CertManagerAbsent](#certmanagerabsent)
- [CertManagerCertExpirySoon](#certmanagercertexpirysoon)
- [CertManagerCertNotReady](#certmanagercertnotready)
- [CertManagerHittingRateLimits](#certmanagerhittingratelimits)

## CertManagerAbsent

This alert fires when there is no cert-manager endpoint discovered by Prometheus. Causes could be a few things.

- Ensure cert-manager is up and running.
- Ensure service discovery is configured correctly for cert-manager.

## CertManagerCertExpirySoon

A certificate that cert-manager is maintaining has not been renewed within the expected timeframe. Rather than using a fixed expiry threshold, this alert dynamically computes each certificate's renewal window from `certmanager_certificate_expiration_timestamp_seconds - certmanager_certificate_renewal_timestamp_seconds` and fires once a configurable fraction of that window has elapsed (default: 30%, controlled by `certManagerCertExpiryRenewalElapsedThreshold`).

This alert only fires for certificates that are currently in a **Ready** state (`certmanager_certificate_ready_status{condition="True"}`). Certificates that are not ready will trigger the separate `CertManagerCertNotReady` alert instead.

Ensure the certificate issuer is configured correctly. Check cert-manager logs for errors renewing this certificate.

*NOTE: Versions of cert-manager before 0.16.0 do not remove metrics for deleted certificates. Rolling cert-manager or upgrading cert-manager should resolve this.*

## CertManagerCertNotReady

A certificate has not been ready to serve traffic for at least 10m. Typically this means the cert is not yet signed. If the cert is being renewed or there is another valid cert, the ingress controller _should_ be able to serve that instead. If not, need to investigate why the certificate is not yet ready.

Ensure cert-manager is configured correctly, no ACME/LetsEncypt rate limits are being hit. Ensure RBAC permissions are still correct for cert-manager.

## CertManagerHittingRateLimits

Cert-manager is being rate-limited by the ACME provider. Let's Encrypt rate limits can last for up to a week. There could be up to a weeks delay in provisioning or renewing certificates, depending on the action that's being rate limited.

Let's Encrypt suggest the application process for extending rate limits can take a week. Other ACME providers could likely have different rate limits.

[Let's Encrypt Rate Limits](https://letsencrypt.org/docs/rate-limits/)
