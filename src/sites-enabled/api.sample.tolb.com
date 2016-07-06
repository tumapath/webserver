#||||||||||||||||||||||
# Server for API V2 
#||||||||||||||||||||||  
server {
	listen 8000;

	location /hello-world {
		proxy_pass $scheme://api_lb
		add_header 'Access-Control-Allow-Origin' "$http_origin" always;
		add_header 'Access-Control-Allow-Headers' "Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,Keep-Alive,X-Requested-With,If-Modified-Since" always;
		add_header 'Access-Control-Allow-Credentials' "true" always;
		add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS, DELETE, PUT, PATCH' always;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_read_timeout				240;
		proxy_connect_timeout			240;
		proxy_buffer_size				64k; 
		proxy_buffers					4 64k;
		proxy_busy_buffers_size			64k;
		proxy_temp_file_write_size		64k;
		client_max_body_size			100M;
	}

	location /api_status {
		stub_status on;
		access_log off;
	}
}