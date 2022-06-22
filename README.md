# Clone Netflix [iOS_Study_2]

It's an app made by cloning Netflix.

I made it my style based on Netflix which is currently being serviced by App Store.

It was written on the Storyboard and is currently being converted to Programmatically.

## Language

- Swift

## Features

|Home|
|---|
![https://user-images.githubusercontent.com/75382687/168813656-c7035176-e1ad-4d4d-aac6-d58893bddf32.gif](https://user-images.githubusercontent.com/75382687/168813656-c7035176-e1ad-4d4d-aac6-d58893bddf32.gif)

- It was implemented as a Compositional Layout.
- Today's video is displayed at the top.
- The sections show the movies that equivalent to each section header.
<br>

|Saved Contents|
|---|
![https://user-images.githubusercontent.com/75382687/168813759-f325dc59-3e03-4a6f-b8b3-70822d0a44e1.gif](https://user-images.githubusercontent.com/75382687/168813759-f325dc59-3e03-4a6f-b8b3-70822d0a44e1.gif)

- It is added to the list when you tap the button in the upper left corner of the Player View.
- An item can be deleted by swiping the cell.
- Saved videos are stored inside the Client via UserDefaluts.
<br>

|Search Movies|
|---|
![https://user-images.githubusercontent.com/75382687/168813778-9f76cb1c-155c-4d04-8a3a-0465b9fb8820.gif](https://user-images.githubusercontent.com/75382687/168813778-9f76cb1c-155c-4d04-8a3a-0465b9fb8820.gif)

- Used iTunes Search API.
- Tap Thumbnail to play the video.
<br>

|Player View|
|---|
![https://user-images.githubusercontent.com/75382687/168813728-5648ff32-d9b2-42ac-9556-f77a55ecf8cf.gif](https://user-images.githubusercontent.com/75382687/168813728-5648ff32-d9b2-42ac-9556-f77a55ecf8cf.gif)

- It was implemented as an AVFoundation.
- The screen changes to landscape mode.
- The timeframe of the video can be adjusted using the UISlider.
- Use Timer to calculate the remaining time of the video.
<br><br>

## Issues of Development

- Convert Scroll View & Container View to Compositional Layout

> The recommended movies for each section were implemented through Scroll View & Container View and the code was complicated and it was too difficult to layout.
> 
> 
> I learned about the Compositional Layout that supported it from iOS 13 and it became a simpler and easier code to understand.
> 
- Escaping Closure

> I found that the Escape Closure could be used to transfer data to an external function.
> 
> 
> After creating the API class, Networking was performed through URLSession and the Escape Closure in this class
> 
- Control View

> To perform various actions in the Player, buttons and functions had to be implemented directly.
> 
> 
> The objects that interact with the user are included in the newly created Control View.
> 
- URL to Image

> To display the Thumbnail received through the API, the URL of the thumbnail had to be converted to Image.
> 
> 
> It was easily converted using the Kignfisher external Library.
> 

<br>

## Learning New Skills

- `CollectionView Compositional Layout`.
- Transferring data to the outside using `Escaping Closure`.
- To play video using `AVFoundation`.
- Store data inside the client via `User Defaults`.
- TableView Row Swipe Action through `UISwipeActionsConfiguration`.
- Video time calculation using `CMTime`.
- about `UISlider`.

<br>

## API

- iTunes Search API

## Library

- SnapKit
- Kingfisher
