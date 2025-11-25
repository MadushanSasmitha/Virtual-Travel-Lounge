import Foundation
import Combine

struct AttractionInfo: Identifiable, Codable {
    let id = UUID()
    let title: String
    let location: String
    let fact: String
    let category: String
    let icon: String
    let detailedInfo: DetailedInfo
    
    struct DetailedInfo: Codable {
        let description: String
        let bestTimeToVisit: String
        let highlights: [String]
        let funFacts: [String]
        let coordinates: String
    }
}

class AttractionInfoService: ObservableObject {
    @Published var currentInfo: [AttractionInfo] = []
    
    private let allAttractions = [
        AttractionInfo(
            title: "Machu Picchu", 
            location: "Peru", 
            fact: "Built around 1450 AD, this ancient Incan city sits 2,430 meters above sea level and was unknown to the outside world until 1911.", 
            category: "Ancient Wonder", 
            icon: "mountain.2",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "Machu Picchu is an ancient Incan citadel set high in the Andes Mountains in Peru, above the Sacred Valley. Built in the 15th century and later abandoned, it's renowned for its sophisticated dry-stone walls that fuse huge blocks without the use of mortar.",
                bestTimeToVisit: "May to September (dry season)",
                highlights: ["Huayna Picchu climb", "Temple of the Sun", "Intihuatana stone", "Agricultural terraces"],
                funFacts: ["Contains over 150 buildings", "Built without wheels or iron tools", "Rediscovered by Hiram Bingham in 1911"],
                coordinates: "13.1631°S, 72.5450°W"
            )
        ),
        
