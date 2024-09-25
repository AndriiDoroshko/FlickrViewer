
# FlickrViewer App Documentation

## Overview

FlickrViewer is an iOS application that allows users to browse and search for images from Flickr. It demonstrates the implementation of MVVM architecture, network calls, and UI components in Swift.

## Key Features

- Browse Flickr public feed
- Search for images by keyword
- View image details
- Pull-to-refresh functionality

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture:

- **Models**: Represent the data structures (e.g., `FlickrFeed`, `FlickrItem`)
- **Views**: UI components (e.g., `ViewController`, `DetailsViewController`, `FlickrItemCell`)
- **ViewModels**: Handle business logic and data preparation for views (e.g., `HomeScreenViewModel`, `DetailsViewModel`)

## Key Components

### NetworkService

Handles all network requests to the Flickr API, including searching for images and downloading image data.

### ViewControllers

- **ViewController**: Main screen displaying a collection of Flickr images
- **DetailsViewController**: Shows detailed information about a selected image

### ViewModels

- **HomeScreenViewModel**: Manages the data and logic for the main screen
- **DetailsViewModel**: Handles data for the details view

### Custom Views

- **FlickrItemCell**: Custom collection view cell for displaying Flickr images
- **PullToRefreshView**: Custom view for pull-to-refresh functionality

## Inputs

- User search queries
- User interactions (tapping on images, pull-to-refresh)

## Outputs

- Displayed Flickr images in a collection view
- Detailed image information in a separate view
- Error messages for network or data issues

## Usage

1. Launch the app to view the latest Flickr public feed
2. Use the search bar to find specific images
3. Tap on an image to view more details
4. Pull down on the collection view to refresh the feed

## Testing

Unit tests are included for the `HomeScreenViewModel`, demonstrating how to test the app's core functionality using mock objects.
