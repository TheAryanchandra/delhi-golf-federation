# TODO: Fix DioException 408 in Periodic Token Refresh

## Tasks
- [x] Increase timeouts in RefreshTokenRepository from 10s to 30s
- [x] Add retry logic with exponential backoff to _performTokenRefresh in DioClient
- [ ] Improve error message in DioClient onError interceptor for badResponse cases
- [ ] Test the changes to ensure 408 errors are resolved
