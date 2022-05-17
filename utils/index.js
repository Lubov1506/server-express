module.exports.mapUsers = users => {
    return users
      .map(user => {
        const {
          name: { first, last },
          gender,
          email,
          dob: { date }
        } = user;
        return `(
              '${first}', '${last}', '${email}', '${gender}', '${date}', '${(
          Math.random() + 1
        ).toFixed(2)}', false
          )`;
      })
      .join(',');
  };