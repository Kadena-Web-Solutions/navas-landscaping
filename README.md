# Navas Landscaping — Client Demo Site

Static one-page demo site, auto-deployed to Cloudflare Pages from the `main` branch.

**Live preview:** https://navas-landscaping-cyz.pages.dev/

## Image wrapper convention
GitHub API-based file uploads cannot handle binary files reliably, so raster images are served as SVG wrappers (`assets/img/<name>.img.svg`) embedding the JPEG as a base64 data URI inside an `<image>` element. The wrappers are generated at Pages build time by `build.sh` (fetches the original JPEGs and base64-encodes them at 76 columns). The HTML/CSS reference the `.img.svg` paths directly. The production source directory keeps the original `.jpg` binaries.

## Deploy
Cloudflare Pages project `navas-landscaping` is connected to this repo (branch `main`, build command `bash build.sh`, output dir = repo root). Every push to `main` triggers a new deployment. The site carries `noindex` (meta + `X-Robots-Tag` header) since it is a client preview.
