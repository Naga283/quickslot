import dotenv from 'dotenv';
import http from 'http';
import app from './app';
import { initSocket } from './utils/socket';
import { logger } from './utils/logger';

// Load environment variables
dotenv.config();

const PORT = process.env.PORT || 3000;

// Wrap express app in http.Server to attach Socket.io
const server = http.createServer(app);

// Initialize Socket.io server
initSocket(server);

server.listen(PORT, () => {
  logger.info(`🚀 QuickSlot server successfully started at http://localhost:${PORT}`);
  logger.info(`📖 API Documentation available at http://localhost:${PORT}/api-docs`);
});

// Handle graceful shutdown
const gracefulShutdown = () => {
  logger.info('Shutting down server gracefully...');
  server.close(() => {
    logger.info('HTTP & Socket.io server closed.');
    process.exit(0);
  });
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);
