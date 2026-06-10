import { Server as HttpServer } from 'http';
import { Server, Socket } from 'socket.io';
import { logger } from './logger';

let io: Server | null = null;

export const initSocket = (server: HttpServer): Server => {
  io = new Server(server, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
  });

  io.on('connection', (socket: Socket) => {
    logger.info(`Client connected: ${socket.id}`);

    socket.on('disconnect', () => {
      logger.info(`Client disconnected: ${socket.id}`);
    });
  });

  return io;
};

export const getIO = (): Server => {
  if (!io) {
    throw new Error('Socket.IO has not been initialized!');
  }
  return io;
};

export const emitSlotUpdated = (slotId: string, status: string, venueId: string): void => {
  if (io) {
    logger.info(`[Socket] Emitting slot_updated event - Slot: ${slotId}, Status: ${status}`);
    io.emit('slot_updated', { slotId, status, venueId });
  }
};

export const emitBookingCreated = (booking: any): void => {
  if (io) {
    logger.info(`[Socket] Emitting booking_created event - Booking ID: ${booking.id}`);
    io.emit('booking_created', booking);
  }
};

export const emitBookingCancelled = (bookingId: string, slotId: string): void => {
  if (io) {
    logger.info(`[Socket] Emitting booking_cancelled event - Booking ID: ${bookingId}`);
    io.emit('booking_cancelled', { bookingId, slotId });
  }
};
