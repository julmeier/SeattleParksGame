var allPmaids = [String]()

var index = 0
 for pin in allAnnotationPins {

     if allPmaids.contains(pin.pmaid!) {
         allAnnotationPins.remove(at: index)
     } else {
         allPmaids.append(pin.pmaid!)
     }
     index += 1
 }
