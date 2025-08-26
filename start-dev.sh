#!/bin/bash

echo "🌊 Starting Flood Detection System..."
echo "=================================="

# Function to check if a port is in use
check_port() {
    lsof -i :$1 > /dev/null 2>&1
}

# Check if backend port is available
if check_port 8000; then
    echo "❌ Port 8000 is already in use. Please stop the existing process."
    exit 1
fi

# Check if frontend port is available
if check_port 3000; then
    echo "❌ Port 3000 is already in use. Please stop the existing process."
    exit 1
fi

echo "🚀 Starting Backend Server (Port 8000)..."
cd backend
python3 start.py &
BACKEND_PID=$!
cd ..

echo "⏳ Waiting for backend to start..."
sleep 3

echo "🌐 Starting Frontend Server (Port 3000)..."
npm run dev &
FRONTEND_PID=$!

echo "✅ Both servers are starting..."
echo ""
echo "📱 Frontend: http://localhost:3000"
echo "🔧 Backend API: http://localhost:8000"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""
echo "Press Ctrl+C to stop both servers"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    echo "✅ Servers stopped"
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM

# Wait for both processes
wait 