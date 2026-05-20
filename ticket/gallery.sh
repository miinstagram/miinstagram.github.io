#! /bin/sh
rm -rf thumb-*

cat > index.html << 'HTMLHEAD'
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>My file gallery</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  body {
    font-family: 'DM Sans', sans-serif;
    background: #111;
    color: #e8e8e8;
    min-height: 100vh;
    padding: 2rem;
  }

  h1 {
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.15em;
    text-transform: uppercase;
    color: #666;
    margin: 2.5rem 0 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 1px solid #222;
  }

  h1:first-of-type { margin-top: 0; }

  /* Subdirs */
  .subdirs {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .subdirs a {
    display: inline-block;
    padding: 0.35rem 0.85rem;
    background: #1e1e1e;
    border: 1px solid #2a2a2a;
    border-radius: 6px;
    color: #ccc;
    text-decoration: none;
    font-size: 0.85rem;
    transition: background 0.15s, color 0.15s, border-color 0.15s;
  }

  .subdirs a:hover {
    background: #2a2a2a;
    border-color: #444;
    color: #fff;
  }

  /* Grid for images and videos */
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 1rem;
  }

  .card {
    background: #1a1a1a;
    border: 1px solid #232323;
    border-radius: 10px;
    overflow: hidden;
    transition: transform 0.18s ease, box-shadow 0.18s ease, border-color 0.18s;
    cursor: pointer;
  }

  .card:hover {
    transform: translateY(-4px);
    box-shadow: 0 12px 32px rgba(0,0,0,0.5);
    border-color: #3a3a3a;
  }

  .card-media {
    width: 100%;
    aspect-ratio: 4/3;
    overflow: hidden;
    background: #0d0d0d;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .card-media img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
    transition: opacity 0.2s;
  }

  .card-media video {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }

  .card-label {
    padding: 0.55rem 0.7rem;
    border-top: 1px solid #222;
  }

  .card-label a {
    color: #aaa;
    text-decoration: none;
    font-size: 0.78rem;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: block;
    transition: color 0.15s;
  }

  .card-label a:hover { color: #fff; }
</style>
</head>
<body>
HTMLHEAD

# Subdirs
echo "<h1>Directorios</h1>" >> index.html
echo "<div class=\"subdirs\">" >> index.html
found_dir=0
for D in *; do
    if [ -d "${D}" ]; then
        echo "<a href=\"$D\">📁 $D</a>" >> index.html
        found_dir=1
    fi
done
if [ "$found_dir" = "0" ]; then
    echo "<span style=\"color:#444;font-size:0.85rem;\">Sin subdirectorios</span>" >> index.html
fi
echo "</div>" >> index.html

# Images
echo "<h1>Imágenes</h1>" >> index.html
echo "<div class=\"grid\">" >> index.html
found_img=0
for img in *.jpg *.JPG *.png *.PNG *.bmp *.BMP *.jpeg *.JPEG *.gif *.GIF; do
    if [ ! -f "${img}" ]; then
        continue
    fi
    convert -auto-orient -scale 300 "$img" "thumb-$img"
    echo "<div class=\"card\">" >> index.html
    echo "  <a href=\"$img\" target=\"_blank\" rel=\"noopener\">" >> index.html
    echo "    <div class=\"card-media\"><img src=\"thumb-$img\" alt=\"$img\" loading=\"lazy\"></div>" >> index.html
    echo "  </a>" >> index.html
    echo "  <div class=\"card-label\"><a href=\"$img\" target=\"_blank\" rel=\"noopener\">$img</a></div>" >> index.html
    echo "</div>" >> index.html
    found_img=1
done
if [ "$found_img" = "0" ]; then
    echo "<p style=\"color:#444;font-size:0.85rem;\">Sin imágenes</p>" >> index.html
fi
echo "</div>" >> index.html

# Videos
echo "<h1>Videos</h1>" >> index.html
echo "<div class=\"grid\">" >> index.html
found_vid=0
for video in *.mp4 *.MP4 *.ogg *.OGG *.avi *.AVI *.mkv *.MKV *.mpeg *.MPEG; do
    if [ ! -f "${video}" ]; then
        continue
    fi
    echo "<div class=\"card\">" >> index.html
    echo "  <div class=\"card-media\">" >> index.html
    echo "    <video controls preload=\"metadata\">" >> index.html
    echo "      <source src=\"$video\">" >> index.html
    echo "    </video>" >> index.html
    echo "  </div>" >> index.html
    echo "  <div class=\"card-label\"><a href=\"$video\" target=\"_blank\" rel=\"noopener\">$video</a></div>" >> index.html
    echo "</div>" >> index.html
    found_vid=1
done
if [ "$found_vid" = "0" ]; then
    echo "<p style=\"color:#444;font-size:0.85rem;\">Sin videos</p>" >> index.html
fi
echo "</div>" >> index.html

echo "</body></html>" >> index.html
