# ================================================
# ENVIRONMENT CONFIGURATION FILES
# ================================================
# Copy the appropriate file to .env for your environment

# ================================================
# FILE: .env.dev
# Description: Development Environment Configuration
# ================================================
# Flask Configuration
FLASK_ENV=development
FLASK_DEBUG=True
FLASK_LOG_LEVEL=DEBUG

# Application Settings
APP_NAME=House Price Prediction
ENVIRONMENT=dev
DEBUG_MODE=True
LOG_LEVEL=DEBUG

# Server Configuration
HOST=0.0.0.0
PORT=5001
SECRET_KEY=dev-secret-key-change-in-production

# Database Configuration
DATABASE_URL=postgresql://housepriceuser:housepricepwd@localhost:5432/houseprice_db
DB_ECHO=True  # Log all SQL queries

# Redis Cache Configuration
REDIS_URL=redis://localhost:6379/0
CACHE_TIMEOUT=300
SESSION_TIMEOUT=3600

# API Configuration
API_TIMEOUT=30
MAX_CONNECTIONS=10
RATE_LIMIT=100/hour

# Security Configuration
ENABLE_HTTPS=False
REQUIRE_AUTH=False
CORS_ORIGINS=*

# Monitoring & Logging
ENABLE_METRICS=True
ENABLE_PROFILING=True
SENTRY_DSN=

# Third-party Services
SONARQUBE_URL=http://localhost:9000
SONARQUBE_PROJECT_KEY=housepriceprediction

# Development Tools
ENABLE_SWAGGER=True
ENABLE_DEBUG_TOOLBAR=True
ENABLE_SQL_LOGGING=True


# ================================================
# FILE: .env.qa
# Description: Quality Assurance Environment Configuration
# ================================================
# Flask Configuration
FLASK_ENV=testing
FLASK_DEBUG=False
FLASK_LOG_LEVEL=INFO

# Application Settings
APP_NAME=House Price Prediction
ENVIRONMENT=qa
DEBUG_MODE=False
LOG_LEVEL=INFO

# Server Configuration
HOST=0.0.0.0
PORT=5002
SECRET_KEY=qa-secret-key-secure-random-string

# Database Configuration
DATABASE_URL=postgresql://housepriceuser:housepricepwd@qa-db:5432/houseprice_db_qa
DB_ECHO=False

# Redis Cache Configuration
REDIS_URL=redis://redis:6379/1
CACHE_TIMEOUT=600
SESSION_TIMEOUT=7200

# API Configuration
API_TIMEOUT=60
MAX_CONNECTIONS=50
RATE_LIMIT=500/hour

# Security Configuration
ENABLE_HTTPS=False
REQUIRE_AUTH=False
CORS_ORIGINS=https://qa.yourdomain.com,http://localhost:5002

# Monitoring & Logging
ENABLE_METRICS=True
ENABLE_PROFILING=True
SENTRY_DSN=https://your-sentry-key@sentry.io/project-id

# Third-party Services
SONARQUBE_URL=http://sonarqube:9000
SONARQUBE_PROJECT_KEY=housepriceprediction

# QA Tools
ENABLE_SWAGGER=True
ENABLE_DEBUG_TOOLBAR=False
ENABLE_SQL_LOGGING=False


# ================================================
# FILE: .env.uat
# Description: User Acceptance Testing Environment Configuration
# ================================================
# Flask Configuration
FLASK_ENV=uat
FLASK_DEBUG=False
FLASK_LOG_LEVEL=INFO

# Application Settings
APP_NAME=House Price Prediction
ENVIRONMENT=uat
DEBUG_MODE=False
LOG_LEVEL=INFO

# Server Configuration
HOST=0.0.0.0
PORT=5003
SECRET_KEY=uat-secret-key-secure-random-string

# Database Configuration
DATABASE_URL=postgresql://housepriceuser:housepricepwd@uat-db:5432/houseprice_db_uat
DB_ECHO=False

# Redis Cache Configuration
REDIS_URL=redis://redis:6379/2
CACHE_TIMEOUT=900
SESSION_TIMEOUT=14400

# API Configuration
API_TIMEOUT=90
MAX_CONNECTIONS=100
RATE_LIMIT=1000/hour

# Security Configuration
ENABLE_HTTPS=True
REQUIRE_AUTH=True
CORS_ORIGINS=https://uat.yourdomain.com
ALLOWED_HOSTS=uat.yourdomain.com,uat-app.internal

