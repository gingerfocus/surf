{
  lib,
  stdenv,
  pkg-config,
  wrapGAppsHook3,
  glib,
  gcr,
  glib-networking,
  gsettings-desktop-schemas,
  gtk3,
  libsoup,
  webkitgtk_4_1,
  dmenu,
  findutils,
  gnused,
  coreutils,
  gst_all_1,
  zig,
}:
stdenv.mkDerivation {
  pname = "surf";
  version = "2.1";

  src = ./.;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    [
      glib
      gcr
      glib-networking
      gsettings-desktop-schemas
      gtk3
      libsoup
      webkitgtk_4_1
    ]
    ++ (with gst_all_1; [
      # Audio & video support for webkitgtk WebView
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
    ]);

  buildPhase = "${zig}/bin/zig build --prefix $out --cache-dir /build/zig-cache --global-cache-dir /build/global-cache -Doptimize=ReleaseSafe";

  # Add run-time dependencies to PATH. Append them to PATH so the user can
  # override the dependencies with their own PATH.
  preFixup = let
    depsPath = lib.makeBinPath [dmenu findutils gnused coreutils];
  in ''
    gappsWrapperArgs+=(--suffix PATH : ${depsPath})
  '';
}
