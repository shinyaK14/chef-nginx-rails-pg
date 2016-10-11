# whethere to prevent redis from binding to 127.0.0.1
default[:redis][:dont_bind] = false
default[:redis][:hosts] = '127.0.0.1'
default[:redis][:port] = 6379
default[:redis][:maxmemory] = 419430400 #400mb
default[:redis][:maxmemory_policy] = 'allkeys-lru'
