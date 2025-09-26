from flask import Flask, request, jsonify
import os, json, logging, boto3, redis, uuid, datetime
from botocore.exceptions import ClientError

app = Flask(__name__)

# Config - read from env
S3_BUCKET = os.environ.get("S3_BUCKET", "saffaran-turbine-raw")
REDIS_HOST = os.environ.get("REDIS_HOST", "redis:6379")
REDIS_PASSWORD = os.environ.get("REDIS_PASSWORD", "")
REGION = os.environ.get("AWS_REGION", "us-east-1")

# Setup boto3 S3 client
s3 = boto3.client('s3', region_name=REGION)

# Setup Redis
try:
    r = redis.StrictRedis.from_url(f"redis://{REDIS_PASSWORD}@{REDIS_HOST}" if REDIS_PASSWORD else f"redis://{REDIS_HOST}", socket_timeout=5)
    r.ping()
except Exception as e:
    r = None
    app.logger.warning("Redis not available: %s", e)

# Setup logging (CloudWatch agent or sidecar recommended in prod)
handler = logging.StreamHandler()
handler.setFormatter(logging.Formatter('%(asctime)s %(levelname)s %(message)s'))
app.logger.addHandler(handler)
app.logger.setLevel(logging.INFO)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'timestamp': datetime.datetime.utcnow().isoformat()}), 200

@app.route('/report', methods=['POST'])
def ingest_report():
    try:
        payload = request.get_json(force=True)
        if not payload:
            return jsonify({'error': 'Invalid or empty JSON'}), 400

        # create object key
        object_key = f"reports/{datetime.datetime.utcnow().strftime('%Y/%m/%d')}/{uuid.uuid4()}.json"
        raw_bytes = json.dumps(payload).encode('utf-8')

        # upload to S3
        try:
            s3.put_object(Bucket=S3_BUCKET, Key=object_key, Body=raw_bytes)
        except ClientError as e:
            app.logger.error('S3 upload failed: %s', e)
            return jsonify({'error': 'failed to store report'}), 500

        # cache a summary in Redis for quick lookups
        summary = {
            'object_key': object_key,
            'received_at': datetime.datetime.utcnow().isoformat(),
            'engine_id': payload.get('engine_id')
        }
        try:
            if r:
                r.hset('reports', summary['object_key'], json.dumps(summary))
        except Exception as e:
            app.logger.warning('Failed to write to Redis: %s', e)

        app.logger.info('Ingested report for engine: %s', payload.get('engine_id'))
        return jsonify({'status': 'accepted', 'object_key': object_key}), 202

    except Exception as e:
        app.logger.exception('Unhandled error: %s', e)
        return jsonify({'error': 'internal error'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
