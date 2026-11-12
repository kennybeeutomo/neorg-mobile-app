require('dotenv').config();

if (!process.env.JWT_SECRET) {
	throw new Error('JWT_SECRET missing');
}

const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', require('./routes/auth'));
app.use('/workspaces', require('./routes/workspaces'));
app.use('/', require('./routes/files'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
	console.log(`Server running on port ${PORT}`);
});
