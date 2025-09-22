const redis = require('redis');

const redisClient = redis.createClient({
  url: process.env.REDIS_URL,
});

redisClient.on('error', (err) => console.error('Redis Error', err));

(async () => {
  try {
    await redisClient.connect();
    console.log("Redis connected ");
  } catch (err) {
    console.error("Failed to connect Redis", err);
  }
})();

module.exports = redisClient;


