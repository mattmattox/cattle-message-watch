# cattle-message-watch
This script will watch the Rancher v1.6 server logs for known bad errors.

# Install plan
Run the following command on each Rancher management server. NOTE: Replace matthew.mattox@rancher.com with your email address.
```
docker run -d --restart=unless-stopped -e EmailAddress=matthew.mattox@rancher.com cube8021/cattle-message-watch
```
