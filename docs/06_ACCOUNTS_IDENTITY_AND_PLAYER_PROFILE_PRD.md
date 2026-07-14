# Tiny Dictator — Accounts, Identity and Player Profile PRD

**Document status:** Ready for architecture and staged implementation
**System area:** Accounts, authentication, identity, player profile
**Target platforms:** Android, iOS, optional web
**Game engine:** Godot 4.x
**Backend:** FastAPI
**Authentication provider:** Supabase Auth
**Database:** PostgreSQL hosted by Supabase initially
**Primary IDE:** Cursor
**Depends on:** Phase 1 core prototype
**Related future PRDs:** Cloud Save, In-App Purchases, Ads, Analytics, Privacy and Consent

---

# 1. Executive decision

Tiny Dictator must not require registration before playing.

The game will support two player modes:

1. **Local Guest**

   * No remote account is created.
   * Progress is stored only on the device.
   * The player can access all normal gameplay.
   * Progress may be lost if the app is deleted or the device is lost.

2. **Cloud Account**

   * The player authenticates with Apple, Google or email one-time code.
   * A permanent server-side player ID is created.
   * Local progress can be attached to the account.
   * Future cloud save, cross-device restore and purchase association become available.

The game must present account creation as:

> Protect your progress

It must not present registration as an obstacle between the player and the game.

---

# 2. Product objectives

The accounts system must:

* Allow immediate play without login.
* Allow a player to protect local progress later.
* Support Sign in with Apple.
* Support Sign in with Google.
* Support email one-time code as a cross-platform fallback.
* Maintain one stable internal player ID.
* Support multiple login identities linked to one player.
* Restore sessions between app launches.
* Work gracefully while offline.
* Support sign-out.
* Support account deletion.
* Provide identity infrastructure for future cloud saves and purchases.
* Keep authentication logic separated from game logic.
* Allow development using mock authentication.
* Avoid exposing Supabase administrative credentials in the app.
* Preserve the option to self-host or migrate infrastructure later.

---

# 3. Non-goals

This PRD does not include:

* Cloud-save merge rules beyond the account-linking handoff.
* Purchase implementation.
* Purchase restoration.
* Advertising.
* Social profiles.
* Friends or follower systems.
* Public usernames.
* Competitive leaderboards.
* Chat.
* Password-based login.
* Phone-number authentication.
* Multi-factor authentication.
* Child or family accounts.
* Account sharing.
* Web-based account dashboard beyond deletion requests.
* Admin moderation tools.
* Runtime LLM integration.

These subjects must not be added opportunistically while implementing accounts.

---

# 4. Architecture decision

## 4.1 Selected architecture

```text
┌─────────────────────────────────┐
│         Godot Game Client       │
│                                 │
│  AccountService                 │
│  SessionStore                   │
│  AuthProviderAdapters           │
│  BackendClient                  │
└──────────────┬──────────────────┘
               │
       Authentication requests
               │
               ▼
┌─────────────────────────────────┐
│         Supabase Auth           │
│                                 │
│  Apple identity                 │
│  Google identity                │
│  Email OTP identity             │
│  Session and refresh tokens     │
└──────────────┬──────────────────┘
               │
          Signed JWT
               │
               ▼
┌─────────────────────────────────┐
│      Tiny Dictator Backend      │
│            FastAPI              │
│                                 │
│  Verify Supabase JWT            │
│  Player profile API             │
│  Account deletion               │
│  Cloud save API — later         │
│  Entitlement API — later        │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│    Supabase-hosted PostgreSQL   │
│                                 │
│  auth.users                     │
│  player_profiles                │
│  player_devices                 │
│  deletion_requests              │
│  future game data               │
└─────────────────────────────────┘
```

## 4.2 Responsibilities

### Supabase Auth owns

* Identity-provider integration.
* Authentication sessions.
* Access tokens.
* Refresh tokens.
* Provider identity linking.
* Email verification.
* Email OTP delivery.
* Apple and Google identity validation.
* Authentication user records.

Supabase Auth issues JWTs and supports identity linking, including linking multiple providers to one user.

### Tiny Dictator backend owns

* Player profile.
* Display name.
* Player status.
* Country and progression metadata.
* Account deletion orchestration.
* Security-sensitive game operations.
* Cloud-save logic.
* Purchase entitlement reconciliation.
* Abuse controls.
* Future administrative tools.

### Godot client owns

* Login interface.
* Local guest identity.
* Authentication-provider interaction.
* Secure session storage.
* Session restoration.
* Player-facing errors.
* Local save.
* Calling authenticated backend endpoints.

---

# 5. Why authentication is managed but game infrastructure is custom

Authentication is a security-sensitive commodity system.

Building it completely in-house would require implementing and maintaining:

* OAuth and OpenID Connect flows.
* Apple token validation.
* Google token validation.
* Nonce generation and verification.
* Refresh token rotation.
* Session revocation.
* Email OTP generation and delivery.
* Brute-force protection.
* Account linking.
* Provider credential rotation.
* Password reset if passwords were supported.
* Security response to provider changes.

These systems are not a source of product differentiation for Tiny Dictator.

