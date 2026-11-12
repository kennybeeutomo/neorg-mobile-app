const db = require('../database/db');

async function createWorkspace(req, res) {
	try {
		const { name } = req.body;

		const [result] = await db.query(
			`
				INSERT INTO workspaces
				(name, user_id)
				VALUES (?, ?)
			`,
			[name, req.userId]
		);

		res.status(201).json({ id: result.insertId, name });
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
}

async function getWorkspaces(req, res) {
	try {
		const [rows] = await db.query(
			`
				SELECT id, name
				FROM workspaces
				WHERE user_id = ?
				ORDER BY name
			`,
			[req.userId]
		);

		res.json(rows);
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
};

async function getWorkspace(req, res) {
	try {
		const [rows] = await db.query(
			`
				SELECT id, name
				FROM workspaces
				WHERE id = ? AND user_id = ?
			`,
			[req.params.id, req.userId]
		);

		if (rows.length === 0) {
			return res.status(404).json({ message: 'Workspace not found' });
		}

		res.json(rows[0]);
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
};

async function renameWorkspace(req, res) {
	try {
		const { name } = req.body;

		const [result] = await db.query(
			`
				UPDATE workspaces
				SET name = ?
				WHERE id = ? AND user_id = ?
			`,
			[name, req.params.id, req.userId]
		);

		if (result.affectedRows === 0) {
			return res.status(404).json({ message: 'Workspace not found' });
		}

		res.json({ message: 'Workspace updated' });
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
};

async function deleteWorkspace(req, res) {
	try {
		const [result] = await db.query(
			`
				DELETE FROM workspaces
				WHERE id = ? AND user_id = ?
			`,
			[req.params.id, req.userId]
		);

		if (result.affectedRows === 0) {
			return res.status(404).json({ message: 'Workspace not found' });
		}

		res.json({ message: 'Workspace deleted' });
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
};

module.exports = {
	createWorkspace,
	getWorkspaces,
	getWorkspace,
	renameWorkspace,
	deleteWorkspace
};
