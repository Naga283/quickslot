import { Response } from 'express';

export interface ApiResponse<T = any> {
  status: 'success' | 'error';
  message?: string;
  data?: T;
  meta?: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
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

export const paginatedResponse = <T>(
  res: Response,
  data: T[],
  page: number,
  limit: number,
  total: number,
  message?: string,
  statusCode = 200,
): Response<ApiResponse<T[]>> => {
  const totalPages = Math.ceil(total / limit);
  return res.status(statusCode).json({
    status: 'success',
    message,
    data,
    meta: {
      page,
      limit,
      total,
      totalPages,
    },
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