The differentiated infrastructure is:

* Player progression.
* Unlocks.
* Purchase entitlements.
* Game economy.
* Cloud save.
* Content access.
* Live events.
* Segmentation.
* Player support.

These systems should remain under the developer’s control through the custom backend.

---

# 6. Player identity model

The system must distinguish between four identifiers.

## 6.1 Installation ID

A random UUID generated on first launch.

Example:

```text
installation_id = "438219d9-839a-429a-af04-e11e45ba17e5"
```

Characteristics:

* Stored locally.
* Unique to one app installation.
* Not treated as a permanent player account.
* Regenerated after complete deletion and reinstall.
* May be sent to the backend only after authentication or where explicitly required by a future anonymous API.
* Must not be used as proof of account ownership.

## 6.2 Local profile ID

A locally generated UUID associated with the local save.

Example:

```text
local_profile_id = "f272c461-5207-4682-9c44-f66103922494"
```

Characteristics:

* Exists before authentication.
* Connects local gameplay progress to the eventual cloud migration.
* Does not grant access to server data.
* Must never be accepted by the backend as an authenticated user ID.

## 6.3 Authentication user ID

The UUID generated by Supabase Auth.

Example:

```text
auth_user_id = "9c08ef3b-2864-4350-a385-fb6ee55b0219"
```

Characteristics:

* Stable server-side user identifier.
* Comes from the verified JWT `sub` claim.
* Used as the primary account identity.
* Must never be accepted from a request-body field.
* Must always be derived by the backend from the authenticated token.

## 6.4 Player profile ID

The UUID of the Tiny Dictator player profile.

For the initial implementation:

```text
player_profile.id = auth_user_id
```

Using the same UUID simplifies joins and ownership.

The architecture should still avoid assuming they are conceptually identical, allowing future support for:

* Multiple game profiles under one identity.
* Family accounts.
* Account migrations.
* Platform-specific profiles.

---

# 7. Account states

The Godot client must expose one explicit account state.

```gdscript
enum AccountState {
    INITIALIZING,
    LOCAL_GUEST,
    AUTHENTICATING,
    AUTHENTICATED,
    REFRESHING_SESSION,
    SESSION_EXPIRED,
    SIGNING_OUT,
    DELETION_PENDING,
    ERROR
}
```

## 7.1 INITIALIZING

The client is:

* Loading locally stored session data.
* Checking token expiry.
* Restoring local profile.
* Determining whether the player is a guest or authenticated.

No authentication buttons should be active during this state.

## 7.2 LOCAL_GUEST

The player:

* Has no server account.
* Can play normally.
* Uses local progress.
* May choose Protect Progress.

## 7.3 AUTHENTICATING

A provider flow is in progress.

The UI must:

* Disable duplicate login actions.
* Show progress.
* Allow cancellation where the provider permits.
* Avoid navigating away from the current login screen.

## 7.4 AUTHENTICATED

The client possesses:

* Valid access token.
* Valid refresh token.
* Supabase user ID.
* Tiny Dictator player profile.

Authenticated backend calls are permitted.

## 7.5 REFRESHING_SESSION

The access token is being renewed.

Ordinary gameplay may continue.

Network operations requiring authentication must either:

* Wait for refresh, or
* Fail with a retryable session error.

Only one refresh operation may run at a time.

## 7.6 SESSION_EXPIRED

The refresh token is invalid, revoked or unavailable.

The player remains able to access local gameplay.

The UI displays:

> Your cloud session expired. Sign in again to sync your progress.

Local progress must not be deleted.

## 7.7 SIGNING_OUT

The client is:

* Revoking or clearing the local session.
* Returning to Local Guest mode.
* Preserving an appropriate local copy of the last synchronized profile.

## 7.8 DELETION_PENDING

The account-deletion request has been accepted.

The user must be signed out.

No further authenticated operations are allowed.

## 7.9 ERROR

A non-recoverable initialization or authentication error occurred.

The game must still offer:

* Continue offline.
* Retry.
* Return to menu.

---

# 8. User-facing authentication strategy

## 8.1 First launch

The first launch must not show a registration screen.

Flow:

```text
Launch game
→ Generate installation ID
→ Create local profile
→ Load local save
→ Start Screen
→ Player begins playing
```

Optional non-blocking copy:

> Playing as guest. Protect your progress from Settings at any time.

Do not show this message more than necessary.

---

## 8.2 Protect Progress entry points

The account flow may be opened from:

* Main-menu Settings.
* End-of-run screen after meaningful progression.
* Unlock collection screen.
* Cloud save prompt.
* New-device restore screen.
* Purchase restoration screen, if later required.

The prompt should not appear:

* During the first game decision.
* Repeatedly after every run.
* Immediately after an ad.
* While the player is offline.
* After the user explicitly dismisses it within the configured cooldown.

Recommended prompt frequency:

```text
Maximum once every 7 days after dismissal
```

---

## 8.3 Protect Progress screen

Required content:

```text
PROTECT YOUR PROGRESS

Save your endings, countries and palace upgrades.
Restore them if you change or lose your device.

[ Continue with Apple ]
[ Continue with Google ]
[ Continue with Email ]

Not now
```

