const express = require('express');

const router = express.Router();

const {
	getWorkspaceFiles,
	putWorkspaceFiles
} = require('../services/file_service');

const verifyToken = require('../middlewares/auth_middleware');

router.get('/workspaces/:id/files', verifyToken, getWorkspaceFiles);
router.put('/workspaces/:id/files', verifyToken, putWorkspaceFiles);

module.exports = router;
