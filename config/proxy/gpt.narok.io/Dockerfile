# Use the official Nginx base image
FROM nginx:latest

# Copy the custom Nginx configuration into the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]