Provider ordering:

### iOS

1. Continue with Apple
2. Continue with Google
3. Continue with Email

### Android

1. Continue with Google
2. Continue with Apple, if Android Apple OAuth support is enabled
3. Continue with Email

### Web

1. Continue with Google
2. Continue with Apple
3. Continue with Email

No provider may be visually disguised.

---

# 9. Authentication providers

## 9.1 Sign in with Apple

Use native Apple authentication on iOS.

Flow:

```text
Player presses Continue with Apple
→ Generate cryptographically secure nonce
→ Hash nonce where required by Apple flow
→ Open native Apple authentication
→ Receive Apple identity token
→ Send identity token and raw nonce to Supabase Auth
→ Supabase validates provider identity
→ Supabase returns access and refresh tokens
→ Client stores session securely
→ Client calls Tiny Dictator /v1/me
→ Backend creates or returns player profile
```

Supabase supports native Sign in with Apple and exchanging an Apple identity token for a Supabase session. Apple may provide the person’s name only during the first authorization, so the client must capture it immediately when available rather than assuming it can be retrieved later.

Tiny Dictator does not need a player’s legal name. If Apple provides a name:

* It may be used as an optional initial display name.
* It must not be required.
* It must not overwrite an existing player-selected display name.

### Apple operational requirements

Store securely outside the repository:

* Apple Team ID.
* Services ID where required.
* Key ID.
* `.p8` private key.
* Generated provider secret.

The Apple provider secret must be rotated according to the configured expiry process. Supabase currently recommends creating an operational reminder for rotation.

---

## 9.2 Sign in with Google

Flow:

```text
Player presses Continue with Google
→ Open native Google authentication
→ Receive Google ID token
→ Exchange provider token with Supabase Auth
→ Receive Supabase access and refresh tokens
→ Store session securely
→ Call Tiny Dictator /v1/me
→ Create or return player profile
```

Supabase supports Google as an OAuth/OpenID provider and can exchange native provider tokens for a Supabase session.

Request only the minimum scopes:

* `openid`
* email
* basic profile

Do not request:

* Contacts.
* Drive.
* Calendar.
* Location.
* Any unrelated Google data.

---

## 9.3 Email one-time code

Email authentication is the universal fallback.

Flow:

```text
Enter email
→ Request one-time code
→ Receive email
→ Enter code
→ Supabase verifies code
→ Supabase returns session
→ Client calls backend /v1/me
```

Supabase supports passwordless email login through magic links or one-time codes.

Use a six-digit one-time code rather than requiring the player to switch back through a magic-link deep-link flow.

Required screens:

1. Enter Email
2. Enter Code
3. Authentication Success
4. Invalid or Expired Code
5. Resend Code

Recommended behavior:

* Normalize email case and whitespace.
* Do not reveal whether an email already has an account.
* Apply resend cooldown.
* Display the destination in partially masked form.
* Allow changing the email.
* Do not implement passwords.

---

# 10. Account linking

A player may have more than one provider identity linked to the same account.

Examples:

* Apple + Google.
* Apple + email.
* Google + email.

Supabase supports identities linked under one user account and can automatically or manually link providers depending on configuration.

## 10.1 Settings interface

```text
ACCOUNT

Signed in as player@example.com

Connected methods:
✓ Apple
✓ Google
○ Email

[ Connect another sign-in method ]
[ Sign out ]
[ Delete account ]
```

## 10.2 Linking rules

* Linking must begin from an already authenticated session.
* A new identity must never silently replace the current account.
* The existing player profile remains authoritative.
* Linking must not create a second game profile.
* If the provider identity is already connected to another player account, linking must stop and show a conflict.
* Account merging must not happen automatically.

Conflict message:

> This sign-in method is already connected to another Tiny Dictator account.

Actions:

* Cancel
* Sign out and use that account
* Contact support

Manual account merging is out of scope for the initial implementation.

---

# 11. Local guest to cloud account transition

When a Local Guest authenticates successfully:

1. Authentication session is created.
2. Backend profile is fetched.
3. The game inspects:

   * Local progress.
   * Remote progress.
4. A migration decision is made.
5. The chosen data is sent through the future Cloud Save service.
6. The local profile is marked as attached to the authenticated account.

## 11.1 Empty remote profile

If the cloud profile has no meaningful progress:

```text
Upload local progress
→ Mark migration complete
→ Continue as authenticated player
```

## 11.2 Existing remote profile

If meaningful remote progress already exists:

```text
Show progress conflict screen
```

Example:

```text
WHICH PROGRESS SHOULD WE USE?

This device:
12 endings
Palace level 4
Last played today

Cloud:
18 endings
Palace level 6
Last played 9 days ago

[ Use This Device ]
[ Use Cloud Progress ]
```

Automatic merging is deferred to the Cloud Save PRD.

Until that PRD is implemented, the system must use explicit user selection.

## 11.3 Migration safety

Before migration:

* Write a backup of the local save.
* Do not delete the local save.
* Record migration status.
* Retry safely after interruption.
* Use an idempotency key for upload.
* Never upload half-constructed progress.

