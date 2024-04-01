# Use the official MySQL image as the base image
FROM mysql:latest

# Environment variables to configure MySQL
ENV MYSQL_ROOT_PASSWORD=your_root_password \
    MYSQL_DATABASE=your_database_name \
    MYSQL_USER=your_username \
    MYSQL_PASSWORD=your_password

# Expose port 3306 to the host
EXPOSE 3306