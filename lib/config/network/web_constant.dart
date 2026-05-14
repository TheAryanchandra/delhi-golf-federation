const String protocol = "https"; // Set to "http" if needed
const String domain = "admin.delhigolf.org";
const String baseUrl = "$protocol://$domain/api";

/// Default headers
const String headersJson = "application/json";

/// API Key
const String apiKey = "065A0566-4ACA-4C5B-9789-9B4992AC40F3";

/// Account Endpoints
const String registrationEndpoint = "$baseUrl/account/registration";
const String eventRegistrationEndpoint = "$baseUrl/account/event-registration";
const String loginEndpoint = "$baseUrl/account/login";
const String logoutEndpoint = "$baseUrl/account/logout";
const String refreshTokenEndpoint = "$baseUrl/account/refresh-token";
const String eventsEndpoint = "$baseUrl/account/events";
const String eventReportEndpoint = "$baseUrl/account/score-events";
const String getUserEndpoint = "$baseUrl/account/get-user";
const String delhiGolfRankingEndpoint = "$baseUrl/account/delhi-golf-ranking";
const String insertLeaderboardEndpoint = "$baseUrl/account/insert-leaderboard";
const String leaderboardDetailsEndpoint = "$baseUrl/account/leaderboard-details";
const String registrationPaymentEndpoint = "$baseUrl/account/registration-payment";
const String getEventsScoresEndpoint = "$baseUrl/account/get-events-scores";
const String updateProfileEndpoint = "$baseUrl/account/update-profile";
const String viewScoreEndpoint = "$baseUrl/account/view-score";
const String eventDetailsEndpoint = "$baseUrl/account/event-details";
const String viewEventEndpoint = "$baseUrl/account/view-event";

/// Master APIs
const String industryEndpoint = "$baseUrl/master/industry";
const String bannerEndpoint = "$baseUrl/master/get-banner-details";
const String worldOfGolfEndpoint = "$baseUrl/master/world-of-golf";
const String eventNameAutoEndpoint = "$baseUrl/master/get-event-name-auto";
const String golfRankingListEndpoint = "$baseUrl/master/golf-ranking-list";

