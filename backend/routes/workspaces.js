const express = require('express');

const router = express.Router();

const {
	createWorkspace,
	getWorkspaces,
	getWorkspace,
	renameWorkspace,
	deleteWorkspace
} = require('../services/workspace_service');

const verifyToken = require('../middlewares/auth_middleware');

router.post('/', verifyToken, createWorkspace);
router.get('/', verifyToken, getWorkspaces);
router.get('/:id', verifyToken, getWorkspace);
router.put('/:id', verifyToken, renameWorkspace);
router.delete('/:id', verifyToken, deleteWorkspace);

module.exports = router;
