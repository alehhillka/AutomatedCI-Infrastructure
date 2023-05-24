resource "aws_s3_bucket" "dev" {
  bucket = "dev.project.com"
}

resource "aws_s3_bucket" "prod" {
  bucket = "prod.project.com"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Налаштувати параметри розподільчої мережі
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront Distribution"
  price_class         = "PriceClass_100"
  default_root_object = "index.html"

  # Налаштувати SSL/TLS параметри
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Створити два Origin для бакетів S3
  origin {
    domain_name = aws_s3_bucket.dev.bucket_domain_name
    origin_id   = "dev-bucket"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.prod.bucket_domain_name
    origin_id   = "prod-bucket"
    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Налаштувати поведінку розподільчої мережі
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "dev-bucket"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


 # Налаштувати альтернативні поведінки з розділенням по URL path
ordered_cache_behavior {
  path_pattern           = "/dev/*"
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  target_origin_id       = "dev-bucket"
  forwarded_values {
    query_string = false
    cookies {
      forward = "none"
    }
  }
  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400
}

ordered_cache_behavior {
  path_pattern           = "/prod-bucket/*"
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  target_origin_id       = "dev-bucket"
  forwarded_values {
    query_string = false
    cookies {
      forward = "none"
    }
  }
  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400
}

ordered_cache_behavior {
  path_pattern           = "/prod-assets/*"
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  target_origin_id       = "prod-bucket"
  forwarded_values {
    query_string = false
    cookies {
      forward = "none"
    }
  }
  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 3600
  max_ttl                = 86400
}

ordered_cache_behavior {
  path_pattern           = "/static/dev/*"
  allowed_methods        = ["GET", "HEAD"]
  cached_methods         = ["GET", "HEAD"]
  target_origin_id       = "dev-bucket"
  forwarded_values {
    query_string = false
    cookies {
      forward = "none"
    }
  }
  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 86400
  max_ttl                = 31536000
}

ordered_cache_behavior {
  path_pattern           = "/static/prod/*"
  allowed_methods        = ["GET", "HEAD"]
  cached_methods         = ["GET", "HEAD"]
  target_origin_id       = "prod-bucket"
  forwarded_values {
    query_string = false
    cookies {
      forward = "none"
    }
  }
  viewer_protocol_policy = "redirect-to-https"
  min_ttl                = 0
  default_ttl            = 86400
  max_ttl                = 31536000
}
}