import { Router } from 'express';
import { slotController } from '../controllers/slot.controller';
import { validate } from '../middlewares/validation.middleware';
import { listSlotsSchema, generateSlotsSchema } from '../validations/slot.validation';

const router = Router();

router.get('/', validate(listSlotsSchema), slotController.getSlots);
router.post('/generate', validate(generateSlotsSchema), slotController.generateSlots);

export default router;
