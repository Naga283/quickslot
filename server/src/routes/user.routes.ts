import { Router } from 'express';
import { userController } from '../controllers/user.controller';
import { bookingController } from '../controllers/booking.controller';
import { validate } from '../middlewares/validation.middleware';
import { createUserSchema, getUserSchema } from '../validations/user.validation';
import { getUserBookingsSchema } from '../validations/booking.validation';

const router = Router();

/**
 * @openapi
 * /api/users:
 *   post:
 *     summary: Create a new user
 *     tags:
 *       - Users
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *             properties:
 *               name:
 *                 type: string
 *                 example: John Doe
 *               email:
 *                 type: string
 *                 format: email
 *                 example: john.doe@example.com
 *     responses:
 *       201:
 *         description: User created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       format: uuid
 *                     name:
 *                       type: string
 *                     email:
 *                       type: string
 *                       format: email
 */
router.post('/', validate(createUserSchema), userController.createUser);

/**
 * @openapi
 * /api/users/{id}:
 *   get:
 *     summary: Get user details by ID
 *     tags:
 *       - Users
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: The user ID
 *     responses:
 *       200:
 *         description: User details
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 status:
 *                   type: string
 *                   example: success
 *                 data:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: string
 *                       format: uuid
 *                     name:
 *                       type: string
 *                     email:
 *                       type: string
 *       404:
 *         description: User not found
 */
router.get('/:id', validate(getUserSchema), userController.getUserById);

/**
 * @openapi
 * /api/users/{id}/bookings:
 *   get:
 *     summary: Get list of bookings for a specific user
 *     tags:
 *       - Users
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: The user ID
 *     responses:
 *       200:
 *         description: List of bookings for the user
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
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: string
 *                         format: uuid
 *                       userId:
 *                         type: string
 *                         format: uuid
 *                       slotId:
 *                         type: string
 *                         format: uuid
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *                       slot:
 *                         $ref: '#/components/schemas/Slot'
 *       404:
 *         description: User not found
 */
router.get('/:id/bookings', validate(getUserBookingsSchema), bookingController.getBookingsForUser);

export default router;
