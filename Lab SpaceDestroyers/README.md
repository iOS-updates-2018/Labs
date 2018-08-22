# Space Destroyers

For the final lab, we will be making one of the classic arcade games on iOS, Space *Destroyers*! We will be using sprites, physics, and more. Here is a glimpse of the final app:

<p align="center">
  <img src="https://i.imgur.com/hOKHyf8.png" width="35%">
</p>


Part 1: Getting Started
---
1. Open a new project in Xcode but choose `Game` rather than single-page app for your template. Call it "Space Destroyers" and feel free to include testing if you wish. **Be sure that the SpriteKit** is selected as well. 

    After saving the new project to an appropriate directory, build it and you will get a 'Hello World' page; click on the page and a spinning airplane appears at the point you clicked.  This is the base SpriteKit code which we will now spend some time updating, but you can begin to see the power of the SpriteKit framework. 

    Go to `GameScene.swift` which has a bunch of touch methods. We need those methods, but remove all the code within those methods. Also create a group called `Scenes` and place this `GameScene.swift` file within that folder. 

    Next, select and delete GameScene.sks (move to trash). The .sks file allows you to lay out the scene visually. For this project, we will be adding every node programmatically so it's not necessary. 

    Create a folder for models because we have a lot of them to build later. Finally, add the images folder ([zipped copy here](http://67442.cmuis.net/files/67442/lab9images.zip)) to your project through XCode and load into `Assets.xcassets`.

2. The `GameScene.swift` file will handle most of the game interactions, but we have to start the game somehow, which means we need a starting scene. Create a new file but choose the template as `Cocoa Touch Class` (be sure you are on `iOS > source` on left hand side), call the class `StartGameScene`, make it a subclass of `SKScene` (way down on the option choices), and save it to the scenes directory. Open the file and add `import SpriteKit` right after `import UIKit`.

    In that file we need to start with the method `didMove` which is the method run when this scene is first invoked. Below is some code which will set the background to black and set up the `startGameButton` for us:

    ```swift
    override func didMove(to view: SKView) {
      backgroundColor = SKColor.black
      
      let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
      startGameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
      startGameButton.name = "startgame"
      addChild(startGameButton)
    }
    ```

  Now we need to actually handle someone touching the start button. The typical method in SpriteKit for this is callled `touchesBegan`.  Below is a method for `touchesBegan` that will will identify if we touched the `startGameButton` node and then transfer us to `GameScene` which will handle most of our interactions:

  ```swift
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if touchedNode.name == "startgame" {
      let gameOverScene = GameScene(size: size)
      gameOverScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
      view?.presentScene(gameOverScene,transition: transitionType)
    }
  }
  ```

3. To even get to this scene, though, we need to set up the `GameViewController`. First delete all the methods you were given at the beginning except for `viewDidLoad()` and `prefersStatusBarHidden()`. We will keep the latter method just as it is; we don't want the status bar interfering with our gaming experience. In `viewDidLoad()` replace the code Xcode has with the following:

    ```swift
    super.viewDidLoad()
    let scene = StartGameScene(size: view.bounds.size)
    let skView = view as! SKView
    skView.showsFPS = true
    skView.showsNodeCount = true
    skView.ignoresSiblingOrder = true
    scene.scaleMode = .resizeFill
    skView.presentScene(scene)
    ```

    A lot of this code was in the original method, but the real key is that our `StartGameScene` is set up as our initial scene. That scene will give way to `GameScene` (which handles most of the interactions) which know when to give way to `LevelCompletedScene` (forthcoming) and eventually looping back to this `StartGameScene` when the player is killed.  Most of this is coming later -- the key here is that we start on the right scene, which is `StartGameScene`.

    **You should now be able to build the project and click the "New Game" button which flips to a blank screen.**


Part 2: Creating Invaders & Players
---
1. Time to start building some models (of course, in our Models group). The first Cocoa Touch Class, `Invader.swift`, will handle logic for our invaders. Make this class inherit from `SKSpriteNode`.  Below is some starter code for this class:
 
    ```swift
    import UIKit
    import SpriteKit

    class Invader: SKSpriteNode {
      // we will determine the invader's row/column later, set to (0,0) for now
      var invaderRow = 0
      var invaderColumn = 0
    
      init() {
        // we have three types of invader images so randomly chose among these
        let randNum = Int(arc4random_uniform(3) + 1)
        let texture = SKTexture(imageNamed: "invader\(randNum)")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "invader"

        // preparing invaders for collisions once we add physics...

      }
    
      required init?(coder aDecoder: NSCoder) {
        // SKSpriteNode conforms to NSCoding, which requires we implement this, but we can just call super.init() 
        super.init(coder: aDecoder)
      }
    
    
      func fireBullet(scene: SKScene){
        // to be implemented later, once we have bullets...

      }
    }
    ```

2. Now we need a Player Cocoa Touch Class (`Player.swift`). This will also inherit from `SKSpriteNode` which conforms to `NSCoding`, which means it will also have to implement the `required init()` as we did before. Below is some initial code to help us with this:

    ```swift
    import UIKit
    import SpriteKit

    class Player: SKSpriteNode {
      
      private var canFire = true
      private var invincible = false
      // should the player live after a hit or die?
      private var lives:Int = 3 {
        didSet {
          if (lives < 0) {
            kill()
          } else {
            respawn()
          }
        }
      }
      
      init() {
        let texture = SKTexture(imageNamed: "player1")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        // preparing player for collisions once we add physics...
        
        
        animate()
      }
      
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
      
      // we want the player image to alternate between one with and without jet flames so it looks like it's moving
      private func animate(){
        var playerTextures:[SKTexture] = []
        for i in 1...2 {
          playerTextures.append(SKTexture(imageNamed: "player\(i)"))
        }
        let playerAnimation = SKAction.repeatForever(SKAction.animate(with: playerTextures, timePerFrame: 0.1))
        self.run(playerAnimation)
      }
      
      func die (){
        // logic to be determined shortly
      }
      
      func kill(){
        // logic to be determined shortly
      }
      
      func respawn(){
        // logic to be determined shortly
      }
      
      func fireBullet(scene: SKScene){
        // to be implemented later, once we have bullets...
      }
    }
    ```

3. These classes aren't complete yet, but let's set up some invaders and a player in our game scene, just to see what we have. Go to `GameScene.swift` file; we want to start by setting the level of the game as a global variable. To do that, **outside** of the class, simply set `var levelNum = 1` (we will base difficulty later on the level as well as increment it after each set of invaders is destroyed on that level). Add the following properties **inside** the `GameScene` class:

    ```swift
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = [Invader]()  // will increase with each level
    let player:Player = Player()
    let maxLevels = 3 
    ```

    We'd like to have `didMove` set up the invaders, but that's will take some work, so let's create a method to handle that.  Below is a method that could help us (be sure to add `//MARK` so we can start to organize this code -- this class does a lot of heavy lifting and will be long):

    ```swift
    // MARK: - Invader Methods
    func setupInvaders(){
      var invaderRow = 0;
      var invaderColumn = 0;
      let numberOfInvaders = levelNum * 2 + 1
      for i in 1...rowsOfInvaders {
        invaderRow = i
        for j in 1...numberOfInvaders {
          invaderColumn = j
          let tempInvader:Invader = Invader()
          let invaderHalfWidth:CGFloat = tempInvader.size.width/2
          let xPositionStart:CGFloat = size.width/2 - invaderHalfWidth - (CGFloat(levelNum) * tempInvader.size.width) + CGFloat(10)
          tempInvader.position = CGPoint(x:xPositionStart + ((tempInvader.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 46))
          tempInvader.invaderRow = invaderRow
          tempInvader.invaderColumn = invaderColumn
          addChild(tempInvader)
          if(i == rowsOfInvaders){
          invadersWhoCanFire.append(tempInvader)
          }
        }
      }
    }
    ```

    Essentially, this method will create four rows of invaders and on level 1, there will be three columns and that will go up for higher levels. We have to position the invaders on the screen evenly as discussed in class which accounts for most of the rest of the code. Now if we go to `didMove` and add the following:

    ```swift
    backgroundColor = SKColor.black
    setupInvaders()
    ```

    then we can save the project, **build and see the invaders positioned appropriately on the screen**. 

4. Stop the simulator and let's set up the player.  Create a `setupPlayer()` method and mark out this section with `// MARK: - Player Methods` so our code is easily navigated. The guts of our player setup method will be much easier -- just two lines:

  ```swift
  player.position = CGPoint(x: self.frame.midX, y:player.size.height/2 + 10)
  addChild(player)
  ```

  Add `setupPlayer()` to `didMove` and rebuild the project to see the player in place as well.

5. One more thing we need here is to be able to move the invaders closer and closer to the player.  They should move across the row until the first hits the edge, then they reverse direction and move down one row.  Below is some code that will help with that and be sure to add it to the invader methods section of `GameScene`:

    ```swift
    func moveInvaders(){
      var changeDirection = false
      enumerateChildNodes(withName: "invader") { node, stop in
        let invader = node as! SKSpriteNode
        let invaderHalfWidth = invader.size.width/2
        invader.position.x -= CGFloat(self.invaderSpeed)
        if(invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth){
          changeDirection = true
        }
      }
      if(changeDirection == true){
        self.invaderSpeed *= -1
        self.enumerateChildNodes(withName: "invader") { node, stop in
          let invader = node as! SKSpriteNode
          invader.position.y -= CGFloat(46)
        }
        changeDirection = false
      }
    }
    ```
    
    When completed, this method can be added to the `update(currentTime: CFTimeInterval)` method that was initially given to us so that the invaders move appropriately at each frame.  You can rebuild and see that they are advancing appropriately.


Part 3: Firing and Being Fired Upon
---
1. Nice to have the actors, but they need to be able to shoot at each other and the way to do that is to give them bullets (okay, technically lasers b/c it's a space game, but they act like bullets so I'm going to call them that right now).  We need a `PlayerBullet` and `InvaderBullet` class, but there are some generic properties that we should implement in a general `Bullet` class.  Our bullet class will also inherit from `SKSpriteNode` and really just has an `init` method that sets the image and sound associated with bullets (as well as the required `NSCoding` method -- don't forget that, XCode will ask you to add it). Our `init` method within this Bullet class will be as follows:

    ```swift
    init(imageName: String, bulletSound: String?) {
      let texture = SKTexture(imageNamed: imageName)
      super.init(texture: texture, color: SKColor.clear, size: texture.size())
      if(bulletSound != nil){
        run(SKAction.playSoundFileNamed(bulletSound!, waitForCompletion: false))
      }
    }
    ```

    Once we have that class, create two subclasses (two new files!), `InvaderBullet` and `PlayerBullet`, that basically have the same code (see example below): 

    ```swift
    import SpriteKit

    class PlayerBullet: Bullet {
      override init(imageName: String, bulletSound:String?){
        super.init(imageName: imageName, bulletSound: bulletSound)
        // more to come once we add some physics to the game...

      }

      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
    }
    ```

2. Now that we have bullets, time to fire them. For the case of invaders, bullets should fire every so often from those on the bottom row.  In the `Invader` class we already create a shell for method for firing bullets. To flesh this out we can use the following code: 

    ```swift
    func fireBullet(scene: SKScene){
      let bullet = InvaderBullet(imageName: "laser", bulletSound: nil)
      bullet.position.x = self.position.x
      bullet.position.y = self.position.y - self.size.height/2
      scene.addChild(bullet)
      let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
      let removeBulletAction = SKAction.removeFromParent()
      bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
    }
    ```
    
    Now in the Invaders methods section of `GameScene` we want to add two methods to actually fire the bullet. The methods below will do the trick:

    ```swift
    func invokeInvaderFire(){
      let fireBullet = SKAction.run(){
        self.fireInvaderBullet()
      }
      let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
      let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
      let repeatForeverAction = SKAction.repeatForever(invaderFire)
      run(repeatForeverAction)
    }
  
    func fireInvaderBullet(){
      if(invadersWhoCanFire.isEmpty){
        levelNum += 1
        // Complete the level later by adding its method here! (Part 5)
      }else{
        let randomInvader = invadersWhoCanFire.randomElement()
        randomInvader.fireBullet(scene: self)
      }
    }
    ```

    When you added this code, Xcode did not like you very much -- why? Because it has no idea what `randomElement()` is. What we want here is to pick a random invader from our array of invaders who can fire and enable that node to fire. We need to add an Array extension to our project that creates `randomElement()` and returns a random element from the array. This is not identical what was done on the exam with the WordScramble project with the `shuffled()` method, but not too dissimilar either. Look back at [WordScramble](https://github.com/profh/WordScramble/blob/master/WordScramble/Word.swift) for inspiration on how to do this. (Hint: this method is far easier and shorter than `shuffled()`; don't overthink it.)

    Once this is working, we can get our invaders to fire by adding `invokeInvaderFire()` right after `setupPlayer()` in `didMove`

3. Now it's time to add bullets to the player. To the `Player` class we also have a shell of a method called `fireBullet` that creates a bullet with sound (remember why we said this is important in class?). Overall it's pretty similar to the invaders method, with one key difference: we are delaying each shot by a half-second to stop rapid firing (although some other game designers might want rapid firing enabled). The code to do this is below: 

  ```swift
  func fireBullet(scene: SKScene){
    if !canFire {
      return
    } else {
      canFire = false   // if we comment out or set to true, rapid firing is possible
      let bullet = PlayerBullet(imageName: "laser",bulletSound: "laser.mp3")
      bullet.position.x = self.position.x
      bullet.position.y = self.position.y + self.size.height/2
      scene.addChild(bullet)
      let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y:scene.size.height + bullet.size.height), duration: 1.0)
      let removeBulletAction = SKAction.removeFromParent()
      bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
      // our delay to stop rapid firing...
      let waitToEnableFire = SKAction.wait(forDuration: 0.5)
      run(waitToEnableFire,completion:{
        self.canFire = true
      })
    }
  }
  ```

  Now to actually fire, the player must touch the screen. To make that possible, we go to the `touchesBegan` method and simply add `player.fireBullet(scene: self)`. Rebuild the project and see that firing is happening on each touch. (In the simulator, that means each mouse/trackpad tap.)


Part 4: Adding Physics
---

1. This is all well and good, but even though we are firing and the invaders are firing at us, nothing is happening and there is no impact -- to have an impact for the bullets we need to add some physics to our game. Before we do that, we need to set up some collision categories so we know who is hitting whom. We define these categories using a bit mask that uses a 32-bit integer with 32 individual flags that can be either on or off. (This also means you can only have a maximum of 32 categories for your game, which isn't a problem for most games).

    Add an additional file to models directory called `CollisionCategories.swift` (**not** a Cocoa Touch Class!) and add the following structure:

    ```swift
    struct CollisionCategories{
      static let Invader : UInt32 = 0x1 << 0
      static let Player: UInt32 = 0x1 << 1
      static let InvaderBullet: UInt32 = 0x1 << 2
      static let PlayerBullet: UInt32 = 0x1 << 3
      static let EdgeBody: UInt32 = 0x1 << 4
    }
    ```

2. We are going to add physics and handle collisions for player bullets with the following code added to the `init` method of the `PlayerBullet` class:

    ```swift
    self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
    self.physicsBody?.isDynamic = true
    self.physicsBody?.usesPreciseCollisionDetection = true
    self.physicsBody?.categoryBitMask = CollisionCategories.PlayerBullet
    self.physicsBody?.contactTestBitMask = CollisionCategories.Invader
    self.physicsBody?.collisionBitMask = 0x0
    ```

    Note: this code was discussed in class, but you can use the `option-click` shortcut to lookup and review specific methods used here. Do the same for the invader bullets, the only difference being the `categoryBitMask` will be InvaderBullet category and the `contactTestBitMask` will be the Player category.

3. We need to do this for the `Invader` class -- adding physics will enable us to track collisions with the player or the player's bullets. In the appropriate place in the code (look at the comments) add the following:

    ```swift 
    self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
    self.physicsBody?.isDynamic = true
    self.physicsBody?.usesPreciseCollisionDetection = false
    self.physicsBody?.categoryBitMask = CollisionCategories.Invader
    self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
    self.physicsBody?.collisionBitMask = 0x0
    ```

    For the `Player` class we need to recognize collisions with the edge of the invaders -- that's when game is over.  To do this, add the following code to the `Player` class:

    ```swift
    self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
    self.physicsBody?.isDynamic = true
    self.physicsBody?.usesPreciseCollisionDetection = false
    self.physicsBody?.categoryBitMask = CollisionCategories.Player
    self.physicsBody?.contactTestBitMask = CollisionCategories.InvaderBullet | CollisionCategories.Invader
    self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
    self.physicsBody?.allowsRotation = false
    ```

4. Now we have to add physics to the `GameScene` itself.  We will do this in two parts. To begin with, at the start of `didMove` we want to add gravity:

    ```swift
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
    ```

5. The second part of adding physics to `GameScene` is implementing the `SKPhysicsContactDelegate` that we referenced earlier in `didMoveToView`. Add this protocol to the class declaration and then add the following method that is needed for this protocol:

    ```swift
    // MARK: - Implementing SKPhysicsContactDelegate protocol
    func didBegin(_ contact: SKPhysicsContact) {
    
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
      (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
      if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
        return
      }
      
      let theInvader = firstBody.node as! Invader
      let newInvaderRow = theInvader.invaderRow - 1
      let newInvaderColumn = theInvader.invaderColumn
      if(newInvaderRow >= 1){
        self.enumerateChildNodes(withName: "invader") { node, stop in
          let invader = node as! Invader
          if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn{
            self.invadersWhoCanFire.append(invader)
            // stop.memory = true --> Deprecated code to check leaks
          }
        }
      }
      
      let invaderIndex = findIndex(array: invadersWhoCanFire,valueToFind: theInvader)
      if(invaderIndex != nil){
        invadersWhoCanFire.remove(at: invaderIndex!)
      }
      theInvader.removeFromParent()
      secondBody.node?.removeFromParent()
    }
    
    if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
      (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
      player.die()
    }
    
    if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
      (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
      player.kill()
    }
    
    if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
      (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
      if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
        return
      }
      
      let theInvader = firstBody.node as! Invader
      let newInvaderRow = theInvader.invaderRow - 1
      let newInvaderColumn = theInvader.invaderColumn
      if(newInvaderRow >= 1){
        self.enumerateChildNodes(withName: "invader") { node, stop in
          let invader = node as! Invader
          if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn{
            self.invadersWhoCanFire.append(invader)
            // stop.memory = true --> Deprecated code to check leaks
          }
        }
      }
      let invaderIndex = findIndex(array: invadersWhoCanFire,valueToFind: firstBody.node as! Invader)
      if(invaderIndex != nil){
        invadersWhoCanFire.remove(at: invaderIndex!)
      }
      theInvader.removeFromParent()
      secondBody.node?.removeFromParent()
    }
    }
    ```


Part 5: Finishing Up
---

1. We have some methods in the `Player` class that still need code. We've determined in the class that a player gets three lives, but what happens when the player is hit by a bullet (die) or collides with an invader (killed)? And if they get killed, how does the player regenerate (respawn)? Let's start with the last one first. Add the following to `respawn`:

    ```swift
    invincible = true
    let fadeOutAction = SKAction.fadeOut(withDuration: 0.4)
    let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
    let fadeOutIn = SKAction.sequence([fadeOutAction,fadeInAction])
    let fadeOutInAction = SKAction.repeat(fadeOutIn, count: 5)
    let setInvicibleFalse = SKAction.run(){
      self.invincible = false
    }
    run(SKAction.sequence([fadeOutInAction,setInvicibleFalse]))
    ```

    We want the respawn process to be delayed (in this case, the ship fades in and out). Note that the player is made invincible during the respawn process -- while the ship is fading in and out we don't want the invaders to be able to hit them. We might also disable the player's ability to fire; I've experimented with that but it found it makes it much harder to progress in the level so I didn't put it in here. (Feel free to add it in and experiment if you'd like.)

2. Now for the die function, we can simply decrement the number of lives by one, but let's only make that possible if the player is not invincible. As noted above, we shouldn't let the player get hit again in the respawn process.

3. For the `kill()` function, add in the following code:

  ```swift
  levelNum = 1
  let gameOverScene = StartGameScene(size: self.scene!.size)
  gameOverScene.scaleMode = self.scene!.scaleMode
  let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
  self.scene!.view!.presentScene(gameOverScene,transition: transitionType)
  ```

4. To finish off a level, we need to add the following to the `Game Management Methods` section of `GameScene` and then add the function call to the appropriate place in `fireInvaderBullet`.

  ```swift
  // MARK: - Game Management Methods
  func levelComplete(){
    if(levelNum <= maxLevels){
      let levelCompleteScene = LevelCompleteScene(size: size)
      levelCompleteScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontalWithDuration(0.5)
      view?.presentScene(levelCompleteScene,transition: transitionType)
    } else {
      levelNum = 1
      newGame()
    }
  }
  ```

  After that, we need to add in a new scene similar to what we did with `StartGameScene` called in this case `LevelCompleteScene` (new Cocoa Touch Class file, inheriting from SKscene).  For this new class, add the following code:

  ```swift
  override func didMove(to view: SKView) {
    self.backgroundColor = SKColor.black
    let startGameButton = SKSpriteNode(imageNamed: "nextlevelbtn")
    startGameButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
    startGameButton.name = "nextlevel"
    addChild(startGameButton)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first! as UITouch
    let touchLocation = touch.location(in: self)
    let touchedNode = self.atPoint(touchLocation)
    if(touchedNode.name == "nextlevel"){
      let gameOverScene = GameScene(size: size)
      gameOverScene.scaleMode = scaleMode
      let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
      view?.presentScene(gameOverScene,transition: transitionType)
    }
  }
  ```

5. Going back to `GameScene`, we need to add a method after `levelComplete` to start new games:

  ```swift
  func newGame(){
    let gameOverScene = StartGameScene(size: size)
    gameOverScene.scaleMode = scaleMode
    let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)    
    view?.presentScene(gameOverScene,transition: transitionType)
  }
  ```

6. As a final step, we can add CoreMotion and use the accelerometer to move the player from side-to-side. As noted in class, the accelerometer doesn't work in the simulator -- this can only be used on a device.  First be sure to `import CoreMotion` in `GameScene` and then create a motionManager object and a variable to handle accelerometer data as follows:

    ```swift
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    ```

    Once that's done, the following method in `GameScene` will do the trick for us to actually set up the accelerometer: 

    ```swift
    func setupAccelerometer(){
      if motionManager.isAccelerometerAvailable {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
          [weak self] (data: CMAccelerometerData?, error: NSError?) in
          if let acceleration = data?.acceleration {
            self!.accelerationX = CGFloat(acceleration.x)
          }
          } as! CMAccelerometerHandler)
      }
    }
    ```

    Also add the following code to override SpriteKit's `didSimulatePhysics()` method to make sure the player is moving accordingly:

    ```swift
    override func didSimulatePhysics() {
      player.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: 0)
    }
    ```

    To make sure this functionality is applied, add `setupAccelerometer()` after the other setup methods in `didMoveToView`.  

    You can run your final build and play your own iOS game now.  Enjoy.
