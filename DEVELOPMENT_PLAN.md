# Development Plan - AstroConnect

## Phase A: Firebase Setup (YOU need to do this)

### Task A.1: Create Firebase Project
- [ ] Go to https://console.firebase.google.com
- [ ] Click "Add Project"
- [ ] Name: `astroconnect-app`
- [ ] Disable Analytics (for now)
- [ ] Create Project

### Task A.2: Add Android App
- [ ] Click Android icon
- [ ] Package name: `com.ramansubedi.astro_social_app`
- [ ] Download `google-services.json`
- [ ] Place in: `android/app/google-services.json`

### Task A.3: Enable Services
- [ ] Authentication → Enable "Email/Password"
- [ ] Firestore → Create Database (Test mode)
- [ ] Storage → Enable (Test mode)

### Task A.4: Update Config
- [ ] Get config from Firebase Console
- [ ] Update `lib/main.dart` with your API keys

---

## Phase B: Core Features (I will code this)

### Task B.1: Storage Service
- [ ] Create StorageService.dart
- [ ] Add image upload method
- [ ] Add image delete method
- [ ] PUSH CHANGES

### Task B.2: Profile Image Upload
- [ ] Add image picker to profile
- [ ] Connect to StorageService
- [ ] Update user profile with image URL
- [ ] PUSH CHANGES

### Task B.3: Edit Profile Screen
- [ ] Create full edit profile UI
- [ ] Connect all fields to UserService
- [ ] Add validation
- [ ] PUSH CHANGES

### Task B.4: User Search
- [ ] Create SearchService
- [ ] Build search UI
- [ ] Add filters
- [ ] Show compatibility scores
- [ ] PUSH CHANGES

### Task B.5: Friend System
- [ ] Create Friend models
- [ ] Create FriendService
- [ ] Build Friend Requests UI
- [ ] Build Friends List UI
- [ ] PUSH CHANGES

### Task B.6: Posts & Feed
- [ ] Create Post model
- [ ] Create PostService
- [ ] Build Create Post screen
- [ ] Build Feed screen
- [ ] Add Like/Comment
- [ ] PUSH CHANGES

### Task B.7: Chat System
- [ ] Create Chat models
- [ ] Create ChatService
- [ ] Build Chat List
- [ ] Build Chat Room
- [ ] PUSH CHANGES

---

## Current Status

**Phase A**: Waiting for you to complete Firebase setup
**Phase B**: Ready to start coding once Firebase is configured

## Next Action Required

Please complete **Task A.1 through A.4** (Firebase setup), then I'll continue with Phase B tasks.
