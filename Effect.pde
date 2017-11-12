import processing.core.*;


class Effect{
  private Effects effect;
  private int duration;
  private int durationMax;
  private int power;
  private boolean isEnded;
  
  Effect(Effects effect, int duration, int power){
    this.effect = effect;
    if(duration <= 60){
      this.durationMax = duration;
    } else{
      this.durationMax = 60;
    }
    this.duration = durationMax;
    this.power = power;
    isEnded = false;
  }
  
  boolean refresh(){
    duration--;
    if(duration <= 0){
      isEnded = true;
      duration = 0;
      power = 0;
    }
    return !isEnded;
  }
  
  void paint(int x1, int y1){
    image(textures.getEffect(effect), x1, y1, 40, 40);
    float rapport = float(duration)/float(durationMax);
    fill(270-rapport*500, rapport*500, rapport*255);
    rect(x1, y1+40, rapport*40, 5);
    fill(255);
    textSize(10);
    text(power, x1, y1);
  }
  
  boolean isDead(){  return isEnded;  }
  
  Effects getEffect(){  return effect;  }
  int getPower(){  return power;  }
  int getTotalTime(){  return durationMax;  }
  int getTimeLeft(){  return duration;  }
}