        AttractionInfo(
            title: "Great Wall of China", 
            location: "China", 
            fact: "Stretching over 21,000 kilometers, it took over 2,000 years to build and is visible from space under perfect conditions.", 
            category: "Historical Monument", 
            icon: "building.2",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "The Great Wall of China is a series of fortifications made of stone, brick, tamped earth, wood, and other materials, built along the historical northern borders of China to protect against invasions.",
                bestTimeToVisit: "April to June, September to November",
                highlights: ["Badaling section", "Mutianyu section", "Jinshanling section", "Simatai section"],
                funFacts: ["Took over 2,000 years to build", "Millions of workers died during construction", "Not actually visible from space with naked eye"],
                coordinates: "40.4319°N, 116.5704°E"
            )
        ),
        
        AttractionInfo(
            title: "Aurora Borealis", 
            location: "Arctic Circle", 
            fact: "These dancing lights occur when solar particles collide with Earth's magnetic field, best viewed between September and March.", 
            category: "Natural Phenomenon", 
            icon: "sparkles",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "The Aurora Borealis, or Northern Lights, is a natural light display in Earth's sky, predominantly seen in high-latitude regions. Auroras are the result of disturbances in the magnetosphere caused by solar wind.",
                bestTimeToVisit: "September to March (dark season)",
                highlights: ["Iceland viewing", "Northern Norway", "Alaska wilderness", "Canadian territories"],
                funFacts: ["Occurs at altitudes of 80-500 km", "Colors depend on gas types", "Can be predicted 3 days in advance"],
                coordinates: "66.5°N and above"
            )
        ),
        
        AttractionInfo(
            title: "Victoria Falls", 
            location: "Zambia/Zimbabwe", 
            fact: "Known as 'The Smoke That Thunders', this waterfall creates a mist visible from 50 kilometers away during peak flow.", 
            category: "Natural Wonder", 
            icon: "water.waves",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "Victoria Falls is a waterfall on the Zambezi River in southern Africa, which provides habitat for several unique species of plants and animals. It is located on the border between Zambia and Zimbabwe.",
                bestTimeToVisit: "February to May (high water), August to December (low water)",
                highlights: ["Devil's Pool swim", "Helicopter flights", "Bungee jumping", "White water rafting"],
                funFacts: ["108 meters high", "1,708 meters wide", "Creates its own weather system"],
                coordinates: "17.9243°S, 25.8572°E"
            )
        ),
        
        AttractionInfo(
            title: "Petra", 
            location: "Jordan", 
            fact: "This rose-red city was carved directly into sandstone cliffs over 2,000 years ago and served as a major trading hub.", 
            category: "Archaeological Site", 
            icon: "building.columns",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "Petra is a historical and archaeological city in southern Jordan. It is famous for its rock-cut architecture and water conduit system. Established possibly as early as 4th century BC as the capital city of the Nabataean Kingdom.",
                bestTimeToVisit: "March to May, September to November",
                highlights: ["The Treasury (Al-Khazneh)", "Monastery (Ad Deir)", "Royal Tombs", "Siq canyon walk"],
                funFacts: ["Over 800 individual monuments", "UNESCO World Heritage Site since 1985", "Featured in Indiana Jones movies"],
                coordinates: "30.3285°N, 35.4444°E"
            )
        ),
        
        AttractionInfo(
            title: "Galápagos Islands", 
            location: "Ecuador", 
            fact: "Home to species found nowhere else on Earth, these islands inspired Charles Darwin's theory of evolution.", 
            category: "Wildlife Sanctuary", 
            icon: "tortoise",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "The Galápagos Islands are an archipelago of volcanic islands distributed around the equator in the Pacific Ocean. The islands are known for their large number of endemic species and were studied by Charles Darwin.",
                bestTimeToVisit: "December to May (warm season), June to November (dry season)",
                highlights: ["Giant tortoises", "Marine iguanas", "Blue-footed boobies", "Darwin's finches"],
                funFacts: ["97% of land area is national park", "Inspired Darwin's theory of evolution", "Home to world's only marine iguanas"],
                coordinates: "0.9538°S, 90.9656°W"
            )
        ),
        
        AttractionInfo(
            title: "Angkor Wat", 
            location: "Cambodia", 
            fact: "Originally built as a Hindu temple in the 12th century, it's the largest religious monument in the world.", 
            category: "Temple Complex", 
            icon: "building.2.crop.circle",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "Angkor Wat is a temple complex in Cambodia and one of the largest religious monuments in the world. Originally constructed as a Hindu temple dedicated to the god Vishnu for the Khmer Empire.",
                bestTimeToVisit: "November to March (cool and dry)",
                highlights: ["Sunrise viewing", "Bas-relief galleries", "Central towers", "Reflection pools"],
                funFacts: ["Covers 162.6 hectares", "Built without mortar", "Faces west unlike most temples"],
                coordinates: "13.4125°N, 103.8670°E"
            )
        ),
        
        AttractionInfo(
            title: "Sahara Desert", 
            location: "North Africa", 
            fact: "Covering 9 million square kilometers, it's larger than the entire United States and contains sand dunes up to 180 meters high.", 
            category: "Desert", 
            icon: "sun.max",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "The Sahara is a desert on the African continent. With an area of 9,200,000 square kilometers, it is the largest hot desert in the world and the third largest desert overall.",
                bestTimeToVisit: "October to April (cooler months)",
                highlights: ["Erg Chebbi dunes", "Camel trekking", "Berber villages", "Oasis towns"],
                funFacts: ["Size of entire United States", "Temperatures can reach 58°C", "Contains underground rivers"],
                coordinates: "23.4162°N, 25.6628°E"
            )
        ),
        
        AttractionInfo(
            title: "Mount Everest", 
            location: "Nepal/Tibet", 
            fact: "At 8,848 meters, it grows approximately 4mm taller each year due to tectonic plate movement.", 
            category: "Mountain Peak", 
            icon: "triangle",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "Mount Everest is Earth's highest mountain above sea level, located in the Mahalangur Himal sub-range of the Himalayas. The China–Nepal border runs across its summit point.",
                bestTimeToVisit: "April to May, September to November",
                highlights: ["Base Camp trek", "Summit attempts", "Sherpa culture", "Himalayan views"],
                funFacts: ["Height: 8,848.86 meters", "First climbed in 1953", "Over 300 people have died attempting to climb it"],
                coordinates: "27.9881°N, 86.9250°E"
            )
        ),
        
        AttractionInfo(
            title: "Great Barrier Reef", 
            location: "Australia", 
            fact: "This living structure spans 2,300 kilometers and is home to over 1,500 species of fish and 400 types of coral.", 
            category: "Marine Ecosystem", 
            icon: "fish",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "The Great Barrier Reef is the world's largest coral reef system composed of over 2,900 individual reefs and 900 islands stretching over 2,300 kilometres off the coast of Queensland, Australia.",
                bestTimeToVisit: "June to October (dry season)",
                highlights: ["Scuba diving", "Snorkeling", "Glass-bottom boats", "Marine life tours"],
                funFacts: ["Visible from outer space", "Supports 65,000 jobs", "Home to 6 species of sea turtles"],
                coordinates: "18.2871°S, 147.6992°E"
            )
        ),
        
        AttractionInfo(
            title: "Yellowstone", 
            location: "USA", 
            fact: "The world's first national park sits atop a supervolcano and contains over 10,000 hydrothermal features.", 
            category: "National Park", 
            icon: "flame",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "Yellowstone National Park is a nearly 3,500-sq.-mile wilderness recreation area atop a volcanic hotspot. Mostly in Wyoming, the park spreads into parts of Montana and Idaho.",
                bestTimeToVisit: "April to May, September to October",
                highlights: ["Old Faithful geyser", "Grand Prismatic Spring", "Yellowstone Lake", "Wildlife viewing"],
                funFacts: ["World's first national park (1872)", "Sits on active supervolcano", "Home to over 10,000 hydrothermal features"],
                coordinates: "44.4280°N, 110.5885°W"
            )
        ),
        
        AttractionInfo(
            title: "Taj Mahal", 
            location: "India", 
            fact: "This marble mausoleum changes color throughout the day, appearing pinkish at dawn and golden at sunset.", 
            category: "Architectural Marvel", 
            icon: "building.2.crop.circle.fill",
            detailedInfo: AttractionInfo.DetailedInfo(
                description: "The Taj Mahal is an ivory-white marble mausoleum on the right bank of the river Yamuna in the Indian city of Agra. It was commissioned in 1632 by the Mughal emperor Shah Jahan to house the tomb of his favourite wife, Mumtaz Mahal.",
                bestTimeToVisit: "October to March (cooler weather)",
                highlights: ["Main mausoleum", "Reflecting pools", "Gardens", "Mosque and guest house"],
                funFacts: ["Built over 22 years", "Employed 20,000 artisans", "Changes color throughout the day"],
                coordinates: "27.1751°N, 78.0421°E"
            )
        ),
        
        // Add default detailed info for remaining attractions
        AttractionInfo(title: "Amazon Rainforest", location: "South America", fact: "Producing 20% of the world's oxygen, it contains more species in one hectare than all of North America.", category: "Rainforest", icon: "tree", detailedInfo: AttractionInfo.DetailedInfo(description: "The Amazon rainforest is a moist broadleaf tropical rainforest in the Amazon biome that covers most of the Amazon basin of South America.", bestTimeToVisit: "June to November (dry season)", highlights: ["Wildlife spotting", "River cruises", "Indigenous communities", "Canopy walks"], funFacts: ["Produces 20% of world's oxygen", "Home to 10% of known species", "Spans 9 countries"], coordinates: "3.4653°S, 62.2159°W")),
        
        AttractionInfo(title: "Stonehenge", location: "England", fact: "These 5,000-year-old stones were transported from Wales, 240 kilometers away, using methods still debated today.", category: "Prehistoric Monument", icon: "circle.grid.cross", detailedInfo: AttractionInfo.DetailedInfo(description: "Stonehenge is a prehistoric monument consisting of a ring of standing stones, each around 13 feet high, seven feet wide, and weighing around 25 tons.", bestTimeToVisit: "April to September", highlights: ["Stone circle", "Heel Stone", "Visitor center", "Summer solstice"], funFacts: ["Built around 3100 BC", "Stones from Wales 150 miles away", "Purpose still debated"], coordinates: "51.1789°N, 1.8262°W")),
        
        AttractionInfo(title: "Antelope Canyon", location: "USA", fact: "Carved by flash floods over millions of years, this slot canyon creates ethereal light beams that photographers travel worldwide to capture.", category: "Geological Formation", icon: "camera.macro", detailedInfo: AttractionInfo.DetailedInfo(description: "Antelope Canyon is a slot canyon in the American Southwest, on Navajo land east of Page, Arizona. It includes two separate, scenic slot canyon sections, referred to as Upper Antelope Canyon and Lower Antelope Canyon.", bestTimeToVisit: "March to October", highlights: ["Light beams", "Wave-like structure", "Photography tours", "Navajo guides"], funFacts: ["Formed by flash flood erosion", "Most photographed slot canyon", "Sacred to Navajo people"], coordinates: "36.8619°N, 111.3743°W")),
        
        AttractionInfo(title: "Salar de Uyuni", location: "Bolivia", fact: "The world's largest salt flat becomes a perfect mirror during rainy season, creating the illusion of walking on clouds.", category: "Salt Flat", icon: "cloud.fill", detailedInfo: AttractionInfo.DetailedInfo(description: "Salar de Uyuni is the world's largest salt flat, at 10,582 square kilometers. It is in the Daniel Campos Province in Potosí in southwest Bolivia, near the crest of the Andes.", bestTimeToVisit: "May to October (dry), December to April (mirror effect)", highlights: ["Mirror effect", "Salt pyramids", "Flamingo viewing", "Stargazing"], funFacts: ["World's largest salt flat", "Contains 50-70% of world's lithium", "Perfectly flat surface"], coordinates: "20.1338°S, 67.4891°W")),
        
        AttractionInfo(title: "Bagan", location: "Myanmar", fact: "Once home to over 10,000 Buddhist temples, today more than 2,000 ancient pagodas still dot the landscape.", category: "Archaeological Zone", icon: "building.2.crop.circle", detailedInfo: AttractionInfo.DetailedInfo(description: "Bagan is an ancient city and a UNESCO World Heritage Site located in the Mandalay Region of Myanmar. From the 9th to 13th centuries, the city was the capital of the Pagan Kingdom.", bestTimeToVisit: "October to February", highlights: ["Hot air balloon rides", "Sunrise viewing", "Temple exploration", "Local markets"], funFacts: ["Over 2,000 temples remain", "Built between 11th-13th centuries", "Capital of Pagan Kingdom"], coordinates: "21.1717°N, 94.8575°E")),
        
        AttractionInfo(title: "Iguazu Falls", location: "Argentina/Brazil", fact: "Consisting of 275 individual waterfalls, Eleanor Roosevelt famously said 'Poor Niagara' upon seeing them.", category: "Waterfall System", icon: "water.waves.and.arrow.down", detailedInfo: AttractionInfo.DetailedInfo(description: "Iguazu Falls are waterfalls of the Iguazu River on the border of the Argentine province of Misiones and the Brazilian state of Paraná.", bestTimeToVisit: "March to May, August to October", highlights: ["Devil's Throat", "Boat rides", "Wildlife viewing", "Walkways"], funFacts: ["275 individual falls", "UNESCO World Heritage Site", "Taller than Niagara Falls"], coordinates: "25.6953°S, 54.4367°W")),
        
        AttractionInfo(title: "Socotra Island", location: "Yemen", fact: "Isolated for millions of years, one-third of its plant species exist nowhere else on Earth, including the iconic Dragon's Blood Tree.", category: "Endemic Ecosystem", icon: "tree.fill", detailedInfo: AttractionInfo.DetailedInfo(description: "Socotra Island is the largest of the four islands in the Socotra Archipelago. The island is very isolated and a third of its plant life is found nowhere else on the planet.", bestTimeToVisit: "October to April", highlights: ["Dragon's Blood Trees", "Bottle trees", "Pristine beaches", "Endemic wildlife"], funFacts: ["UNESCO World Heritage Site", "700 endemic species", "Isolated for 6 million years"], coordinates: "12.5000°N, 53.8167°E")),
        
        AttractionInfo(title: "Zhangjiajie", location: "China", fact: "These towering sandstone pillars inspired the floating mountains in the movie Avatar and can reach heights of 400 meters.", category: "Geological Wonder", icon: "mountain.2.fill", detailedInfo: AttractionInfo.DetailedInfo(description: "Zhangjiajie National Forest Park is a unique national forest park located in Zhangjiajie City in northern Hunan Province in the People's Republic of China.", bestTimeToVisit: "April to June, September to November", highlights: ["Avatar Hallelujah Mountain", "Glass bridge", "Cable cars", "Golden Whip Stream"], funFacts: ["Inspired Avatar movie", "Over 3,000 sandstone pillars", "UNESCO World Heritage Site"], coordinates: "29.1167°N, 110.4833°E"))
    ]
    
    func loadRandomAttractions(count: Int = 7) {
        currentInfo = Array(allAttractions.shuffled().prefix(count))
    }
    
    func refreshContent() {
        loadRandomAttractions()
    }
}
