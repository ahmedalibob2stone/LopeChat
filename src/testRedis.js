const redis = require('redis');
(async () => {
  const client = redis.createClient({
    url: process.env.REDIS_URL
  });
  client.on('error', (err) => console.error('Redis Error', err));
  await client.connect();
  console.log('✅ Redis connected');
  await client.setEx('test-key', 60, 'hello');
  const value = await client.get('test-key');
  console.log('🔍 Value from Redis:', value);
  await client.quit();
})();
