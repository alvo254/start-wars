# Use the official KIND node image as the base.
FROM kindest/node:v1.32.2

# Copy the actual Kata shim binary into the image.
# Ensure the file "containerd-shim-kata-v2" (extracted from the snap) is in this directory.
COPY containerd-shim-kata-v2 /usr/bin/containerd-shim-kata-v2

# Set executable permissions for the shim binary.
RUN chmod +x /usr/bin/containerd-shim-kata-v2

# (Optional) If you have a Kata configuration file, copy it into the image.
COPY configuration.toml /etc/kata/configuration.toml
