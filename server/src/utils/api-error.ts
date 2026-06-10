export class ApiError extends Error {
  public readonly statusCode: number;
  public readonly isOperational: boolean;
  public readonly errors?: any;

  constructor(statusCode: number, message: string, isOperational = true, errors?: any, stack = '') {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    this.errors = errors;
    if (stack) {
      this.stack = stack;
    } else {
      Error.captureStackTrace(this, this.constructor);
    }
  }

  public static badRequest(message: string, errors?: any): ApiError {
    return new ApiError(400, message, true, errors);
  }

  public static unauthorized(message: string): ApiError {
    return new ApiError(401, message);
  }

  public static forbidden(message: string): ApiError {
    return new ApiError(403, message);
  }

  public static notFound(message: string): ApiError {
    return new ApiError(404, message);
  }

  public static conflict(message: string): ApiError {
    return new ApiError(409, message);
  }

  public static internal(message: string): ApiError {
    return new ApiError(500, message);
  }
}
