import { Response } from 'express';

export interface ApiResponse<T = any> {
  status: 'success' | 'error';
  message?: string;
  data?: T;
  statusCode?: number;
  errors?: any;
  stack?: string;
}

export const successResponse = <T>(
  res: Response,
  data: T,
  message?: string,
  statusCode = 200,
): Response<ApiResponse<T>> => {
  return res.status(statusCode).json({
    status: 'success',
    message,
    data,
  });
};

export const errorResponse = (
  res: Response,
  message: string,
  statusCode = 500,
  errors?: any,
  stack?: string,
): Response<ApiResponse> => {
  return res.status(statusCode).json({
    status: 'error',
    statusCode,
    message,
    ...(errors && { errors }),
    ...(process.env.NODE_ENV === 'development' && stack && { stack }),
  });
};
