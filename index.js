const { Client } = require('pg')
const { loadUsers } = require('./api/')

const config = {
  user: 'postgres',
  password: '718',
  host: 'localhost',
  database: 'testdb',
  port: 5432
}

const client = new Client(config)

start()

async function start () {
  await client.connect()
  const users = await loadUsers()

  const res = await client.query(`
      INSERT INTO "users"(
          "first_name",
          "last_name",
          "email",
          "gender",
          "birthday",
          "height",
          "is_subscribe"
      ) VALUES ${mapUsers(users)};
      `)

  await client.end()
}

function mapUsers (users) {
  return users
    .map(user => {
      const {
        name: { first, last },
        gender,
        email,
        dob: { date }
      } = user
      return `(
            '${first}', '${last}', '${email}', '${gender}', '${date}', '${(
        Math.random() + 1
      ).toFixed(2)}', false
        )`
    })
    .join(',')
}