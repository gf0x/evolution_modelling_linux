# EvolutionLinux

A GA model for student project

---
### To run as swift package

Build:

`swift build --configuration release`

Run:

`.build/release/EvolutionLinux <files_out_folder>`

---

### To run in Docker

Build:

`docker build .`

Run:

`docker run [-it] [-d] -v <path_to_files_out_on_host>:/app/files <docker_image_id>`