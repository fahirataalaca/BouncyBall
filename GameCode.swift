import Foundation

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    targets.append(target)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    target.isDraggable = false
}

func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    otherShape.fillColor = .green
}

func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
        
        var hitTargets = 0
        for target in targets {
            if target.fillColor == .green {
                hitTargets += 1
            }
        }
        
        if hitTargets == targets.count {
            print("Won game!")
        }
        scene.presentAlert(text: "You won!",
           completion: alertDismissed)
    
    }
}

var barriers: [Shape] = []
var targets: [Shape] = []

let ball = OvalShape(width: 40, height: 40)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]
 
let funnel = PolygonShape(points: funnelPoints)

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.fillColor = .blue
    ball.hasPhysics = true
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)
    
    barrier.position = position
    barrier.hasPhysics = true
    barrier.isImmobile = true // This prevents the barrier from falling
    barrier.angle = angle
    barrier.fillColor = .brown
    
    scene.add(barrier)
}

fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false
}

func setup() {
    setupBall()
    
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    addBarrier(at: Point(x: 100, y: 150), width: 50, height: 25, angle: -0.1)
    addBarrier(at: Point(x: 300, y: 150), width: 60, height: 25, angle: 0.3)
    
    setupFunnel()
    
    resetGame()
    scene.onShapeMoved = printPosition(of:)
    
    addTarget(at: Point(x: 150, y: 400))
    addTarget(at: Point(x: 103, y: 373))
    addTarget(at: Point(x: 181, y: 400))
    addTarget(at: Point(x: 259, y: 345))
    addTarget(at: Point(x: 248, y: 262))
    addTarget(at: Point(x: 171, y: 263))
    addTarget(at: Point(x: 138, y: 218))
    addTarget(at: Point(x: 224, y: 201))
}

func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    for barrier in barriers {
        barrier.isDraggable = false
    }
    
    for target in targets {
        target.fillColor = .yellow
    }
    
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

func alertDismissed() {
}

