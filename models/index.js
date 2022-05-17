const { Client } = require('pg');
const User = require('./User');

const config = require('../configs/db.json');

const client = new Client(config);

User._client = client;
User._tableName = 'users';

module.exports = {
  client,
  User
};