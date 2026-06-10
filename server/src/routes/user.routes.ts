import { Router } from 'express';
import { userController } from '../controllers/user.controller';
import { validate } from '../middlewares/validation.middleware';
import { createUserSchema, getUserSchema } from '../validations/user.validation';

const router = Router();

router.post('/', validate(createUserSchema), userController.createUser);
router.get('/:id', validate(getUserSchema), userController.getUserById);

export default router;