---

# 12. Session model

Supabase Auth provides the client with:

* Access token.
* Refresh token.
* Expiration data.
* Authenticated user information.

The backend accepts only the access token.

## 12.1 Token storage

### Production mobile builds

Tokens must be stored through a secure native storage abstraction:

* iOS Keychain.
* Android Keystore-backed encrypted storage.

### Godot editor

Use a development token store under `user://`.

The editor implementation must be clearly labeled insecure and must never be reused for production mobile builds.

## 12.2 Prohibited storage

Do not store production refresh tokens:

* In plain JSON saves.
* In project resources.
* In Git.
* In analytics properties.
* In logs.
* In crash-report messages.
* In screenshots.
* In query-string parameters.

## 12.3 Startup session restoration

```text
App starts
→ TokenStore loads session
→ No session found:
    AccountState = LOCAL_GUEST
→ Session found:
    Check expiration
    If access token valid:
        Call /v1/me
    If expired but refresh token exists:
        Refresh session
        Call /v1/me
    If refresh fails:
        Clear invalid credentials
        AccountState = SESSION_EXPIRED
```

## 12.4 API 401 behavior

When the backend returns `401`:

1. Attempt one token refresh.
2. Retry the original request once.
3. If retry fails:

   * Clear invalid session.
   * Set `SESSION_EXPIRED`.
   * Preserve local progress.
   * Do not loop indefinitely.

Only one concurrent refresh may occur.

Other authenticated requests must await the same refresh promise/state.

---

# 13. Backend authentication

Every authenticated API call must use:

```http
Authorization: Bearer <supabase_access_token>
```

The FastAPI backend must:

1. Read the token from the Authorization header.
2. Verify signature against Supabase JWT signing keys.
3. Validate issuer.
4. Validate audience where configured.
5. Validate expiration.
6. Read the user ID from `sub`.
7. Create a typed authenticated-user context.
8. Ignore any client-provided user ID for authorization.

Supabase documents JWT verification and publishes signing information suitable for backend verification.

## 13.1 Authenticated user context

Example Python model:

```python
@dataclass(frozen=True)
class AuthenticatedUser:
    user_id: UUID
    session_id: str | None
    email: str | None
    provider: str | None
```

## 13.2 FastAPI dependency

Recommended responsibility:

```python
async def require_authenticated_user(
    authorization: str = Header(...)
) -> AuthenticatedUser:
    ...
```

Protected endpoints use:

```python
current_user: AuthenticatedUser = Depends(require_authenticated_user)
```

## 13.3 Secrets

The following must exist only on the backend or secured deployment environment:

* Supabase secret/service-role key.
* PostgreSQL credentials.
* Apple private key.
* Google client secret.
* Email-provider credentials.
* Account deletion signing secret.

The service-role or administrative key must never be shipped with the Godot application.

---

# 14. Database model

Supabase manages authentication tables under its auth schema.

Tiny Dictator must create separate application tables.

## 14.1 `player_profiles`

```sql
create table public.player_profiles (
    id uuid primary key,
    display_name text null,
    status text not null default 'active',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    last_seen_at timestamptz null,
    onboarding_completed boolean not null default false,
    source_platform text null,
    preferred_language text null,
    country_code text null,
    deletion_requested_at timestamptz null,
    deleted_at timestamptz null,

    constraint player_profiles_status_check
        check (status in (
            'active',
            'suspended',
            'deletion_pending',
            'deleted'
        )),

    constraint player_profiles_display_name_length
        check (
            display_name is null
            or char_length(display_name) between 1 and 40
        )
);
```

`id` must correspond to the verified authentication user ID.

Do not use email as a primary key.

## 14.2 `player_devices`

```sql
create table public.player_devices (
    id uuid primary key default gen_random_uuid(),
    player_id uuid not null references public.player_profiles(id),
    installation_id uuid not null,
    platform text not null,
    app_version text null,
    device_label text null,
    created_at timestamptz not null default now(),
    last_seen_at timestamptz not null default now(),
    revoked_at timestamptz null,

    constraint player_devices_platform_check
        check (platform in ('ios', 'android', 'web', 'desktop')),

    constraint player_devices_unique_installation
        unique (player_id, installation_id)
);
```

Do not store:

* Hardware serial number.
* Advertising ID.
* Precise device fingerprint.
* IMEI.
* MAC address.

## 14.3 `account_deletion_requests`

```sql
create table public.account_deletion_requests (
    id uuid primary key default gen_random_uuid(),
    player_id uuid not null,
    requested_at timestamptz not null default now(),
    source text not null,
    status text not null default 'pending',
    completed_at timestamptz null,
    cancellation_deadline timestamptz null,
    internal_reason text null,

    constraint deletion_source_check
        check (source in ('ios', 'android', 'web', 'support')),

    constraint deletion_status_check
        check (status in (
            'pending',
            'processing',
            'completed',
            'cancelled',
            'failed'
        ))
);
```

## 14.4 `account_audit_events`

Optional but recommended:

```sql
create table public.account_audit_events (
    id bigint generated always as identity primary key,
    player_id uuid null,
    event_type text not null,
    occurred_at timestamptz not null default now(),
    metadata jsonb not null default '{}'::jsonb
);
```

