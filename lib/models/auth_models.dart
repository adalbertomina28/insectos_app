class User {
  final String id;
  final String email;
  final Map<String, dynamic> userMetadata;
  final DateTime? emailConfirmedAt;
  final DateTime? lastSignInAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    this.userMetadata = const {},
    this.emailConfirmedAt,
    this.lastSignInAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      userMetadata: json['user_metadata'] ?? {},
      emailConfirmedAt: json['email_confirmed_at'] != null 
          ? DateTime.parse(json['email_confirmed_at']) 
          : null,
      lastSignInAt: json['last_sign_in_at'] != null 
          ? DateTime.parse(json['last_sign_in_at']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'user_metadata': userMetadata,
      'email_confirmed_at': emailConfirmedAt?.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Session {
  final String accessToken;
  final String refreshToken;
  final User user;
  final int expiresIn;
  final DateTime expiresAt;
  final String tokenType;

  Session({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.expiresIn,
    DateTime? expiresAt,
    this.tokenType = 'bearer',
  }) : expiresAt = expiresAt ?? DateTime.now().add(Duration(seconds: expiresIn));

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: User.fromJson(json['user']),
      expiresIn: json['expires_in'] ?? 3600,
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at']) 
          : null,
      tokenType: json['token_type'] ?? 'bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'expires_in': expiresIn,
      'expires_at': expiresAt.toIso8601String(),
      'token_type': tokenType,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  bool get needsRefresh {
    // Refrescar si queda menos del 10% del tiempo de expiración
    final timeToExpire = expiresAt.difference(DateTime.now());
    final refreshThreshold = Duration(seconds: expiresIn ~/ 10);
    return timeToExpire < refreshThreshold;
  }
}

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final Session? session;
  final String? error;

  AuthState({
    this.isAuthenticated = false,
    this.user,
    this.session,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    Session? session,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      session: session ?? this.session,
      error: error ?? this.error,
    );
  }

  factory AuthState.initial() {
    return AuthState(
      isAuthenticated: false,
      user: null,
      session: null,
      error: null,
    );
  }

  factory AuthState.authenticated(User user, Session session) {
    return AuthState(
      isAuthenticated: true,
      user: user,
      session: session,
      error: null,
    );
  }

  factory AuthState.error(String error) {
    return AuthState(
      isAuthenticated: false,
      user: null,
      session: null,
      error: error,
    );
  }
}
