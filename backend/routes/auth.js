const express = require('express');

const router = express.Router();

const {
	register,
	login,
	me
} = require('../services/auth_service');

const verifyToken = require('../middlewares/auth_middleware');

router.post('/register', register);
router.post('/login', login);
router.get('/me', verifyToken, me);

module.exports = router;