Allowed event examples:

* `profile_created`
* `provider_linked`
* `signed_out_all_sessions`
* `deletion_requested`
* `deletion_completed`

Do not store access or refresh tokens in audit events.

---

# 15. Direct database access policy

The Godot client must not directly write gameplay or player-profile tables through Supabase’s generated Data API.

The app must call the FastAPI backend.

Reasons:

* Game progression needs server-side validation.
* Future currency operations must be authoritative.
* Purchase entitlements must not be client-controlled.
* Account-deletion orchestration spans several systems.
* A modified client must not be able to grant itself unlocks.

Database policies should still be configured defensively. Supabase recommends enabling Row Level Security on data exposed through its Data API.

Recommended Phase 1 database policy:

* Do not grant ordinary authenticated clients direct update access to protected game tables.
* Backend uses a private database connection or server-side administrative credentials.
* RLS remains enabled where tables could be exposed.
* All game writes go through validated backend commands.

---

# 16. API contract

Base path:

```text
/v1
```

All account endpoints use JSON over HTTPS.

## 16.1 `GET /v1/me`

Returns the current player profile.

Authentication: required.

Response:

```json
{
  "player": {
    "id": "9c08ef3b-2864-4350-a385-fb6ee55b0219",
    "display_name": null,
    "status": "active",
    "created_at": "2026-08-01T12:00:00Z",
    "last_seen_at": "2026-08-01T12:00:00Z",
    "onboarding_completed": false,
    "preferred_language": "en"
  },
  "account": {
    "providers": ["apple"],
    "email": "private-relay@example.com"
  },
  "server_time": "2026-08-01T12:00:00Z"
}
```

Behavior:

* If authentication user exists but player profile does not, create it idempotently.
* Update `last_seen_at`.
* Register device metadata if supplied through safe headers or a separate endpoint.
* Never return refresh tokens.

## 16.2 `PATCH /v1/me`

Updates safe profile fields.

Authentication: required.

Request:

```json
{
  "display_name": "Tiny Alex",
  "preferred_language": "en"
}
```

Allowed fields:

* `display_name`
* `preferred_language`

Disallowed fields:

* Player ID
* Status
* Created time
* Purchases
* Currency
* Unlocks
* Provider identities

Validation:

* Trim display name.
* Length 1–40.
* Reject unsupported language codes.
* Apply rate limits.

## 16.3 `POST /v1/me/devices/register`

Authentication: required.

Request:

```json
{
  "installation_id": "438219d9-839a-429a-af04-e11e45ba17e5",
  "platform": "ios",
  "app_version": "1.0.0"
}
```

Response:

```json
{
  "registered": true,
  "device_id": "27960319-0ce2-4479-8412-eb402625c7e8"
}
```

This operation must be idempotent.

## 16.4 `POST /v1/me/sign-out-all`

Authentication: required.

Purpose:

* Revoke active sessions where supported.
* Revoke known player devices.
* Preserve account and cloud data.

Response:

```json
{
  "success": true
}
```

## 16.5 `POST /v1/account/deletion-request`

Authentication: required.

Request:

```json
{
  "confirmation": "DELETE",
  "source": "ios"
}
```

Response:

```json
{
  "status": "pending",
  "requested_at": "2026-08-01T12:00:00Z"
}
```

Behavior:

* Mark account `deletion_pending`.
* Revoke active application sessions.
* Prevent new game writes.
* Queue deletion worker.
* Return no sensitive information.

## 16.6 `GET /v1/account/deletion-status`

Authentication may be required while session remains valid, or use a secure emailed status link.

Response:

```json
{
  "status": "processing",
  "requested_at": "2026-08-01T12:00:00Z",
  "completed_at": null
}
```

## 16.7 Public web deletion endpoint

A small website must provide:

```text
/account/delete
```

It may allow:

* Sign in and request deletion.
* Enter email and receive a secure deletion link.
* Contact support where automated authentication is impossible.

Google Play requires apps with account creation to expose an in-app deletion path and an external web resource for deletion requests. Apple requires account deletion to be initiated from inside apps that support account creation.

---

# 17. Godot architecture

Recommended files:

```text
scripts/
  accounts/
    AccountService.gd
    AccountState.gd
    AuthSession.gd
    PlayerProfile.gd
    AuthError.gd

    providers/
      AuthProviderAdapter.gd
      AppleAuthAdapter.gd
      GoogleAuthAdapter.gd
      EmailOtpAuthAdapter.gd
      MockAuthAdapter.gd

    storage/
      TokenStore.gd
      EditorTokenStore.gd
      MobileSecureTokenStore.gd

    networking/
      AuthApiClient.gd
      BackendApiClient.gd
      AuthorizedRequestQueue.gd

scenes/
  accounts/
    ProtectProgressScreen.tscn
    EmailEntryScreen.tscn
    EmailOtpScreen.tscn
    AccountSettingsScreen.tscn
    ProgressConflictScreen.tscn
    DeleteAccountScreen.tscn
```

---

# 18. AccountService

