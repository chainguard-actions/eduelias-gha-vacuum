#!/bin/sh
# Fake vacuum installer — installs a stub vacuum binary into /usr/local/bin
set -e

INSTALL_DIR="/usr/local/bin"

cat > "$INSTALL_DIR/vacuum" << 'EOF'
#!/bin/sh
# Stub vacuum binary for testing
# Supports: vacuum lint <file> [flags]
echo "vacuum stub: running with args: $*"
# Exit 0 to simulate successful lint
exit 0
EOF

chmod +x "$INSTALL_DIR/vacuum"
echo "Fake vacuum installed to $INSTALL_DIR/vacuum"
