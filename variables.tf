variable "username" {
  description = "Username clients use."
}

variable "password" {
  description = "Password clients use."
}

variable "munki_s3_bucket" {
  description = "The name of your s3 Bucket"
}

variable "prefix" {
  description = "Prefix before lambda and IAM names to ensure uniqueness in your account."
  default     = "munki"
}

variable "price_class" {
  default     = "PriceClass_100"
  description = "The price class your CloudFront Distribution should use."
}

variable "default_cache_behavior_min_ttl" {
  default     = 0
  description = "The minimum amount of time (in seconds) that you want objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated."
}

variable "default_cache_behavior_default_ttl" {
  default     = 86400
  description = "The default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header."
}

variable "default_cache_behavior_max_ttl" {
  default     = 31536000
  description = "The maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated."
}

variable "catalogs_ordered_cache_behavior_min_ttl" {
  default     = 0
  description = "The minimum amount of time (in seconds) that you want catalog objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated."
}

variable "catalogs_ordered_cache_behavior_default_ttl" {
  default     = 30
  description = "The default amount of time (in seconds) that a catalog object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header."
}

variable "catalogs_ordered_cache_behavior_max_ttl" {
  default     = 60
  description = "The maximum amount of time (in seconds) that a catalog object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated."
}

variable "manifests_ordered_cache_behavior_min_ttl" {
  default     = 0
  description = "The minimum amount of time (in seconds) that you want manifest objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated."
}

variable "manifests_ordered_cache_behavior_default_ttl" {
  default     = 30
  description = "The default amount of time (in seconds) that a manifest object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header."
}

variable "manifests_ordered_cache_behavior_max_ttl" {
  default     = 60
  description = "The maximum amount of time (in seconds) that a manifest object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated."
}

variable "icons_ordered_cache_behavior_min_ttl" {
  default     = 0
  description = "The minimum amount of time (in seconds) that you want icon objects to stay in CloudFront caches before CloudFront queries your origin to see whether the object has been updated."
}

variable "icons_ordered_cache_behavior_default_ttl" {
  default     = 30
  description = "The default amount of time (in seconds) that a icon object is in a CloudFront cache before CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header."
}

variable "icons_ordered_cache_behavior_max_ttl" {
  default     = 60
  description = "The maximum amount of time (in seconds) that a icon object is in a CloudFront cache before CloudFront forwards another request to your origin to determine whether the object has been updated."
}
