FROM busybox
CMD ["sh", "-c", "while true; do echo 'HTTP/1.1 200 OK\n\nVersion 1.0.0' | nc -vlp 8080; done"]
EXPOSE 8080 