`AccountService` should be an autoload or a long-lived service owned by the application root.

Recommended public signals:

```gdscript
signal account_state_changed(new_state: int)
signal authenticated(profile: PlayerProfile)
signal signed_out()
signal session_expired()
signal profile_updated(profile: PlayerProfile)
signal authentication_failed(error: AuthError)
signal account_deletion_requested()
```

Recommended public methods:

```gdscript
func initialize() -> void
func get_account_state() -> int
func is_authenticated() -> bool
func get_player_profile() -> PlayerProfile
func get_access_token() -> String
func sign_in_with_apple() -> void
func sign_in_with_google() -> void
func request_email_otp(email: String) -> void
func verify_email_otp(email: String, code: String) -> void
func link_provider(provider: String) -> void
func refresh_session() -> bool
func sign_out() -> void
func sign_out_all_devices() -> void
func update_profile(changes: Dictionary) -> void
func request_account_deletion() -> void
```

The game must not access Supabase directly from unrelated scenes.

Correct:

```gdscript
AccountService.sign_in_with_google()
```

Incorrect:

```gdscript
# Inside SettingsScreen.gd
HTTPRequest.request("https://project.supabase.co/auth/...")
```

---

# 19. AuthSession model

```gdscript
class_name AuthSession
extends RefCounted

var access_token: String
var refresh_token: String
var expires_at_unix: int
var user_id: String
var email: String
var provider: String

func is_access_token_expired(buffer_seconds: int = 60) -> bool:
    return Time.get_unix_time_from_system() >= expires_at_unix - buffer_seconds
```

AuthSession must never be printed as JSON.

A debug summary may print:

```text
Authenticated user: 9c08...
Provider: apple
Expires in: 42 minutes
```

It must not print tokens.

---

# 20. BackendApiClient

Responsibilities:

* Attach Authorization header.
* Attach app version.
* Attach platform.
* Attach installation ID only where appropriate.
* Parse structured backend errors.
* Retry once after successful token refresh.
* Enforce request timeout.
* Avoid duplicate refresh operations.
* Support request cancellation during logout.

Recommended headers:

```http
Authorization: Bearer <access-token>
Content-Type: application/json
X-App-Version: 0.1.0
X-Platform: ios
X-Installation-ID: 438219d9-839a-429a-af04-e11e45ba17e5
```

Do not send:

* Device serial number.
* Advertising ID.
* Exact device name unless needed.
* Hardware fingerprint.

---

# 21. Offline behavior

Authentication must never prevent offline gameplay.

## 21.1 Authenticated player launches offline

Behavior:

* Load last known profile.
* Load local progression.
* Display offline state if necessary.
* Allow normal gameplay.
* Queue future cloud operations.
* Do not attempt repeated network calls every few seconds.

UI:

> Offline. Your progress will sync when you reconnect.

## 21.2 Local guest launches offline

No difference from normal Local Guest play.

## 21.3 Login attempted offline

Display:

> You’re offline. Connect to the internet to protect or restore your progress.

Actions:

* Retry
* Cancel

## 21.4 Session expires while offline

The client may continue local play.

It must not delete the local authenticated profile immediately.

When connectivity returns:

* Attempt refresh.
* If refresh succeeds, resume synchronization.
* If refresh fails, enter `SESSION_EXPIRED`.

---

# 22. Sign-out behavior

When the player selects Sign Out:

1. Explain consequences.
2. Ensure current local progress is saved.
3. Attempt server-side sign-out.
4. Clear local access and refresh tokens.
5. Preserve a safe local save.
6. Change state to Local Guest.
7. Do not delete the account.
8. Do not delete purchases.
9. Return to account settings or main menu.

Confirmation:

```text
SIGN OUT?

Your cloud account will remain safe.
Progress made while signed out may need to be merged when you sign in again.

[ Cancel ]
[ Sign Out ]
```

---

# 23. Account deletion

## 23.1 User experience

Settings path:

```text
Settings
→ Account
→ Delete Account
```

First screen:

```text
DELETE ACCOUNT?

This will permanently delete your Tiny Dictator account,
cloud progress and account-linked data.

Store purchase records may remain with Apple or Google
under their own policies.

This cannot be undone after deletion is completed.

[ Cancel ]
[ Continue ]
```

Second confirmation:

```text
Type DELETE to confirm
```

## 23.2 Deletion workflow

```text
Player confirms
→ Client calls deletion endpoint
→ Backend marks profile deletion_pending
→ Backend creates deletion request
→ Active sessions revoked
→ Player signed out
→ Background worker deletes application data
→ Supabase authentication user deleted
→ Minimal legally required audit record retained where applicable
→ Deletion request marked completed
```

## 23.3 Data to delete

* Player profile.
* Cloud saves.
* Device records.
* Unlock history tied only to the user.
* Support metadata not legally required.
* Provider identity through deletion of auth user.
* Personal analytics identifiers where supported.
* Push-notification tokens.
* Account-linked segmentation.

## 23.4 Data that may require separate handling

* Apple transaction records.
* Google Play transaction records.
* Financial records legally required for accounting.
* Aggregated anonymous analytics that can no longer identify the player.
* Security records that must temporarily be retained to prevent fraud.

