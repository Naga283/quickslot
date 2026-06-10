import swaggerJSDoc from 'swagger-jsdoc';

const options: swaggerJSDoc.Options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'QuickSlot API Server',
      version: '1.0.0',
      description: 'API documentation for the QuickSlot booking slot application',
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server',
      },
    ],
    components: {
      schemas: {
        Venue: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            name: { type: 'string' },
            sportType: { type: 'string' },
            address: { type: 'string' },
            imageUrl: { type: 'string', nullable: true },
          },
        },
        Slot: {
          type: 'object',
          properties: {
            id: { type: 'string', format: 'uuid' },
            venueId: { type: 'string', format: 'uuid' },
            date: { type: 'string', format: 'date' },
            startTime: { type: 'string', format: 'date-time' },
            endTime: { type: 'string', format: 'date-time' },
            status: { type: 'string', enum: ['AVAILABLE', 'BOOKED'] },
          },
        },
      },
    },
  },
  // Scans all routes and subfolders for JSDoc documentation
  apis: ['./src/routes/*.ts', './dist/routes/*.js'],
};

export const swaggerSpec = swaggerJSDoc(options);
