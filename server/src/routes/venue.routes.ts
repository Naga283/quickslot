import { Router } from 'express';
import { venueController } from '../controllers/venue.controller';
import { validate } from '../middlewares/validation.middleware';
import {
  createVenueSchema,
  getVenueSchema,
  listVenuesSchema,
  getVenueSlotsSchema,
} from '../validations/venue.validation';

const router = Router();

/**
 * @openapi
 * /api/venues:
 *   get:
 *     summary: Retrieve a paginated list of venues
 *     tags:
 *       - Venues
 *     parameters:
 *       - in: query
 *         name: sportType
 *         schema:
 *           type: string
 *         description: Filter venues by sport type (e.g. Badminton, Football, Cricket)
 *       - in: query
 *         name: page
 *         schema:
 *           type: string
 *           default: "1"
 *         description: Page number for pagination
 *       - in: query
 *         name: limit
 *         schema:
 *           type: string
 *           default: "10"
 *         description: Number of records per page
 *     responses:
 *       200:
 *         description: A paginated list of venues
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 message:
 *                   type: string
 *                   example: Venues retrieved successfully
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Venue'
 *                 meta:
 *                   type: object
 *                   properties:
 *                     page:
 *                       type: integer
 *                       example: 1
 *                     limit:
 *                       type: integer
 *                       example: 10
 *                     total:
 *                       type: integer
 *                       example: 5
 *                     totalPages:
 *                       type: integer
 *                       example: 1
 */
router.get('/', validate(listVenuesSchema), venueController.getAllVenues);

/**
 * @openapi
 * /api/venues/{id}:
 *   get:
 *     summary: Get venue details by ID
 *     tags:
 *       - Venues
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: The venue ID
 *     responses:
 *       200:
 *         description: Venue details
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 data:
 *                   $ref: '#/components/schemas/Venue'
 *       404:
 *         description: Venue not found
 */
router.get('/:id', validate(getVenueSchema), venueController.getVenueById);

/**
 * @openapi
 * /api/venues/{id}/slots:
 *   get:
 *     summary: Get available or booked slots for a specific venue by date
 *     tags:
 *       - Venues
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: The venue ID
 *       - in: query
 *         name: date
 *         schema:
 *           type: string
 *           format: date
 *           example: "2026-06-11"
 *         description: Filter slots by date (YYYY-MM-DD)
 *     responses:
 *       200:
 *         description: A list of slots for the venue
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Slot'
 *       404:
 *         description: Venue not found
 */
router.get('/:id/slots', validate(getVenueSlotsSchema), venueController.getVenueSlots);

/**
 * @openapi
 * /api/venues:
 *   post:
 *     summary: Create a new venue
 *     tags:
 *       - Venues
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - sportType
 *               - address
 *             properties:
 *               name:
 *                 type: string
 *                 example: Smash Arena
 *               sportType:
 *                 type: string
 *                 example: Badminton
 *               address:
 *                 type: string
 *                 example: 123 Main St
 *               imageUrl:
 *                 type: string
 *                 example: https://example.com/image.jpg
 *     responses:
 *       201:
 *         description: Venue created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 data:
 *                   $ref: '#/components/schemas/Venue'
 */
router.post('/', validate(createVenueSchema), venueController.createVenue);

export default router;
