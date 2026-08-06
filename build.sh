#!/bin/sh
# Cloudflare Pages build: generate assets/img/*.img.svg wrappers from the
# original JPEGs (GitHub API pushes cannot carry binaries, and wrappers embed
# the JPEG as base64 inside an SVG <image> element).
set -eu

mkdir -p assets/img

gen() {
  name="$1"; url="$2"; w="$3"; h="$4"
  echo "Fetching $name.jpg"
  curl -fsSL --retry 3 --retry-delay 2 "$url" -o "/tmp/$name.jpg"
  # base64 without line wrapping, then fold at 76 cols
  if base64 -w0 /dev/null >/dev/null 2>&1; then
    b64=$(base64 -w0 "/tmp/$name.jpg")
  else
    b64=$(base64 "/tmp/$name.jpg" | tr -d '\n')
  fi
  {
    printf '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="%s" height="%s">\n' "$w" "$h"
    printf '<image href="data:image/jpeg;base64,\n'
    printf '%s\n' "$b64" | fold -w 76 | sed '$ s/$/"\/>/'
    printf '</svg>\n'
  } > "assets/img/$name.img.svg"
  echo "Wrote assets/img/$name.img.svg ($(wc -c < "assets/img/$name.img.svg") bytes)"
}

gen hero           https://litter.catbox.moe/wd6xmg.jpg 2048 1082
gen hero-aerial    https://litter.catbox.moe/5fhpg9.jpg 2048 1082
gen pest-control   https://litter.catbox.moe/wqixwx.jpg 1536 962
gen cleanup        https://litter.catbox.moe/p8hqdk.jpg 1536 962
gen fencing        https://litter.catbox.moe/xgrhf9.jpg 1536 962
gen gallery-sod    https://litter.catbox.moe/cyhjrr.jpg 1536 962
gen lawn-care      https://litter.catbox.moe/qlxalf.jpg 1536 962
gen patio-pavers   https://litter.catbox.moe/vjhmih.jpg 1536 962
gen retaining-wall https://litter.catbox.moe/gjcug6.jpg 1536 962
gen sprinklers     https://litter.catbox.moe/kc2wnr.jpg 1536 962

echo "All image wrappers generated."
