# Payload Examples

### Metrics

#### app_request_latency_ms
Network request latency in milliseconds
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "redirect_count",
        "description": ""
      },
      {
        "key": "url",
        "description": ""
      },
      {
        "key": "task_interval_duration",
        "description": ""
      },
      {
        "key": "resource_fetch_type",
        "description": ""
      },
      {
        "key": "fetch_start_date",
        "description": ""
      },
      {
        "key": "http_method",
        "description": ""
      },
      {
        "key": "is_reused_connection",
        "description": ""
      },
      {
        "key": "response",
        "description": ""
      },
      {
        "key": "http_status_code",
        "description": ""
      },
      {
        "key": "task_interval",
        "description": ""
      },
      {
        "key": "is_proxy_connection",
        "description": ""
      },
      {
        "key": "request",
        "description": ""
      }
    ],
    "name": "app_request_latency_ms",
    "unit": "ms",
    "description": "Network request latency in milliseconds"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": 1
          },
          {
            "value": "https://google.com/"
          },
          {
            "value": "0.17742300033569336"
          },
          {
            "value": "localCache"
          },
          {
            "value": "2019-06-21T14:26:13Z"
          },
          {
            "value": "GET"
          },
          {
            "value": true
          },
          {
            "value": 0.34606456756591797
          },
          {
            "value": 301
          },
          {
            "value": 177.42300033569336
          },
          {
            "value": false
          },
          {
            "value": 0
          }
        ]
      ]
    }
  ]
}
```

#### app_response_bytes"    
Network response size in bytes
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "http_status_code",
        "description": ""
      },
      {
        "key": "http_request_expected_content_length",
        "description": ""
      },
      {
        "key": "http_request_mime_type",
        "description": ""
      },
      {
        "key": "http_request_headers",
        "description": ""
      },
      {
        "key": "http_method",
        "description": ""
      },
      {
        "key": "url",
        "description": ""
      },
      {
        "key": "http_request_text_encoding_name",
        "description": ""
      }
    ],
    "name": "app_response_bytes",
    "unit": "bytes",
    "description": "Network response size in bytes"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": 301
          },
          {
            "value": "220 bytes"
          },
          {
            "value": "text/html"
          },
          {
            "value": {
              "Server": "gws",
              "Cache-Control": "public, max-age=2592000",
              "Content-Type": "text/html; charset=UTF-8",
              "Expires": "Sun, 21 Jul 2019 14:01:04 GMT",
              "Date": "Fri, 21 Jun 2019 14:01:04 GMT",
              "Content-Length": "220",
              "x-frame-options": "SAMEORIGIN",
              "x-xss-protection": "0",
              "Location": "https://www.google.com/",
              "alt-svc": "quic=\":443\"; ma=2592000; v=\"46,44,43,39\""
            }
          },
          {
            "value": "GET"
          },
          {
            "value": "https://google.com/"
          },
          {
            "value": "utf-8"
          }
        ]
      ]
    }
  ]
}
```

