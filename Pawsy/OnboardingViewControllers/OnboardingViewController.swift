//
//  PetNameViewController.swift
//  Pawsy
//
//  Created by Shantini Vyas on 12/14/17.
//  Copyright © 2017 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import Eureka
import ImageRow
import Alamofire


class OnboardingViewController: FormViewController {
    
    var authUI: FUIAuth?
    var downloadURL: String?
    var user: User?
    
    
    @IBAction func didPressSave(_ sender: UIBarButtonItem) {
        var dataUpload = [String: Any]()
        let dogName: String = self.dataFromForm["name"] as! String
        let db = Firestore.firestore()
        
        for items in self.dataFromForm{
            if items.value == nil{
                dataUpload[items.key] = ""
            }
            else if items.key != "photo" {
                dataUpload[items.key] = items.value
            }
            
        }
        let dogImage = self.dataFromForm["photo"] as! UIImage
        let imagedata  = UIImagePNGRepresentation(dogImage)
        let storage = Storage.storage()
        let dogID = self.user!.uid + "-" + dogName
        let newRef = storage.reference().child("images/"+dogID)
        
        _ = newRef.putData(imagedata!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print(error!.localizedDescription)
                dataUpload["photo"] = ""
                return
            }
            self.downloadURL = "gs://pawsy-c0063.appspot.com/images/" + dogID
            dataUpload["photo"] = self.downloadURL
            let newDoc = db.collection("users").document(self.user!.uid).collection("dogs").document(dogName)
            newDoc.setData(dataUpload)
        }
        
    }
    
    @IBAction func didPressCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    var delegate: OnboardingViewControllerDelegate?
    var dataFromForm: [String: Any?] = [
        "name": nil,
        "age": nil,
        "weight": nil,
        "breed": nil,
        
        "photo": nil,
        
        "energyLevel": nil,
        "dogFeelings": nil,
        "humanFeelings": nil,
        "roughness": nil,
        "ball": nil,
        "playScene": nil,
        "dogSizePreference": nil,
        "lookingFor": nil,
        ]
    let breedList = [
        "Unknown",
        "Mix",
        "Other",
        "Affenpinscher",
        "Afghan Hound",
        "Aidi",
        "Airedale Terrier",
        "Akbash Dog",
        "Alano Español",
        "Alaskan Klee Kai",
        "Alaskan Malamute",
        "Alpine Dachsbracke",
        "Alpine Spaniel",
        "American Bulldog",
        "American Cocker Spaniel",
        "American Eskimo Dog",
        "American Foxhound",
        "American Hairless Terrier",
        "American Pit Bull Terrier",
        "American Staffordshire Terrier",
        "American Water Spaniel",
        "Anglo-Français de Petite Vénerie",
        "Appenzeller Sennenhund",
        "Ariege Pointer",
        "Ariegeois",
        "Armant",
        "Armenian Gampr dog",
        "Artois Hound",
        "Australian Cattle Dog",
        "Australian Kelpie",
        "Australian Shepherd",
        "Australian Silky Terrier",
        "Australian Stumpy Tail Cattle Dog",
        "Australian Terrier",
        "Azawakh",
        "Bakharwal Dog",
        "Barbet",
        "Basenji",
        "Basque Shepherd Dog",
        "Basset Artésien Normand",
        "Basset Bleu de Gascogne",
        "Basset Fauve de Bretagne",
        "Basset Hound",
        "Bavarian Mountain Hound",
        "Beagle",
        "Beagle-Harrier",
        "Bearded Collie",
        "Beauceron",
        "Bedlington Terrier",
        "Belgian Shepherd Dog (Groenendael)",
        "Belgian Shepherd Dog (Laekenois)",
        "Belgian Shepherd Dog (Malinois)",
        "Bergamasco Shepherd",
        "Berger Blanc Suisse",
        "Berger Picard",
        "Berner Laufhund",
        "Bernese Mountain Dog",
        "Billy",
        "Black and Tan Coonhound",
        "Black and Tan Virginia Foxhound",
        "Black Norwegian Elkhound",
        "Black Russian Terrier",
        "Bloodhound",
        "Blue Lacy",
        "Blue Paul Terrier",
        "Boerboel",
        "Bohemian Shepherd",
        "Bolognese",
        "Border Collie",
        "Border Terrier",
        "Borzoi",
        "Boston Terrier",
        "Bouvier des Ardennes",
        "Bouvier des Flandres",
        "Boxer",
        "Boykin Spaniel",
        "Bracco Italiano",
        "Braque d'Auvergne",
        "Braque du Bourbonnais",
        "Braque du Puy",
        "Braque Francais",
        "Braque Saint-Germain",
        "Brazilian Terrier",
        "Briard",
        "Briquet Griffon Vendéen",
        "Brittany",
        "Broholmer",
        "Bruno Jura Hound",
        "Bucovina Shepherd Dog",
        "Bull and Terrier",
        "Bull Terrier (Miniature)",
        "Bull Terrier",
        "Bulldog",
        "Bullenbeisser",
        "Bullmastiff",
        "Bully Kutta",
        "Burgos Pointer",
        "Cairn Terrier",
        "Canaan Dog",
        "Canadian Eskimo Dog",
        "Cane Corso",
        "Cardigan Welsh Corgi",
        "Carolina Dog",
        "Carpathian Shepherd Dog",
        "Catahoula Cur",
        "Catalan Sheepdog",
        "Caucasian Shepherd Dog",
        "Cavalier King Charles Spaniel",
        "Central Asian Shepherd Dog",
        "Cesky Fousek",
        "Cesky Terrier",
        "Chesapeake Bay Retriever",
        "Chien Français Blanc et Noir",
        "Chien Français Blanc et Orange",
        "Chien Français Tricolore",
        "Chien-gris",
        "Chihuahua",
        "Chilean Fox Terrier",
        "Chinese Chongqing Dog",
        "Chinese Crested Dog",
        "Chinese Imperial Dog",
        "Chinook",
        "Chippiparai",
        "Chow Chow",
        "Cierny Sery",
        "Cimarrón Uruguayo",
        "Cirneco dell'Etna",
        "Clumber Spaniel",
        "Combai",
        "Cordoba Fighting Dog",
        "Coton de Tulear",
        "Cretan Hound",
        "Croatian Sheepdog",
        "Cumberland Sheepdog",
        "Curly Coated Retriever",
        "Cursinu",
        "Cão da Serra de Aires",
        "Cão de Castro Laboreiro",
        "Cão Fila de São Miguel",
        "Dachshund",
        "Dalmatian",
        "Dandie Dinmont Terrier",
        "Danish Swedish Farmdog",
        "Deutsche Bracke",
        "Doberman Pinscher",
        "Dogo Argentino",
        "Dogo Cubano",
        "Dogue de Bordeaux",
        "Drentse Patrijshond",
        "Drever",
        "Dunker",
        "Dutch Shepherd Dog",
        "Dutch Smoushond",
        "East Siberian Laika",
        "East-European Shepherd",
        "Elo",
        "English Cocker Spaniel",
        "English Foxhound",
        "English Mastiff",
        "English Setter",
        "English Shepherd",
        "English Springer Spaniel",
        "English Toy Terrier (Black &amp; Tan)",
        "English Water Spaniel",
        "English White Terrier",
        "Entlebucher Mountain Dog",
        "Estonian Hound",
        "Estrela Mountain Dog",
        "Eurasier",
        "Field Spaniel",
        "Fila Brasileiro",
        "Finnish Hound",
        "Finnish Lapphund",
        "Finnish Spitz",
        "Flat-Coated Retriever",
        "Formosan Mountain Dog",
        "Fox Terrier (Smooth)",
        "French Bulldog",
        "French Spaniel",
        "Galgo Español",
        "Gascon Saintongeois",
        "German Longhaired Pointer",
        "German Pinscher",
        "German Shepherd",
        "German Shorthaired Pointer",
        "German Spaniel",
        "German Spitz",
        "German Wirehaired Pointer",
        "Giant Schnauzer",
        "Glen of Imaal Terrier",
        "Golden Retriever",
        "Gordon Setter",
        "Gran Mastín de Borínquen",
        "Grand Anglo-Français Blanc et Noir",
        "Grand Anglo-Français Blanc et Orange",
        "Grand Anglo-Français Tricolore",
        "Grand Basset Griffon Vendéen",
        "Grand Bleu de Gascogne",
        "Grand Griffon Vendéen",
        "Great Dane",
        "Great Pyrenees",
        "Greater Swiss Mountain Dog",
        "Greek Harehound",
        "Greenland Dog",
        "Greyhound",
        "Griffon Bleu de Gascogne",
        "Griffon Bruxellois",
        "Griffon Fauve de Bretagne",
        "Griffon Nivernais",
        "Hamiltonstövare",
        "Hanover Hound",
        "Hare Indian Dog",
        "Harrier",
        "Havanese",
        "Hawaiian Poi Dog",
        "Himalayan Sheepdog",
        "Hokkaido",
        "Hovawart",
        "Huntaway",
        "Hygenhund",
        "Ibizan Hound",
        "Icelandic Sheepdog",
        "Indian pariah dog",
        "Indian Spitz",
        "Irish Red and White Setter",
        "Irish Setter",
        "Irish Terrier",
        "Irish Water Spaniel",
        "Irish Wolfhound",
        "Istrian Coarse-haired Hound",
        "Istrian Shorthaired Hound",
        "Italian Greyhound",
        "Jack Russell Terrier",
        "Jagdterrier",
        "Jämthund",
        "Kai Ken",
        "Kaikadi",
        "Kanni",
        "Karelian Bear Dog",
        "Karst Shepherd",
        "Keeshond",
        "Kerry Beagle",
        "Kerry Blue Terrier",
        "King Charles Spaniel",
        "King Shepherd",
        "Kintamani",
        "Kishu",
        "Komondor",
        "Kooikerhondje",
        "Koolie",
        "Korean Jindo Dog",
        "Kromfohrländer",
        "Kumaon Mastiff",
        "Kurī",
        "Kuvasz",
        "Kyi-Leo",
        "Labrador Husky",
        "Labrador Retriever",
        "Lagotto Romagnolo",
        "Lakeland Terrier",
        "Lancashire Heeler",
        "Landseer",
        "Lapponian Herder",
        "Large Münsterländer",
        "Leonberger",
        "Lhasa Apso",
        "Lithuanian Hound",
        "Longhaired Whippet",
        "Löwchen",
        "Mahratta Greyhound",
        "Maltese",
        "Manchester Terrier",
        "Maremma Sheepdog",
        "McNab",
        "Mexican Hairless Dog",
        "Miniature American Shepherd",
        "Miniature Australian Shepherd",
        "Miniature Fox Terrier",
        "Miniature Pinscher",
        "Miniature Schnauzer",
        "Miniature Shar Pei",
        "Molossus",
        "Montenegrin Mountain Hound",
        "Moscow Watchdog",
        "Moscow Water Dog",
        "Mountain Cur",
        "Mucuchies",
        "Mudhol Hound",
        "Mudi",
        "Neapolitan Mastiff",
        "New Zealand Heading Dog",
        "Newfoundland",
        "Norfolk Spaniel",
        "Norfolk Terrier",
        "Norrbottenspets",
        "North Country Beagle",
        "Northern Inuit Dog",
        "Norwegian Buhund",
        "Norwegian Elkhound",
        "Norwegian Lundehund",
        "Norwich Terrier",
        "Old Croatian Sighthound",
        "Old Danish Pointer",
        "Old English Sheepdog",
        "Old English Terrier",
        "Old German Shepherd Dog",
        "Olde English Bulldogge",
        "Otterhound",
        "Pachon Navarro",
        "Paisley Terrier",
        "Pandikona",
        "Papillon",
        "Parson Russell Terrier",
        "Patterdale Terrier",
        "Pekingese",
        "Pembroke Welsh Corgi",
        "Perro de Presa Canario",
        "Perro de Presa Mallorquin",
        "Peruvian Hairless Dog",
        "Petit Basset Griffon Vendéen",
        "Petit Bleu de Gascogne",
        "Phalène",
        "Pharaoh Hound",
        "Phu Quoc ridgeback dog",
        "Picardy Spaniel",
        "Plott Hound",
        "Podenco Canario",
        "Pointer (dog breed)",
        "Polish Greyhound",
        "Polish Hound",
        "Polish Hunting Dog",
        "Polish Lowland Sheepdog",
        "Polish Tatra Sheepdog",
        "Pomeranian",
        "Pont-Audemer Spaniel",
        "Poodle",
        "Porcelaine",
        "Portuguese Podengo",
        "Portuguese Pointer",
        "Portuguese Water Dog",
        "Posavac Hound",
        "Pražský Krysařík",
        "Pudelpointer",
        "Pug",
        "Puli",
        "Pumi",
        "Pungsan Dog",
        "Pyrenean Mastiff",
        "Pyrenean Shepherd",
        "Rafeiro do Alentejo",
        "Rajapalayam",
        "Rampur Greyhound",
        "Rastreador Brasileiro",
        "Rat Terrier",
        "Ratonero Bodeguero Andaluz",
        "Redbone Coonhound",
        "Rhodesian Ridgeback",
        "Rottweiler",
        "Rough Collie",
        "Russell Terrier",
        "Russian Spaniel",
        "Russian tracker",
        "Russo-European Laika",
        "Sabueso Español",
        "Saint-Usuge Spaniel",
        "Sakhalin Husky",
        "Saluki",
        "Samoyed",
        "Sapsali",
        "Schapendoes",
        "Schillerstövare",
        "Schipperke",
        "Schweizer Laufhund",
        "Schweizerischer Niederlaufhund",
        "Scotch Collie",
        "Scottish Deerhound",
        "Scottish Terrier",
        "Sealyham Terrier",
        "Segugio Italiano",
        "Seppala Siberian Sleddog",
        "Serbian Hound",
        "Serbian Tricolour Hound",
        "Shar Pei",
        "Shetland Sheepdog",
        "Shiba Inu",
        "Shih Tzu",
        "Shikoku",
        "Shiloh Shepherd Dog",
        "Siberian Husky",
        "Silken Windhound",
        "Sinhala Hound",
        "Skye Terrier",
        "Sloughi",
        "Slovak Cuvac",
        "Slovakian Rough-haired Pointer",
        "Small Greek Domestic Dog",
        "Small Münsterländer",
        "Smooth Collie",
        "South Russian Ovcharka",
        "Southern Hound",
        "Spanish Mastiff",
        "Spanish Water Dog",
        "Spinone Italiano",
        "Sporting Lucas Terrier",
        "St. Bernard",
        "St. John's water dog",
        "Stabyhoun",
        "Staffordshire Bull Terrier",
        "Standard Schnauzer",
        "Stephens Cur",
        "Styrian Coarse-haired Hound",
        "Sussex Spaniel",
        "Swedish Lapphund",
        "Swedish Vallhund",
        "Tahltan Bear Dog",
        "Taigan",
        "Talbot",
        "Tamaskan Dog",
        "Teddy Roosevelt Terrier",
        "Telomian",
        "Tenterfield Terrier",
        "Thai Bangkaew Dog",
        "Thai Ridgeback",
        "Tibetan Mastiff",
        "Tibetan Spaniel",
        "Tibetan Terrier",
        "Tornjak",
        "Tosa",
        "Toy Bulldog",
        "Toy Fox Terrier",
        "Toy Manchester Terrier",
        "Toy Trawler Spaniel",
        "Transylvanian Hound",
        "Treeing Cur",
        "Treeing Walker Coonhound",
        "Trigg Hound",
        "Tweed Water Spaniel",
        "Tyrolean Hound",
        "Vizsla",
        "Volpino Italiano",
        "Weimaraner",
        "Welsh Sheepdog",
        "Welsh Springer Spaniel",
        "Welsh Terrier",
        "West Highland White Terrier",
        "West Siberian Laika",
        "Westphalian Dachsbracke",
        "Wetterhoun",
        "Whippet",
        "White Shepherd",
        "Wire Fox Terrier",
        "Wirehaired Pointing Griffon",
        "Wirehaired Vizsla",
        "Yorkshire Terrier",
        "Šarplaninac"
    ]
   
   
    
    func createForm(){
        form +++ Section("Basic Info")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "name"
                row.tag = "name"
                }.onChange{row in
                    self.dataFromForm["name"] = row.value!
                }
            <<< TextRow(){ row in
                row.title = "Age"
                row.placeholder = "years"
                row.tag = "age"
                }.onChange{row in
                    self.dataFromForm["age"] = row.value!
                }
            <<< TextRow(){ row in
                row.title = "Weight"
                row.placeholder = "lbs"
                row.tag = "weight"
                }.onChange{row in
                    self.dataFromForm["weight"] = row.value!
            }
            <<< MultipleSelectorRow<String>("Dog Breed"){
                $0.title = "Dog Breed"
                $0.tag = "breed"
                $0.selectorTitle = "Select one or more dog breeds"
                $0.options = self.breedList
                }.onChange{row in
                    self.dataFromForm["breed"] = Array(row.value!)
            }
           
            
            +++ Section("Photo")
                <<< ImageRow(){ row in
                    row.title = "Puppy Paw-trait"
                    row.selectorTitle = "Let's see those canines!"
                    row.tag = "photo"
                    row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum, .Camera]
                    row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                    }.onChange{row in
                        self.dataFromForm["photo"] = row.value!
            }
        
        
            +++ Section("Personality")
                <<< PushRow<String>("energyLevel"){
                    $0.title = "How active are you?"
                    $0.selectorTitle = "Energy Level"
                    $0.options = [ "I could rage all day and night",
                         "With daily activity I’m calmer, but not tired out",
                         "I get tired after an hour at the dog park",
                         "I occasionally enjoy playing, but it’s rare",
                         "My butt is glued to the couch"]
                    }.onChange{row in
                        self.dataFromForm["energyLevel"] = row.value!
            }
                <<< PushRow<String>("dogFeelings"){
                    $0.title = "What happens when you meet other dogs?"
                    $0.selectorTitle = "Dog Interaction"
                    $0.options = [
                        "We become bestest pawls!",
                        "We're cool after some butt sniffing",
                        "I can make one new friend at a time",
                        "I only like the friends I already have",
                        "I really like my private space. No dogs allowed!"
                    ]
                    }.onChange{row in
                        self.dataFromForm["dogFeelings"] = row.value!
                }
                <<< PushRow<String>("humanFeelings"){
                    $0.title = "How much do you like humans?"
                    $0.selectorTitle = "Human Interaction"
                    $0.options = [
                        "OMG I LOVE YOU!!!!",
                        "I'm friendly, but I'm more of a dog's dog",
                        "Humans? What humans?",
                        "I like a couple of humans",
                        "I really don’t like people"
                    ]
                    }.onChange{row in
                        self.dataFromForm["humanFeelings"] = row.value!
                }
            <<< PushRow<String>("roughness"){
                $0.title = "How much contact do you like?"
                $0.selectorTitle = "Play Fighting"
                $0.options = [
                    "Smackdowns are my style",
                    "I gotta mount everyone",
                    "I enjoy a nice tumble every once in a while",
                    "Oh we can snuggle, but no wrestling",
                    "Don't touch me!"
                ]
                }.onChange{row in
                    self.dataFromForm["roughness"] = row.value!
                }
        
            <<< PushRow<String>("ball"){
                $0.title = "What happens when you see a ball?"
                $0.selectorTitle = "Ball?"
                $0.options = [
                    "BALL!!!!!!",
                    "Oh cool, a ball! Oh…it’s too far away.",
                    "What is a ball?"
                ]
                }.onChange{row in
                    self.dataFromForm["ball"] = row.value!
                }
        
            <<< PushRow<String>("playScene"){
                $0.title = "What's your ideal playdate?"
                $0.selectorTitle = "My Scene"
                $0.options = [
                    "I’m a party animal - dog park all day, every day",
                    "I dig backyard playdates with 1-2 other dogs",
                    "I love exploring the outdoors",
                    "Track star - I just love running",
                    "Netflix and chew, baby. I'm an indoor pup."
                ]
                }.onChange{row in
                    self.dataFromForm["playScene"] = row.value!
                }
        
            +++ Section("Sniffing for")
                <<< MultipleSelectorRow<String>("dogSizePreference"){
                    $0.title = "I play with dogs who are: (multi-select)"
                    $0.selectorTitle = "Dog Size"
                    $0.options = [
                        "The same size as me",
                        "Smaller than me",
                        "Bigger than me"
                    ]
                    }.onChange{row in
                        self.dataFromForm["dogSizePreference"] = Array(row.value!)
                }
            <<< MultipleSelectorRow<String>("lookingFor"){
                $0.title = "I’m looking for someone to: (multi-select)"
                $0.selectorTitle = "Ideal Mate"
                $0.options = [
                     "help me learn to socialize",
                     "play with me in the backyard",
                     "join a playgroup with me",
                     "hike with me",
                     "go to the beach with me",
                     "hang out with me at the dog park",
                     "walk with me"
                ]
                }.onChange{row in
                    self.dataFromForm["lookingFor"] = Array(row.value!)
            }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createForm()
        animateScroll = true
        rowKeyboardSpacing = 20
        self.user = Auth.auth().currentUser!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