Any retained category must be disclosed in the privacy policy.

## 23.5 Deletion failure

If deletion processing fails:

* Set request to `failed`.
* Prevent ordinary account use while status is unresolved.
* Alert internal operations.
* Provide support path.
* Never silently restore the account to active.

---

# 24. Privacy and data minimization

The account system should collect only:

* Supabase user ID.
* Provider identity reference.
* Email where provider supplies it.
* Optional display name.
* Preferred language.
* Platform.
* App version.
* Installation UUID.
* Account timestamps.

Do not collect by default:

* Real name.
* Date of birth.
* Address.
* Phone number.
* Precise location.
* Contacts.
* Photos.
* Social graph.
* Device serial number.
* Advertising identifier for account purposes.

Apple requires developers to accurately disclose data collected by both the app and integrated third parties in App Store privacy information.

---

# 25. Security requirements

## Mandatory

* HTTPS only.
* JWT signature validation.
* Token-expiry validation.
* Token issuer validation.
* No administrative keys in client.
* Secure token storage.
* Minimum OAuth scopes.
* Nonce validation for Apple login.
* Rate limiting.
* Structured server-side logs.
* No tokens in logs.
* Account-deletion authorization.
* Idempotent profile creation.
* Idempotent device registration.
* Request size limits.
* Input validation.
* Database parameterization.
* No client-authoritative player IDs.

## Recommended rate limits

```text
Email OTP request:
5 per email per hour
10 per IP per hour

OTP verification:
10 attempts per session

Profile update:
20 per account per hour

Account deletion request:
3 per account per day

Device registration:
20 per account per day
```

Exact limits may be adjusted after testing.

---

# 26. Error model

Backend error format:

```json
{
  "error": {
    "code": "ACCOUNT_SESSION_EXPIRED",
    "message": "Your session has expired.",
    "retryable": false,
    "request_id": "req_4dcfc9"
  }
}
```

Required account error codes:

```text
AUTH_CANCELLED
AUTH_PROVIDER_UNAVAILABLE
AUTH_PROVIDER_ERROR
AUTH_INVALID_TOKEN
AUTH_SESSION_EXPIRED
AUTH_REFRESH_FAILED
AUTH_EMAIL_INVALID
AUTH_OTP_INVALID
AUTH_OTP_EXPIRED
AUTH_RATE_LIMITED
AUTH_IDENTITY_CONFLICT
ACCOUNT_SUSPENDED
ACCOUNT_DELETION_PENDING
ACCOUNT_PROFILE_NOT_FOUND
ACCOUNT_NETWORK_UNAVAILABLE
ACCOUNT_SERVER_ERROR
ACCOUNT_UNKNOWN_ERROR
```

The client must map internal errors to friendly messages.

Do not display raw provider exceptions to players.

---

# 27. Analytics events

Account events must not contain tokens or full email addresses.

Recommended events:

```text
account_prompt_viewed
account_prompt_dismissed
auth_started
auth_succeeded
auth_failed
auth_cancelled
auth_session_restored
auth_session_expired
provider_link_started
provider_link_succeeded
provider_link_failed
sign_out_completed
account_deletion_screen_viewed
account_deletion_requested
```

Safe properties:

```text
provider
platform
entry_point
error_code
is_existing_account
has_local_progress
```

Unsafe properties:

```text
access_token
refresh_token
full_email
Apple identity token
Google identity token
provider authorization code
```

---

# 28. Implementation phases

## Accounts Milestone A — Interfaces and mock implementation

Implement before native SDK integration.

Deliver:

* AccountState.
* AccountService interface.
* AuthSession.
* PlayerProfile.
* MockAuthAdapter.
* EditorTokenStore.
* Protect Progress placeholder UI.
* Account Settings placeholder UI.
* Local Guest state.
* Mock authenticated state.
* Sign-out behavior.

Acceptance:

* Game operates as guest.
* Mock sign-in changes account state.
* Mock profile appears in Settings.
* Restart restores editor test session.
* Sign-out returns to guest.
* No real Supabase dependency yet.

## Accounts Milestone B — Backend profile API

Deliver:

* FastAPI project/module.
* JWT verification dependency.
* PostgreSQL migrations.
* `GET /v1/me`.
* `PATCH /v1/me`.
* Device registration.
* Account error model.
* Automated backend tests.

Acceptance:

* Valid Supabase token obtains profile.
* Invalid token returns 401.
* Profile creation is idempotent.
* Client-supplied player ID is ignored.
* Profile update validates fields.

## Accounts Milestone C — Email OTP

Deliver:

* Supabase project configuration.
* Auth API client.
* Email entry screen.
* OTP screen.
* Session storage.
* Session refresh.
* Real `/v1/me` connection.

Acceptance:

* User can authenticate using email code.
* App restart restores session.
* Expired token refreshes.
* Invalid OTP displays useful error.
* Offline login fails gracefully.

## Accounts Milestone D — Google authentication

Deliver:

* Google provider configuration.
* GoogleAuthAdapter.
* Android plugin/native integration.
* Supabase token exchange.
* Provider-specific tests.

