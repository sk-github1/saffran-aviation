output "s3_bucket" {
  value = aws_s3_bucket.raw_reports.id
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "redis_endpoint" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}
