# Use a multi-stage build to ensure AMD64 compatibility
# --- Stage 1: Build the app ---
    FROM node:16-alpine AS builder

    WORKDIR /app
    
    # Copy package files first for better layer caching
    COPY package*.json ./
    
    # Install dependencies
    RUN npm install
    
    # Copy the rest of the application
    COPY . .
    
    # --- Stage 2: Run the app ---
    FROM node:16-alpine
    
    WORKDIR /app
    
    # Copy built files from the builder stage
    COPY --from=builder /app .
    
    # Expose the WebSocket port (3000)
    EXPOSE 3000
    
    # Start the server
    CMD ["node", "index.js"]