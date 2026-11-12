const db = require('../database/db');

async function workspaceExists(workspaceId, userId) {
	const [rows] = await db.query(
		`
			SELECT id FROM workspaces
			WHERE id = ? AND user_id = ?
		`,
		[workspaceId, userId]
	);

	return rows.length > 0;
}

async function getWorkspaceFiles(req, res) {
	try {
		const workspaceId = req.params.id;

		if (!(await workspaceExists(workspaceId, req.userId))) {
			return res.status(404).json({ message: 'Workspace not found' });
		}

		const [files] = await db.query(
			`
				SELECT filepath, contents, created_at, updated_at
				FROM files
				WHERE workspace_id = ?
				ORDER BY filepath
			`,
			[workspaceId]
		);

		res.json({ files });

	} catch (err) {
		res.status(500).json({ message: err.message });
	}
}

async function putWorkspaceFiles(req, res) {
	const connection = await db.getConnection();

	try {
		const workspaceId = req.params.id;
		const { files } = req.body;

		if (!(await workspaceExists(workspaceId, req.userId))) {
			connection.release();

			return res.status(404).json({ message: 'Workspace not found' });
		}

		await connection.beginTransaction();

		const uploadedPaths = [];

		for (const file of files) {
			uploadedPaths.push(file.filepath);

			await connection.query(
				`
					INSERT INTO files (workspace_id, filepath, contents)
					VALUES (?, ?, ?)
					ON DUPLICATE KEY UPDATE contents = VALUES(contents)
				`,
				[workspaceId, file.filepath, file.contents]
			);
		}

		if (uploadedPaths.length > 0) {
			const placeholders = uploadedPaths.map(() => '?').join(',');

			await connection.query(
				`
					DELETE FROM files
					WHERE workspace_id = ?
					AND filepath NOT IN (${placeholders})
				`,
				[workspaceId, ...uploadedPaths]
			);
		} else {
			await connection.query(
				`
					DELETE FROM files
					WHERE workspace_id = ?
				`,
				[workspaceId]
			);
		}

		await connection.commit();

		res.json({ message: 'Workspace synchronized' });
	} catch (err) {
		await connection.rollback();
		res.status(500).json({ message: err.message });
	} finally {
		connection.release();
	}
}

module.exports = {
	getWorkspaceFiles,
	putWorkspaceFiles
};
