# Vector Builder

## Description
Simple vector builder applecatoin. You can **create**, **drag**, **pin**, **edit** and **delete** vectors.

## Functional: 
1. Create Vector via Start and End point, or just with length amount.
2. Move vector parallel.
3. Edit vectors length and direction via long press and drag onto ends of the vector (arrow or holder).
4. Pin vector to stable degree (0, 90, 180, 270), when self degree relatively near with proper stable degree.
4. Pin vector to another vector, when both positions relatively near to each other.
5. When two vectors pinned to each other, pin vector to stable degree (0, 90, 180, 270) relative to second vector degree.
6. Browse all vectors in side-bar.
7. Show exact vector in the middle of the screen via short tap onto proper vector in side-bar.
8. Delete vector via long tap in side-bar.

## Used Frameworks and Libs:
1. **UIKit** and **SnapKit** for UI. All UI created programmaticaly.
2. **CoreData** for data handling.
3. **SpriteKit** for vectors logyc.
4. **Swinject** for DI.

## Architecture:
**Clean Architecture** with some parts from **VIPER**, i.e. all ViewControllers transitions and alerts are managed by Router class.

### Improvement Area:
1. I decided, that best approach for pinning two vectors to each other, when they are close, is using SpriteKits collision detection. So, in this case I should create physics bodies (circles) for both ends of vectors, and assign them there size, which radius(x2) should be equal to distance, when two vectors are pinned. Problem is that I don't know how to make this size smaller. Whem I set proper amount - build error(EXC_BAD_ACCESS (code=1, address=0x0).
2. When two vectors pinned to each other, and you drag (long tap) holder of one of them, it does not pin to angles, related to second vector ( i.e. when there is 90//180//-90 degree between of them, pin wouldn't work, angle square ( for 90 or -90) wouldn't appear.


![Simulator Screen Shot - iPhone 14 Pro Max - 2022-12-06 at 20 11 49](https://user-images.githubusercontent.com/102898404/205977799-edf8541a-3fa6-4d64-805b-3b95dde94247.png)
![Simulator Screen Shot - iPhone 14 Pro Max - 2022-12-06 at 20 12 05](https://user-images.githubusercontent.com/102898404/205977840-ec167801-dc3a-4ba9-aedf-7ad86bbfbd76.png)
![Simulator Screen Shot - iPhone 14 Pro Max - 2022-12-06 at 20 12 11](https://user-images.githubusercontent.com/102898404/205977866-d76133ed-09d3-484f-b055-a37c0b6936b7.png)
