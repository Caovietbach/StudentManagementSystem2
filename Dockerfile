# Use an official MySQL image as the base image
FROM mysql:latest

# Set the root password for MySQL
ENV MYSQL_ROOT_PASSWORD=root

# Create a database
ENV MYSQL_DATABASE=mydatabase

# Expose the MySQL port
EXPOSE 3306