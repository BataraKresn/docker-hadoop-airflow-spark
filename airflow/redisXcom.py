from airflow.models.xcom import BaseXCom # type: ignore
import redis
import json

class RedisXCom(BaseXCom):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.redis = redis.Redis(host='redis', port=6379, db=0)

    def set(self, key, value, **kwargs):
        # Store XCom data in Redis with a specific key
        self.redis.set(key, json.dumps(value))

    def get(self, key, **kwargs):
        # Retrieve XCom data from Redis using the key
        value = self.redis.get(key)
        if value:
            return json.loads(value)
        return None

    def delete(self, key, **kwargs):
        # Delete XCom data from Redis using the key
        self.redis.delete(key)
