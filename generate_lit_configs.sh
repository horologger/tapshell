#!/bin/bash

# Script to generate lit configuration files from template
# Reads lit_00000.conf and creates two configs with NODE_A and NODE_B variable substitutions

TEMPLATE_FILE="data/lit_00000.conf"
OUTPUT_DIR="data"

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file $TEMPLATE_FILE not found!"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Function to escape special characters for sed
escape_for_sed() {
    # Escape &, |, /, and \
    echo "$1" | sed -e 's/[&|\\/]/\\&/g'
}

# Function to substitute environment variables
substitute_vars() {
    local input_file="$1"
    local output_file="$2"
    local node_prefix="$3"
    
    # Read template and substitute variables
    while IFS= read -r line; do
        substituted_line="$line"
        
        # For each environment variable with the node prefix
        while IFS='=' read -r var value; do
            if [[ $var == ${node_prefix}_* ]]; then
                # Get the suffix after the prefix, e.g., LND_ALIAS
                suffix=${var#${node_prefix}_}
                # Escape value for sed
                escaped_value=$(escape_for_sed "$value")
                # Replace ${SUFFIX} in the line with the value
                substituted_line=$(echo "$substituted_line" | sed "s|\${$suffix}|$escaped_value|g")
            fi
        done < <(env)
        
        echo "$substituted_line" >> "$output_file"
    done < "$input_file"
}

# Generate configuration for NODE_A
echo "Generating configuration for NODE_A..."
NODE_A_OUTPUT="$OUTPUT_DIR/lit_node_a.conf"
> "$NODE_A_OUTPUT"  # Clear/create file
substitute_vars "$TEMPLATE_FILE" "$NODE_A_OUTPUT" "NODE_A"
echo "Created: $NODE_A_OUTPUT"

# Generate configuration for NODE_B
echo "Generating configuration for NODE_B..."
NODE_B_OUTPUT="$OUTPUT_DIR/lit_node_b.conf"
> "$NODE_B_OUTPUT"  # Clear/create file
substitute_vars "$TEMPLATE_FILE" "$NODE_B_OUTPUT" "NODE_B"
echo "Created: $NODE_B_OUTPUT"

echo "Configuration generation complete!"
echo "Files created:"
echo "  - $NODE_A_OUTPUT"
echo "  - $NODE_B_OUTPUT"
echo ""
echo "screen -dmS node_a litd --configfile=/$NODE_A_OUTPUT && screen -x node_a"
echo "screen -dmS node_b litd --configfile=/$NODE_B_OUTPUT && screen -x node_b"
echo ""
echo "Make sure to set NODE_A_* and NODE_B_* environment variables before running this script."
echo "Create Wallet" 
echo "lncli --rpcserver=localhost:"$NODE_A_LND_RPC_LISTEN" --tlscertpath=/data/node_a/lnd/tls.cert create"
echo "Stop LND with Ctrl-C"
echo "Create lndcli Alias"
cho "...create pwd file"
echo "Append/Enable lnd.wallet-unlock-password-file=${LND_WPW} in lit_node_a.conf"
echo "Append/Enable lnd.wallet-unlock-allow-create=true in lit_node_a.conf"
echo "Restart LND with litd"
echo "Unlock Wallet"
echo "lncli unlock"
echo "Get LND Info"
echo "lncli getinfo | grep sync"
echo "Wait for LND to sync"
echo "Create Node A Alias"
echo "alias lncli='lncli --rpcserver=localhost:"$NODE_A_LND_RPC_LISTEN" --tlscertpath=/data/node_a/lnd/tls.cert --macaroonpath=/data/node_a/lnd/data/chain/bitcoin/mainnet/admin.macaroon'"
echo "alias tapcli='tapcli --rpcserver=localhost:"$NODE_A_LITD_HTTPS_LISTEN" --tlscertpath=/data/node_a/lit/tls.cert --macaroonpath=/data/node_a/tapd/admin.macaroon'"
echo "alias litcli='litcli --rpcserver=localhost:"$NODE_A_LITD_HTTPS_LISTEN" --tlscertpath=/data/node_a/lit/tls.cert --macaroonpath=/data/node_a/lit/lit.macaroon'"
echo "Create Node B Alias"
echo "alias lncli='lncli --rpcserver=localhost:"$NODE_B_LND_RPC_LISTEN" --tlscertpath=/data/node_b/lnd/tls.cert --macaroonpath=/data/node_b/lnd/data/chain/bitcoin/mainnet/admin.macaroon'"
echo "alias tapcli='tapcli --rpcserver=localhost:"$NODE_B_LITD_HTTPS_LISTEN" --tlscertpath=/data/node_b/lit/tls.cert --macaroonpath=/data/node_b/tapd/admin.macaroon'"
echo "alias litcli='litcli --rpcserver=localhost:"$NODE_B_LITD_HTTPS_LISTEN" --tlscertpath=/data/node_b/lit/tls.cert --macaroonpath=/data/node_b/lit/lit.macaroon'"
echo "lncli getinfo"
echo "tapcli getinfo"
echo "litcli getinfo"

echo ""