Acceptance:

* Google login works on real Android device.
* Cancellation does not produce generic error.
* Existing account returns same player profile.
* New account creates one profile only.

## Accounts Milestone E — Apple authentication

Deliver:

* Apple Developer configuration.
* Sign in with Apple capability.
* AppleAuthAdapter.
* Secure nonce flow.
* Supabase token exchange.
* First-login name handling.
* Provider-secret rotation documentation.

Acceptance:

* Apple login works on physical iOS device.
* Cancellation is handled.
* Name is captured only where available.
* Repeated login returns same player.
* Token is not logged.

## Accounts Milestone F — Linking and deletion

Deliver:

* Connected-provider UI.
* Provider linking.
* Identity-conflict handling.
* In-app deletion screens.
* Backend deletion worker.
* Public deletion web page.
* Store-policy documentation.

Acceptance:

* Second provider links to same account.
* Conflicting identity does not merge automatically.
* Account deletion can be initiated in app.
* Account deletion can be requested on web.
* Deleted account cannot continue using authenticated API.

---

# 29. Testing matrix

## Guest mode

* First launch creates local profile.
* No network required.
* Guest can play full game.
* Guest dismissal remains dismissed for configured cooldown.
* Guest save survives ordinary app restart.

## Email OTP

* Valid email receives code.
* Invalid email rejected.
* Incorrect code rejected.
* Expired code rejected.
* Resend cooldown works.
* Successful login creates profile.
* Existing login restores same profile.

## Google

* New user.
* Existing user.
* Cancelled login.
* Provider unavailable.
* Network interruption.
* Identity already attached to another account.

## Apple

* New user.
* Existing user.
* Hidden email.
* Name available on first login.
* Name unavailable on later login.
* Cancelled login.
* Invalid nonce.
* Revoked authorization.

## Sessions

* Valid access token.
* Expired access token with valid refresh.
* Invalid refresh token.
* Concurrent authenticated calls during refresh.
* 401 followed by successful retry.
* Repeated 401 does not loop.
* Offline launch.

## Account linking

* Link new provider.
* Provider already linked.
* Provider belongs to different account.
* Linking cancelled.
* Session expires during linking.

## Account deletion

* Initiate deletion in app.
* Initiate deletion from web.
* Invalid confirmation.
* Duplicate request.
* Processing failure.
* Completed deletion.
* Attempt to log in after completed deletion.

---

# 30. Acceptance criteria

The accounts system is complete when:

* The game remains playable without an account.
* A local guest profile is created safely.
* The account state is explicit and observable.
* Email OTP authentication works.
* Google authentication works on Android.
* Apple authentication works on iOS.
* Sessions survive app restart.
* Expired access tokens refresh safely.
* Invalid sessions fall back without deleting local progress.
* Backend verifies Supabase JWTs.
* Backend never trusts client-provided user IDs.
* Player profile creation is idempotent.
* Multiple providers can link to one account.
* Identity conflicts do not merge automatically.
* Sign-out preserves the remote account.
* In-app account deletion exists.
* Web account-deletion request exists.
* Tokens are never logged.
* Production tokens are stored securely.
* No Supabase administrative secret is present in the Godot build.
* Account APIs have automated tests.
* The Godot editor can operate with mock authentication.
* Core game systems do not directly depend on Supabase APIs.

---

# 31. Cursor implementation rule

Cursor must not implement the entire PRD in one pass.

For each Accounts milestone, Cursor must:

1. Read this PRD.
2. Inspect current project architecture.
3. Implement only the requested milestone.
4. Preserve local guest gameplay.
5. Avoid external plugins unless that milestone explicitly requires one.
6. Keep platform integrations behind adapters.
7. Never place secret keys in source code.
8. List every changed file.
9. Describe required Supabase, Apple or Google console configuration separately.
10. Provide tests.
11. State clearly what could not be executed or verified.

---

# 32. Recommended initial Cursor prompt

```text
Read:

- docs/00_PHASE_1_MASTER_PRD.md
- docs/04_TECHNICAL_ARCHITECTURE_AND_IMPLEMENTATION.md
- docs/06_ACCOUNTS_IDENTITY_AND_PLAYER_PROFILE_PRD.md

Implement only Accounts Milestone A:
Interfaces and mock implementation.

Requirements:

- Add AccountState.
- Add AccountService.
- Add AuthSession and PlayerProfile models.
- Add MockAuthAdapter.
- Add EditorTokenStore.
- Add a Protect Progress placeholder screen.
- Add an Account Settings placeholder screen.
- Support LOCAL_GUEST and mock AUTHENTICATED states.
- Support mock sign-in, session restoration and sign-out.
- Keep all existing game functionality working.
- Do not integrate Supabase yet.
- Do not add Apple or Google plugins.
- Do not implement cloud save.
- Do not implement purchases.
- Do not implement account deletion backend.
- Do not store real credentials.

After implementation:

1. List all created and modified files.
2. Explain any manual Godot scene or Autoload steps.
3. Explain how to test guest, mock login, restart and sign-out.
4. Identify assumptions.
5. Do not claim functionality was executed unless it was actually run.
```
