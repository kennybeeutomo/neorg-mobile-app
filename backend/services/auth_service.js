const db = require('../database/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

async function register(req, res) {
	try {
		const {
			name,
			email,
			password
		} = req.body;

		const hashedPassword = await bcrypt.hash(password, 10);

		await db.query(
			`
				INSERT INTO users
				(name, email, password) VALUES
				(?, ?, ?)
			`,
			[name, email, hashedPassword]
		);

		res.json({ message: 'Register success' });

	} catch (err) {
		res.status(500).json({ message: err.message });
	}
};

async function login(req, res) {
	try {
		const { email, password } = req.body;

		const [rows] = await db.query(
			`SELECT * FROM users WHERE email = ?`,
			[email]
		);

		if (rows.length === 0) {
			return res.status(401).json({ message: 'Invalid credentials' });
		}

		const user = rows[0];

		const isMatch = await bcrypt.compare(password, user.password);

		if (!isMatch) {
			return res.status(401).json({ message: 'Invalid credentials' });
		}

		const token = jwt.sign(
			{ id: user.id },
			process.env.JWT_SECRET,
			{ expiresIn: '7d' }
		);

		res.json({ token });
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
};

async function me(req, res) {
	try {
		const [rows] = await db.query(
			`
				SELECT id, name, email
				FROM users
				WHERE id = ?
			`,
			[req.userId]
		);

		if (rows.length === 0) {
			return res.status(404).json({ message: 'User not found' });
		}

		res.status(200).json(rows[0]);
	} catch (err) {
		res.status(500).json({ message: err.message });
	}
}

module.exports = {
	register,
	login,
	me
};
