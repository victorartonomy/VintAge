# Rating Feature Implementation

## Overview
The rating feature allows users to rate services on a scale of 1-5 stars. The implementation includes:

1. **Service Entity Updates**: Added `userRatings` map to store individual user ratings
2. **Repository Layer**: Added methods to handle rating operations
3. **Cubit Layer**: Added rating state management
4. **UI Components**: Created reusable rating widget
5. **Page Updates**: Integrated ratings into services page and single service page

## Key Components

### Service Entity (`lib/features/services/domain/entities/service.dart`)
- Added `Map<String, int> userRatings` to store user ratings (userId -> rating)
- Added `averageRating` getter to calculate average rating
- Added `getUserRating(String userId)` method to get specific user's rating
- Updated `copyWith()` and JSON serialization methods

### Rating Widget (`lib/features/services/presentation/components/rating_widget.dart`)
- Displays star ratings (1-5 stars)
- Shows average rating and total number of ratings
- Optional rating dialog for user interaction
- Handles rating submission with error handling
- Responsive design with customizable size and color

### Repository Methods
- `rateService(String serviceId, String userId, int rating)`: Submit a rating
- `getUserRating(String serviceId, String userId)`: Get user's rating for a service

### Cubit Methods
- `rateService()`: Handles rating submission and UI updates
- `getUserRating()`: Retrieves user's rating for display

## Usage

### Display Ratings
```dart
RatingWidget(
  service: service,
  size: 20.0,
  color: Colors.amber,
)
```

### Interactive Rating (with dialog)
```dart
RatingWidget(
  service: service,
  showRatingDialog: true,
  size: 25.0,
  color: Colors.amber,
)
```

## Features

1. **Average Rating Display**: Shows calculated average with star visualization
2. **Rating Count**: Displays total number of ratings
3. **User Rating Retrieval**: Shows user's previous rating if exists
4. **Rating Dialog**: Interactive star selection for rating submission
5. **Error Handling**: Proper error messages for failed operations
6. **Real-time Updates**: UI updates immediately after rating submission
7. **Top Rated Section**: Services page shows top-rated services

## Database Structure

The service document in Firestore now includes:
```json
{
  "userRatings": {
    "userId1": 5,
    "userId2": 4,
    "userId3": 3
  }
}
```

## UI Integration

1. **Services Page**: Added "Top Rated" section showing highest-rated services
2. **Service Tiles**: Each service tile shows rating display
3. **Single Service Page**: Interactive rating widget with dialog
4. **Responsive Design**: Ratings adapt to different screen sizes

## Future Enhancements

1. Rating analytics and statistics
2. Rating filters and sorting options
3. Rating notifications for service providers
4. Rating moderation system
5. Rating history for users 