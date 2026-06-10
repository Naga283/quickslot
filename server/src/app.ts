import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import swaggerUi from 'swagger-ui-express';
import { errorHandler } from './core/middlewares/error.middleware';
import apiRouter from './routes';
import { swaggerSpec } from './config/swagger';

const app: Application = express();

// Standard middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Swagger Documentation route
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// API routes
app.use('/api', apiRouter);

// Health check route
app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({
    status: 'success',
    message: 'QuickSlot server is healthy and running',
    timestamp: new Date().toISOString(),
  });
});

// Root route
app.get('/', (req: Request, res: Response) => {
  res.status(200).json({
    message: 'Welcome to QuickSlot API Server',
    version: '1.0.0',
  });
});

// Global error handler (should be registered last)
app.use(errorHandler);

export default app;
