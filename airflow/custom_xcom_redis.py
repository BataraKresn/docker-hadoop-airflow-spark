from airflow.models.xcom import BaseXCom  # type: ignore
from redis import Redis

class RedisXCom(BaseXCom):
    @classmethod
    def set(cls, key, value):
        # Membuat koneksi Redis
        r = Redis(host='redis', port=6379)  # Sesuaikan dengan pengaturan Redis Anda
        # Menyimpan data dalam Redis
        r.set(key, value)

    @classmethod
    def get(cls, key):
        # Membuat koneksi Redis
        r = Redis(host='redis', port=6379)  # Sesuaikan dengan pengaturan Redis Anda
        # Mengambil data dari Redis
        return r.get(key)
