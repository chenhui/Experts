#include "./ISupport.mqh"
#include "../Symbol/RelateConfirmer.mqh"

class Support:public ISupport
{
   private:
      string symbol;
      ENUM_TIMEFRAMES timeFrame; 
      RelateConfirmer *relateConfirmer; 
        
   public:
      void Support();
      void ~Support();
      bool virtual Init(string symbol,ENUM_TIMEFRAMES timeFrame);
      bool virtual IsLeftLeftTo(string suspentsSymbol);
      bool virtual IsLeftRightTo(string suspentsSymbol);
      bool virtual IsRightLeftTo(string suspentsSymbol);
      bool virtual IsRightRightTo(string suspentsSymbol);
      void virtual LeftLeftAlert(int number,string suspentsSymbol){Alert(number," : ",symbol," is left left to ",suspentsSymbol);};
      void virtual LeftRightAlert(int number,string suspentsSymbol){Alert(number," : ",symbol," is left right to ",suspentsSymbol);};
      void virtual RightLeftAlert(int number,string suspentsSymbol){Alert(number," : ",symbol," is right left to ",suspentsSymbol);};
      void virtual RightRightAlert(int number,string suspentsSymbol){Alert(number," : ",symbol," is right right to ",suspentsSymbol);};

};

void Support::Support(void)
{
   relateConfirmer=new RelateConfirmer;
}

void Support::~Support(void)
{
   if(relateConfirmer==NULL) delete relateConfirmer;relateConfirmer=NULL;
}

bool Support::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   this.symbol=symbol;
   this.timeFrame=timeFrame;
   this.relateConfirmer.Init(this.symbol);
   return (true);
}

bool Support::IsLeftLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftLeftRelateTo(suspentsSymbol);
}

bool Support::IsLeftRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsLeftRightRelateTo(suspentsSymbol);
}

bool Support::IsRightLeftTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightLeftRelateTo(suspentsSymbol);
}


bool Support::IsRightRightTo(string suspentsSymbol)
{
   return relateConfirmer.IsRightRightRelateTo(suspentsSymbol);
}

