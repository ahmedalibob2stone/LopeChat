const redis = require('redis');

const redisClient = redis.createClient({
  url: process.env.REDIS_URL,
  password: process.env.REDIS_PASSWORD
});

redisClient.on('error', (err) => console.error('Redis Error', err));

(async () => {
  try {
    await redisClient.connect();
    console.log("✅ Redis connected");

    // تجربة التخزين
    await redisClient.setEx('test-key', 60, 'hello');
    const value = await redisClient.get('test-key');
    console.log('Value from Redis:', value); // يجب أن تطبع 'hello'

    await redisClient.quit();
  } catch (err) {
    console.error('Failed to connect Redis', err);
  }
})();
