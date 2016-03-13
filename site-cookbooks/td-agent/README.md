td-agent Cookbook
=================


Usage
-----
#### td-agent::default

Just include `td-agent` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[td-agent]"
  ],
  "td-agent": {
    "config": [
      { "name": "access_log", "dir": "http-default", "format": "apache2", "time_format": "%d/%b/%Y:%H:%M:%S %z"  }
    ],
    "s3_bucket": "bucket_name_for_logs",
    "s3_region": "ap-northeast-1"
  }
}
```