# Monitoring & Logging
ENABLE_METRICS=True
ENABLE_PROFILING=False
SENTRY_DSN=https://your-sentry-key@sentry.io/project-id

# Authentication
AUTH_TYPE=jwt
JWT_SECRET=uat-jwt-secret-key
JWT_ALGORITHM=HS256
JWT_EXPIRATION=3600

# Third-party Services
SONARQUBE_URL=http://sonarqube:9000
SONARQUBE_PROJECT_KEY=housepriceprediction

# UAT Specific
ENABLE_SWAGGER=True
ENABLE_DEBUG_TOOLBAR=False
ENABLE_SQL_LOGGING=False


# ================================================
# FILE: .env.production
# Description: Production Environment Configuration
# ================================================
# Flask Configuration
FLASK_ENV=production
FLASK_DEBUG=False
FLASK_LOG_LEVEL=WARNING

# Application Settings
APP_NAME=House Price Prediction
ENVIRONMENT=production
DEBUG_MODE=False
LOG_LEVEL=WARNING

# Server Configuration
HOST=0.0.0.0
PORT=5000
SECRET_KEY=GENERATE-RANDOM-SECRET-KEY-DO-NOT-COMMIT

# Database Configuration
DATABASE_URL=postgresql://prod_user:SECURE_PASSWORD@prod-db-server:5432/houseprice_db_prod
DB_ECHO=False
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=40
DB_POOL_RECYCLE=3600

# Redis Cache Configuration
REDIS_URL=redis://redis-cluster:6379/0
CACHE_TIMEOUT=3600
SESSION_TIMEOUT=86400
REDIS_SSL=True
REDIS_PASSWORD=SECURE_PASSWORD

# API Configuration
API_TIMEOUT=120
MAX_CONNECTIONS=500
RATE_LIMIT=10000/hour

# Security Configuration
ENABLE_HTTPS=True
REQUIRE_AUTH=True
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com,https://api.yourdomain.com
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com,api.yourdomain.com
HTTPS_ONLY=True
HSTS_ENABLED=True
HSTS_MAX_AGE=31536000

# Monitoring & Logging
ENABLE_METRICS=True
ENABLE_PROFILING=False
SENTRY_DSN=https://your-production-sentry-key@sentry.io/project-id
ENABLE_DISTRIBUTED_TRACING=True
ENABLE_PERFORMANCE_MONITORING=True

# Authentication & Authorization
AUTH_TYPE=oauth2
OAUTH2_PROVIDER=Azure
OAUTH2_CLIENT_ID=AZURE_APP_ID
OAUTH2_CLIENT_SECRET=AZURE_APP_SECRET
OAUTH2_SCOPE=api://your-api/access
JWT_SECRET=PRODUCTION_JWT_SECRET_KEY
JWT_ALGORITHM=RS256
JWT_EXPIRATION=3600

# Encryption
ENCRYPTION_ENABLED=True
ENCRYPTION_KEY=PRODUCTION_ENCRYPTION_KEY

# Database Backups
DB_BACKUP_ENABLED=True
DB_BACKUP_SCHEDULE=0 2 * * *  # Daily at 2 AM

# Third-party Services
SONARQUBE_URL=https://sonarqube.yourdomain.com
SONARQUBE_PROJECT_KEY=housepriceprediction

# Production Specific Settings
ENABLE_SWAGGER=False
ENABLE_DEBUG_TOOLBAR=False
ENABLE_SQL_LOGGING=False
ENABLE_REQUEST_LOGGING=True
ENABLE_ERROR_REPORTING=True
ENABLE_PERFORMANCE_ALERTS=True

# Email Configuration
MAIL_SERVER=smtp.yourdomain.com
MAIL_PORT=587
MAIL_USERNAME=noreply@yourdomain.com
MAIL_PASSWORD=SECURE_PASSWORD
MAIL_USE_TLS=True
ADMIN_EMAIL=admin@yourdomain.com

# CDN Configuration
CDN_ENABLED=True
CDN_URL=https://cdn.yourdomain.com

# Feature Flags
FEATURE_NEW_ALGORITHM=True
FEATURE_ADVANCED_ANALYTICS=False
FEATURE_BETA_FEATURES=False

# Performance Settings
WORKER_THREADS=4
REQUEST_QUEUE_SIZE=100
WORKER_TIMEOUT=120

# Alert Configuration
ALERT_EMAIL=devops@yourdomain.com
ALERT_SLACK_WEBHOOK=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEMORY=85
ALERT_THRESHOLD_DISK=90
