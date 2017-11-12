class Chat{
  ArrayList<Message> chat;
  
  class Message{
    private int lifeTime = 0;
    private String message;
    private color colour;
    Message(String message, color colour){
      this.message = message;
      this.colour = colour;
    }
    void refresh(){
      if(lifeTime < 200){
        lifeTime++;
      } else{
        chat.remove(this);
      }
    }
    void paint(int x, int y){
      refresh();
      fill(colour);
      textSize(12);
      text(message, x, y);
    }
  }
  
  Chat(){
    chat = new ArrayList<Message>(100);
  }
  
  private void addMessage(String message, color colour){
    chat.add(new Message(message, colour));
  }
  
  void msg(String message){
    addMessage(message, color(255));
  }
  
  void warn(String message){
    addMessage(message, color(200, 50, 50));
  }
  
  void err(String message){
    addMessage(message, color(255, 0, 0));
  }
  
  void levelUp(String message){
    addMessage(message, color(0, 255, 0));
  }
  
  void paint(float x1, float y1){
    if(chat.size() > 15)
      chat.remove(0);
    int x = (int)x1;
    int y = (int)y1;
    fill(255);
    textSize(35);
    text("Chat", x, y+=35);
    y+=20;
    for(int i = chat.size()-1; i >= 0; i--){
      chat.get(i).paint(x, y+15*i);
    }
  }
}