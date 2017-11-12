import processing.core.*;

enum Terrain{
  EMPTY,
  WALL,
  HOLE,
  TELEPORT
};

enum Classe{
  WARRIOR,
  TANK,
  WIZARD
};

String getClasseAsString(Classe classe){
  String result = "";
  if(classe == Classe.WARRIOR)  result = Trans.get("Ranger");
  if(classe == Classe.TANK)     result = Trans.get("Tank");
  if(classe == Classe.WIZARD)   result = Trans.get("Wizard");
  return result;
}

enum Effects{
  //NEGATIVE         POSITIVE                  AFFECTS :
  POISON,            REGEN,                    //health
  WEAKNESS,          STRENGTH,                 //strength
  EXHAUST,           POWER,                    //mana
  DEF_LESS,          DEF_MORE,                 //defense
};

String getEffectsAsString(Effects effect){
  String result = "";
  if(effect == Effects.POISON)      result = Trans.get("Poison");
  if(effect == Effects.REGEN)       result = Trans.get("Regeneration");
  if(effect == Effects.EXHAUST)     result = Trans.get("Exhaustion");
  if(effect == Effects.POWER)       result = Trans.get("Power");
  if(effect == Effects.WEAKNESS)    result = Trans.get("Weakness");
  if(effect == Effects.STRENGTH)    result = Trans.get("Strength");
  if(effect == Effects.DEF_LESS)    result = Trans.get("Defenseless");
  if(effect == Effects.DEF_MORE)    result = Trans.get("Defense Gain");
  return result;
}