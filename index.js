const { User, client } = require('./models');
const { loadUsers } = require('./api/');

start();

async function start () {
  await client.connect();
  const users = await loadUsers();
  const res = await User.bulkCreate(users);
  console.log(res);
  await client.end();
}