#### app_request_size_bytes
Network response size in bytes
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "http_request_headers",
        "description": ""
      },
      {
        "key": "http_network_service_type",
        "description": ""
      },
      {
        "key": "http_method",
        "description": ""
      },
      {
        "key": "url",
        "description": ""
      },
      {
        "key": "http_is_stream",
        "description": ""
      },
      {
        "key": "http_request_mime_type",
        "description": ""
      },
      {
        "key": "http_request_text_encoding_name",
        "description": ""
      },
      {
        "key": "http_timeout_interval",
        "description": ""
      }
    ],
    "name": "app_request_size_bytes",
    "unit": "bytes",
    "description": "Network response size in bytes"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": {
              "Accept": "*/*",
              "Accept-Language": "en-us",
              "Accept-Encoding": "br, gzip, deflate"
            }
          },
          {
            "value": "default`"
          },
          {
            "value": "GET"
          },
          {
            "value": "https://google.com/"
          },
          {
            "value": false
          },
          {
            "value": "text/html"
          },
          {
            "value": "utf-8"
          },
          {
            "value": 60
          }
        ]
      ]
    }
  ]
}
```

#### app_request_task
HTTP Request Task
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "http_task_count_of_bytes_expected_to_receive",
        "description": ""
      },
      {
        "key": "http_task_count_of_bytes_sent",
        "description": ""
      },
      {
        "key": "http_task_count_of_bytes_expected_to_send",
        "description": ""
      },
      {
        "key": "http_task_count_of_bytes_received",
        "description": ""
      },
      {
        "key": "http_task_progress",
        "description": ""
      },
      {
        "key": "http_task_response",
        "description": ""
      },
      {
        "key": "http_task_error",
        "description": ""
      },
      {
        "key": "http_task_count_of_bytes_client_expects_to_send",
        "description": ""
      },
      {
        "key": "http_task_count_of_bytes_client_expects_to_receive",
        "description": ""
      },
      {
        "key": "http_task_priority",
        "description": ""
      }
    ],
    "name": "HTTP Request Task",
    "unit": "string",
    "description": "HTTP Request Task"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": "0"
          },
          {
            "value": "0"
          },
          {
            "value": "0"
          },
          {
            "value": "0"
          },
          {
            "value": "<NSProgress: 0x6000019208c0> : Parent: 0x0 / Fraction completed: 0.0000 / Completed: 0 of 100  \n  <NSProgress: 0x6000019246e0> : Parent: 0x6000019208c0 / Fraction completed: 0.0000 / Completed: 0 of 100  \n  <NSProgress: 0x600001924640> : Parent: 0x6000019208c0 / Fraction completed: 0.0000 / Completed: 0 of 100  "
          },
          {
            "value": "Unknown"
          },
          {
            "value": "0"
          },
          {
            "value": "-1"
          },
          {
            "value": "-1"
          },
          {
            "value": "0.5"
          }
        ]
      ]
    }
  ]
}
```

#### http_prerequest
Network request size in bytes
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "http_body_size",
        "description": ""
      },
      {
        "key": "http_method",
        "description": ""
      },
      {
        "key": "http_headers",
        "description": ""
      },
      {
        "key": "http_timeout_interval",
        "description": ""
      },
      {
        "key": "url",
        "description": ""
      },
      {
        "key": "http_network_service",
        "description": ""
      },
      {
        "key": "http_is_stream",
        "description": ""
      }
    ],
    "name": "HTTP pre-request details",
    "unit": "bytes",
    "description": "Network request size in bytes"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": 0
          },
          {
            "value": "GET"
          },
          {
            "value": {}
          },
          {
            "value": 60
          },
          {
            "value": "https://google.com"
          },
          {
            "value": "default`"
          },
          {
            "value": false
          }
        ]
      ]
    }
  ]
}
```

#### http_session_configuration
HTTP session configuration details
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "http_session_sends_launch_events",
        "description": ""
      },
      {
        "key": "http_session_urlCache_memory_capacity",
        "description": ""
      },
      {
        "key": "http_session_waits_for_connectivity",
        "description": ""
      },
      {
        "key": "http_session_urlCache_current_disk_usage",
        "description": ""
      },
      {
        "key": "http_session_request_cache_policy",
        "description": ""
      },
      {
        "key": "http_session_isDiscretionary",
        "description": ""
      },
      {
        "key": "http_session_timeout_interval_for_request",
        "description": ""
      },
      {
        "key": "http_session_timeout_interval_for_resource",
        "description": ""
      },
      {
        "key": "http_session_urlCache_disk_capacity",
        "description": ""
      },
      {
        "key": "http_session_identifier",
        "description": ""
      },
      {
        "key": "http_session_urlCache_current_memory_usage",
        "description": ""
      },
      {
        "key": "http_session_maximum_connections_per_host",
        "description": ""
      },
      {
        "key": "http_session_should_set_cookies",
        "description": ""
      },
      {
        "key": "http_session_should_use_pipelining",
        "description": ""
      }
    ],
    "name": "http_session_configuration",
    "unit": "string",
    "description": "HTTP session configuration details"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": false
          },
          {
            "value": 512000
          },
          {
            "value": false
          },
          {
            "value": 367854
          },
          {
            "value": "useProtocolCachePolicy"
          },
          {
            "value": false
          },
          {
            "value": 60
          },
          {
            "value": 604800
          },
          {
            "value": 10000000
          },
          {
            "value": "Unknown"
          },
          {
            "value": 0
          },
          {
            "value": 4
          },
          {
            "value": true
          },
          {
            "value": false
          }
        ]
      ]
    }
  ]
}
```

