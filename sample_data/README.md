# Sample curl to push telemetry
curl -X POST https://<INGRESS_URL>/report \\
  -H 'Content-Type: application/json' \\
  -d @sample_data/turbine_sample.json
