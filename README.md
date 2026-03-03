# Erome Downloader

An Android app that lets you browse Erome and download albums with a single tap. Built with Flutter.

## Features
- In‑app browser with automatic download button on album pages.
- Concurrent downloads with progress tracking.
- Background downloads using foreground service (Android 14+ compatible).
- Files are saved to the device gallery (visible in Photos app).
- Download queue persists across app restarts.
- Pause/resume support (via HTTP range requests).
- WiFi‑only toggle (optional).

## How to Build (Automated via GitHub Actions)
This repository uses GitHub Actions to build the APK automatically when you create a release tag.

1. Push a tag starting with `v` (e.g., `v1.0.0`).
2. The workflow will:
   - Generate Android platform files.
   - Add required permissions (foreground service, network config).
   - Build split APKs (arm64-v8a, armeabi-v7a, x86_64).
   - Upload the APKs to the release.

## Trigger a Release
1. Go to the **Releases** page of this repository.
2. Click **"Create a new release"**.
3. Enter a tag like `v1.0.0` and a title.
4. Click **"Publish release"**.
5. Wait a few minutes, then download the APK for your device (usually `app-arm64-v8a-release.apk` for modern phones).

## Custom Icon
To add a custom app icon:
1. Place a PNG image named `icon.png` (at least 512×512) in the `assets/` folder.
2. The workflow will automatically use it on the next build.

## License
This project is for educational purposes only. Respect Erome's Terms of Service.
