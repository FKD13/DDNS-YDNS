import net.http
import os
import time
import encoding.base64

__global (
	auth_header http.Header
	domains []string
)

fn init() {
	ydns_user := os.getenv("YDNS_USER")
	ydns_pass := os.getenv("YDNS_PASS")

	value := base64.encode_str("${ydns_user}:${ydns_pass}")
	auth_header = http.new_header(http.HeaderConfig{
		key: http.CommonHeader.authorization,
		value: "Basic ${value}"
	})

	domains = os.getenv('YDNS_DOMAINS').split(";")
}

fn get_ip() !string {
	response := http.get("https://ydns.io/api/v1/ip") or {return err}
	return response.body
}

fn update_dns(ip string, domain string) ! {
	http.fetch(http.FetchConfig{
		url: "https://ydns.io/api/v1/update/", 
		method: http.Method.get, 
		header: auth_header, 
		params: {
			"host": domain,
			"ip": ip
		}
	}) or {return err}
}

fn main() {
	ip := "0.0.0.0"

	for (true) {
		new_ip := get_ip() or {
			eprintln('Network Error, Assuming no update')
			ip
		}

		if new_ip != ip {
			println("Detected an IP change - UPDATING")
			for domain in domains {
				println("${domain} -> ${new_ip}")
				update_dns(new_ip, domain) or {eprintln(err)}
			}
		}

		time.sleep(5 * time.minute)
	}
}