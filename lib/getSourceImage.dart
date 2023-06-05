String getSourceImage(int mood){  //get the image corresponding to the mood
    if (mood >90){
      return "assets/images/verryHappy.png";
    }
    if (mood >=0){
      return "assets/images/happy.png";
    }
    return 'assets/images/sad${(-mood/14).ceil()}.png'; //the image is chosen according to the curse level, we have 8 images for the sad mood with a mood going from -1 to -100 (for sad)
  }