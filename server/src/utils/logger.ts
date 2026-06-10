enum LogLevel {
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR',
  DEBUG = 'DEBUG',
}

const colors = {
  reset: '\x1b[0m',
  info: '\x1b[36m', // Cyan
  warn: '\x1b[33m', // Yellow
  error: '\x1b[31m', // Red
  debug: '\x1b[35m', // Magenta
  gray: '\x1b[90m',
};

class Logger {
  private formatMessage(level: LogLevel, message: string): string {
    const timestamp = new Date().toISOString();
    let color = colors.info;

    switch (level) {
      case LogLevel.INFO:
        color = colors.info;
        break;
      case LogLevel.WARN:
        color = colors.warn;
        break;
      case LogLevel.ERROR:
        color = colors.error;
        break;
      case LogLevel.DEBUG:
        color = colors.debug;
        break;
    }

    return `${colors.gray}[${timestamp}]${colors.reset} ${color}[${level}]${colors.reset} ${message}`;
  }

  public info(message: string, ...args: any[]): void {
    console.log(this.formatMessage(LogLevel.INFO, message), ...args);
  }

  public warn(message: string, ...args: any[]): void {
    console.warn(this.formatMessage(LogLevel.WARN, message), ...args);
  }

  public error(message: string, error?: any, ...args: any[]): void {
    const errorMsg = error instanceof Error ? `${error.message}\n${error.stack}` : error;
    console.error(
      this.formatMessage(LogLevel.ERROR, message),
      errorMsg ? `\nError details: ${errorMsg}` : '',
      ...args
    );
  }

  public debug(message: string, ...args: any[]): void {
    if (process.env.NODE_ENV !== 'production') {
      console.log(this.formatMessage(LogLevel.DEBUG, message), ...args);
    }
  }
}

export const logger = new Logger();
