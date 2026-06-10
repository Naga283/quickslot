import { Router } from 'express';
import { venueController } from '../controllers/venue.controller';
import { validate } from '../middlewares/validation.middleware';
import { createVenueSchema, getVenueSchema, listVenuesSchema } from '../validations/venue.validation';

const router = Router();

router.post('/', validate(createVenueSchema), venueController.createVenue);
router.get('/:id', validate(getVenueSchema), venueController.getVenueById);
router.get('/', validate(listVenuesSchema), venueController.getAllVenues);

export default router;
