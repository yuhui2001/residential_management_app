import 'package:flutter/material.dart';

class HouseCleaningTermsPage extends StatelessWidget {
  const HouseCleaningTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms and conditions"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: screenWidth * 0.8,
            child: Text(
              "\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Dignissim suspendisse in est ante in. Id venenatis a condimentum vitae sapien pellentesque. Elit ullamcorper dignissim cras tincidunt lobortis feugiat vivamus. Nam aliquam sem et tortor consequat id porta nibh. Amet volutpat consequat mauris nunc congue. Et egestas quis ipsum suspendisse ultrices gravida dictum. Nulla at volutpat diam ut venenatis tellus in. Enim nec dui nunc mattis enim ut tellus elementum sagittis. Felis imperdiet proin fermentum leo vel orci porta non pulvinar. Aliquet nec ullamcorper sit amet risus. Nisl purus in mollis nunc sed id. Justo eget magna fermentum iaculis eu. Non tellus orci ac auctor augue mauris augue. Nulla porttitor massa id neque aliquam vestibulum morbi. Quam adipiscing vitae proin sagittis. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum. Varius quam quisque id diam vel quam elementum pulvinar. Dictum non consectetur a erat nam at. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Gravida cum sociis natoque penatibus et magnis dis parturient. Molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit. Sit amet massa vitae tortor. Posuere urna nec tincidunt praesent. Sit amet nisl suscipit adipiscing bibendum est ultricies integer quis. Nam aliquam sem et tortor consequat id porta. Nunc id cursus metus aliquam eleifend mi. Consectetur libero id faucibus nisl tincidunt eget nullam. Arcu vitae elementum curabitur vitae nunc sed velit dignissim. Volutpat blandit aliquam etiam erat velit scelerisque in. Arcu non sodales neque sodales ut etiam sit amet. Tincidunt vitae semper quis lectus nulla at volutpat diam. Sed felis eget velit aliquet sagittis id. Ipsum dolor sit amet consectetur adipiscing. Cras ornare arcu dui vivamus arcu felis bibendum. Egestas dui id ornare arcu odio ut sem nulla. Nam aliquam sem et tortor consequat id porta nibh venenatis. Sit amet consectetur adipiscing elit duis tristique sollicitudin nibh. Turpis egestas pretium aenean pharetra magna ac placerat vestibulum lectus. Pellentesque id nibh tortor id aliquet lectus proin nibh nisl. Sed libero enim sed faucibus turpis in. In cursus turpis massa tincidunt dui. Nisl tincidunt eget nullam non nisi est sit amet. Hac habitasse platea dictumst vestibulum. Augue eget arcu dictum varius. Ornare arcu odio ut sem nulla. Sed euismod nisi porta lorem mollis. Metus aliquam eleifend mi in nulla posuere sollicitudin. At tellus at urna condimentum. Pretium quam vulputate dignissim suspendisse in est ante in nibh. Ac tincidunt vitae semper quis lectus nulla at volutpat. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant morbi. Nullam ac tortor vitae purus faucibus ornare suspendisse sed nisi. Tortor dignissim convallis aenean et tortor at.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
