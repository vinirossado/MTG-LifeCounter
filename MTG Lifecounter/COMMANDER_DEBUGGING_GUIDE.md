# Commander Search Debugging Guide

## Issues Fixed

### 1. Image Loading Problems
**Problem**: Images not loading due to App Transport Security settings
**Solution**: Added proper domain exceptions to Info.plist for:
- `api.scryfall.com`
- `cards.scryfall.io`
- `c1.scryfall.com`

### 2. Commander Search Not Finding "Xyris"
**Problem**: Search query was too restrictive using exact name matching
**Solution**: Changed search query from:
```
q=is%3Acommander+name%3A"Xyris"
```
To:
```
q=is%3Acommander+Xyris
```

### 3. Enhanced Image Loading with Better Error Handling
**Improvements Made**:
- Added comprehensive AsyncImage phase handling
- Added debug logging for image load success/failure
- Better error states with visual feedback
- Loading indicators during image fetch

## Testing the Fixes

### Manual Testing Steps:
1. **Search Test**: 
   - Open commander search
   - Type "Xyris" in search bar
   - Should find "Xyris, the Writhing Storm"

2. **Image Loading Test**:
   - Check console for image loading logs
   - Look for ✅ success or ❌ failure messages
   - Verify images display properly

3. **Network Test**:
   - Featured commanders should load on app start
   - Search should return results quickly
   - Images should load within a few seconds

### Debug Console Output to Look For:
```
🔍 Searching commanders with query: 'Xyris'
🌐 Request URL: https://api.scryfall.com/cards/search?q=is%3Acommander+Xyris...
📡 HTTP Response Status: 200
✅ Found 1 commanders for query: 'Xyris'
   1. Xyris, the Writhing Storm - Image: https://cards.scryfall.io/...
🔄 Loading image: https://cards.scryfall.io/...
✅ Image loaded successfully: https://cards.scryfall.io/...
```

### Expected Behavior:
1. **Search**: Should find commanders with partial name matches
2. **Images**: Should load and display properly
3. **Featured**: Should show popular commanders on first load
4. **Performance**: Searches should complete within 1-2 seconds

## If Issues Persist:

### Check Network Connectivity:
```bash
curl -s "https://api.scryfall.com/cards/search?q=is%3Acommander+Xyris" | jq '.total_cards'
```
Should return a number > 0

### Check Image URLs:
```bash
curl -s "https://api.scryfall.com/cards/search?q=is%3Acommander+Xyris" | jq '.data[0].image_uris.small'
```
Should return an image URL

### Common Issues:
1. **Simulator vs Device**: Test on both - network behavior may differ
2. **iOS Version**: Ensure iOS 15+ for AsyncImage
3. **Xcode Console**: Check for any SSL/TLS errors
4. **App Transport Security**: Verify Info.plist changes are applied

## Performance Notes:
- Images are cached automatically by AsyncImage
- Search results are limited to prevent overwhelming the UI
- Featured commanders load once on app start
- Debounced search prevents excessive API calls
