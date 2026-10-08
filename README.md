# Lamm Kit

Shared Flutter package for the **Lamm** app family (OMK Software) — theme
tokens, components, purchases, credits, analytics, settings and format
helpers. Spec: §10 of each app's specification; visual tokens:
`LAMM_BRAND.md` (the brand doc lives with the apps, the implementation lives
here in `lib/src/theme/`).

## Using it

Depend on it **by tag**, never by branch:

```yaml
dependencies:
  lamm_kit:
    git:
      url: https://github.com/omaralqadri/lamm_kit.git
      ref: v0.1.1
```

## Fonts

The kit does not ship fonts. Apps must bundle the **Inter** and
**IBM Plex Sans Arabic** font files themselves and declare them in their own
`pubspec.yaml`.

## Rules

1. **No app-specific code.** Nothing here may mention PDF, QR, Photo Cleaner
   or Video — if a symbol needs to know which app it is in, it takes that from
   `LammAppConfig`, or it belongs in the app.
2. **No secrets, ever.** This repository is public. API keys (RevenueCat,
   Firebase, anything else) arrive at runtime through `--dart-define` and are
   passed in via `LammAppConfig`. An empty key means "not configured" and the
   kit falls back to its fake implementation, so apps build and test offline.
3. **Every platform capability sits behind an interface with a fake.**
4. **Tokens only.** The only file allowed to contain colour literals is
   `lib/src/theme/tokens.dart`; the contrast test guards the palette.
5. Changes flow: PR here → new tag → bump the `ref` in each app. Never edit a
   copy of the kit vendored inside an app.
