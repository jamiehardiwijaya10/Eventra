import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../widgets/page/category_chip.dart';
import '../widgets/page/recommended_section.dart';
import '../widgets/page/popular_booth.dart';
import '../widgets/page/booth_card.dart';


class BoothPage extends StatefulWidget {

  const BoothPage({
    super.key,
  });


  @override
  State<BoothPage> createState() => _BoothPageState();

}

class _BoothPageState extends State<BoothPage> {

  final searchController = TextEditingController();

  String selectedCategory = "All";

  final categories = const [
    "All",
    "Food",
    "Beverage",
    "Fashion",
    "Merchandise",
    "Game",
    "Art",
  ];

  final booths = const [

    BoothModel(
      image:"assets/images/burger.png",
      name:"Burger Station",
      category:"Food",
      description:
      "Fresh burger with special sauce.",
      rating:4.9,
      totalEvent:20,
      isPopular:true,
    ),

    BoothModel(
      image:"assets/images/burger.png",
      name:"Coffee Corner",
      category:"Beverage",
      description:
      "Premium coffee booth.",
      rating:4.8,
      totalEvent:15,
      isPopular:true,
    ),

    BoothModel(
      image:"assets/images/burger.png",
      name:"Urban Fashion",
      category:"Fashion",
      description:
      "Local fashion brand.",
      rating:4.7,
      totalEvent:10,
      isPopular:false,
    ),
  ];

  List<BoothModel> get filteredBooths {

    if(selectedCategory == "All"){
      return booths;
    }

    return booths
        .where(
          (booth)=>
      booth.category == selectedCategory,
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      bottomNavigationBar: const NavBar(
        currentIndex:3,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                "Explore Booths",
                style: GoogleFonts.poppins(
                  fontSize:24,
                  fontWeight:FontWeight.bold,
                ),
              ),

              const SizedBox(height:6),

              Text(
                "Find interesting booths around events.",
                style: GoogleFonts.poppins(
                  color:Colors.grey,
                  fontSize:13,
                ),
              ),

              const SizedBox(height:20),

              TextField(
                controller:searchController,
                decoration:InputDecoration(
                  hintText:
                  "Search booth...",
                  prefixIcon:
                  const Icon(
                    Icons.search,
                  ),
                  filled:true,
                  fillColor:
                  Colors.grey.shade100,
                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height:20),

              SizedBox(
                height:40,
                child:ListView.builder(
                  scrollDirection:
                  Axis.horizontal,
                  itemCount:
                  categories.length,
                  itemBuilder:(context,index){
                    return BoothCategoryChip(
                      title:
                      categories[index],

                      selected:
                      selectedCategory ==
                          categories[index],

                      onTap:(){
                        setState((){
                          selectedCategory =
                          categories[index];
                        });
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height:30),

              RecommendedBoothSection(
                booths:filteredBooths,
              ),

              const SizedBox(height:30),

              PopularBoothSection(
                booths:filteredBooths,
              ),

              const SizedBox(height:30),

              Text(
                "All Booths",
                style:GoogleFonts.poppins(
                  fontSize:18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height:15),

              ...filteredBooths.map(
                    (booth)=>
                    BoothCard(
                      booth:booth,
                      onTap:(){
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}