# Use an official lightweight Python image
FROM python:3.11-slim

# Set the working directory inside container
WORKDIR /app

# Copy project files to the container
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt 

# Copy rest of the application code
COPY . .

# Expose port 5000 to Flask
EXPOSE 5000

# Command to run the app
CMD [ "python", "app.py" ]