#### Hardware
Device hardware details
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "cpu_physical_cores",
        "description": ""
      },
      {
        "key": "cpu_logical_cores",
        "description": ""
      },
      {
        "key": "cpu_system_usage",
        "description": ""
      },
      {
        "key": "memory_system_usage",
        "description": ""
      },
      {
        "key": "memory_application_usage",
        "description": ""
      },
      {
        "key": "br_device_network",
        "description": ""
      }
    ],
    "name": "Hardware",
    "unit": "string",
    "description": "Device hardware details"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": "4"
          },
          {
            "value": "8"
          },
          {
            "value": "(system: 3.8114998843521484, user: 6.674854919788896, idle: 89.51364519585896, nice: 0.0)"
          },
          {
            "value": "(free: 166842368.0, active: 5877846016.0, inactive: 5761892352.0, wired: 4368797696.0, compressed: 1002663936.0, total: 17179869184.0)"
          },
          {
            "value": "57.199999999999996"
          },
          {
            "value": "wifi"
          }
        ]
      ]
    }
  ]
}
```

#### Device
Device details
```json
{
  "metric_descriptor": {
    "type": 0,
    "label_keys": [
      {
        "key": "application_is_protected_data_available",
        "description": ""
      },
      {
        "key": "process_system_uptime",
        "description": ""
      },
      {
        "key": "application_alternate_icon_name",
        "description": ""
      },
      {
        "key": "date_timezone",
        "description": ""
      },
      {
        "key": "application_badge_number",
        "description": ""
      },
      {
        "key": "locale_preferred_languages",
        "description": ""
      },
      {
        "key": "br_os_version",
        "description": ""
      },
      {
        "key": "br_app_version",
        "description": ""
      },
      {
        "key": "process_globally_unique",
        "description": ""
      },
      {
        "key": "br_device_country",
        "description": ""
      },
      {
        "key": "process_thermal_state",
        "description": ""
      },
      {
        "key": "br_device_id_type",
        "description": ""
      },
      {
        "key": "process_name",
        "description": ""
      },
      {
        "key": "date_timezone_identifier",
        "description": ""
      },
      {
        "key": "screen_is_captured",
        "description": ""
      },
      {
        "key": "disk_used_disk_space",
        "description": ""
      },
      {
        "key": "locale_region_code",
        "description": ""
      },
      {
        "key": "br_app_build",
        "description": ""
      },
      {
        "key": "device_name",
        "description": ""
      },
      {
        "key": "screen_preferred_content_size_category",
        "description": ""
      },
      {
        "key": "screen_native_bounds",
        "description": ""
      },
      {
        "key": "disk_total_disk_space",
        "description": ""
      },
      {
        "key": "locale_identifier",
        "description": ""
      },
      {
        "key": "screen_scale",
        "description": ""
      },
      {
        "key": "disk_free_disk_space",
        "description": ""
      },
      {
        "key": "process_is_low_power_mode",
        "description": ""
      },
      {
        "key": "br_device_id",
        "description": ""
      },
      {
        "key": "screen_bounds",
        "description": ""
      },
      {
        "key": "device_system_name",
        "description": ""
      },
      {
        "key": "br_app_id",
        "description": ""
      },
      {
        "key": "br_app_power_state",
        "description": ""
      },
      {
        "key": "calendar_identifier",
        "description": ""
      },
      {
        "key": "br_app_name",
        "description": ""
      },
      {
        "key": "device_orientation",
        "description": ""
      },
      {
        "key": "locale_language_code",
        "description": ""
      },
      {
        "key": "process_host_name",
        "description": ""
      },
      {
        "key": "application_is_registered_for_remote_notifications",
        "description": ""
      },
      {
        "key": "screen_native_scale",
        "description": ""
      },
      {
        "key": "device_localized_model",
        "description": ""
      },
      {
        "key": "screen_brightness",
        "description": ""
      },
      {
        "key": "application_background_refresh_status",
        "description": ""
      },
      {
        "key": "application_background_time_remaining",
        "description": ""
      },
      {
        "key": "process_identifier",
        "description": ""
      },
      {
        "key": "br_device_carrier",
        "description": ""
      },
      {
        "key": "screen_maximum_FPS",
        "description": ""
      },
      {
        "key": "device_user_interface_idiom",
        "description": ""
      },
      {
        "key": "device_battery_level",
        "description": ""
      },
      {
        "key": "screen_user_interface_style",
        "description": ""
      },
      {
        "key": "device_model",
        "description": ""
      },
      {
        "key": "date_date",
        "description": ""
      },
      {
        "key": "screen_wants_software_dimming",
        "description": ""
      },
      {
        "key": "application_state",
        "description": ""
      }
    ],
    "name": "Device",
    "unit": "string",
    "description": "Device details"
  },
  "timeseries": [
    {
      "label_values": [
        [
          {
            "value": "false"
          },
          {
            "value": "582948.0391069211"
          },
          {
            "value": "none"
          },
          {
            "value": "Greenwich Mean Time"
          },
          {
            "value": "0"
          },
          {
            "value": "en"
          },
          {
            "value": "12.2"
          },
          {
            "value": "1.0.0"
          },
          {
            "value": "664F31E6-E6C2-4937-B01D-03F54037E149-22668-000212302B101813"
          },
          {
            "value": []
          },
          {
            "value": "nominal"
          },
          {
            "value": "system"
          },
          {
            "value": "iOSDemo"
          },
          {
            "value": "Europe/London"
          },
          {
            "value": "false"
          },
          {
            "value": "150.38 GB"
          },
          {
            "value": "US"
          },
          {
            "value": "1"
          },
          {
            "value": "iPhone Xʀ"
          },
          {
            "value": "UICTContentSizeCategoryL"
          },
          {
            "value": "(0.0, 0.0, 828.0, 1792.0)"
          },
          {
            "value": "250.69 GB"
          },
          {
            "value": "en_US"
          },
          {
            "value": "2.0"
          },
          {
            "value": "100.3 GB"
          },
          {
            "value": "false"
          },
          {
            "value": "77E36A9E-314D-4A17-BCF5-F8EF2A800181"
          },
          {
            "value": "(0.0, 0.0, 414.0, 896.0)"
          },
          {
            "value": "iOS"
          },
          {
            "value": "io.bitrise.iOSDemo"
          },
          {
            "value": "unknown"
          },
          {
            "value": "gregorian"
          },
          {
            "value": "iOSDemo"
          },
          {
            "value": "unknown"
          },
          {
            "value": "en"
          },
          {
            "value": "shams.local"
          },
          {
            "value": "false"
          },
          {
            "value": "2.0"
          },
          {
            "value": "iPhone"
          },
          {
            "value": "0.5"
          },
          {
            "value": "restricted"
          },
          {
            "value": "0.0"
          },
          {
            "value": "22668"
          },
          {
            "value": []
          },
          {
            "value": "60"
          },
          {
            "value": "phone"
          },
          {
            "value": "-1.0"
          },
          {
            "value": "unspecified"
          },
          {
            "value": "iPhone"
          },
          {
            "value": "June 21, 2019 at 3:26:13 PM GMT+1"
          },
          {
            "value": "false"
          },
          {
            "value": "active"
          }
        ]
      ]
    }
  ]
}
```
