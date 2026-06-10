import { Request, Response, NextFunction } from 'express';
import { ApiError } from '../../utils/api-error';
import { errorResponse } from '../../utils/response';
import { logger } from '../../utils/logger';

export const errorHandler = (
  err: any,
  req: Request,
  res: Response,
  _next: NextFunction,
): void => {
  let statusCode = 500;
  let message = 'Internal Server Error';
  let errors: any = undefined;

  if (err instanceof ApiError) {
    statusCode = err.statusCode;
    message = err.message;
    errors = err.errors;
  } else if (err instanceof Error) {
    message = err.message;
  }

  // Log error using custom logger
  logger.error(`${req.method} ${req.originalUrl} - Status: ${statusCode} - Message: ${message}`, err);

  errorResponse(res, message, statusCode, errors, err.stack);
};
