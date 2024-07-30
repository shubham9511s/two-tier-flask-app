# ------------------- Stage 1: Build Stage ------------------------------
    FROM python:3.9 AS builder

    # Set the working directory to /app
    WORKDIR /app
    
    # Copy the contents of the application into the container at /app
    COPY . .
    
    # Install the necessary MySQL client libraries and other dependencies
    # RUN apt-get update && \
    #     apt-get install -y libmariadb-dev && \
    #     apt-get clean && \
    #     rm -rf /var/lib/apt/lists/*
    
    # Install dependencies specified in requirements.txt
    RUN pip install --no-cache-dir -r requirements.txt
    
    # ------------------- Stage 2: Final Stage ------------------------------
    # Use a slim Python 3.9 image as the final base image
    FROM python:3.9-slim-buster
    
    # Set the working directory to /app
    WORKDIR /app
    
    # Install the necessary MySQL client libraries in the final stage
    RUN apt-get update && \
        apt-get install -y libmariadb3 && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
    
    # Copy the installed Python dependencies from the build stage
    COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
    
    # Copy the application code from the build stage
    COPY --from=builder /app /app
    
    # Expose port 5000 for the Flask application
    EXPOSE 5000
    
    # Define the default command to run the application
    CMD ["python", "app.py"]
    