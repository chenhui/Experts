//+------------------------------------------------------------------+
//|                                                   NearActiveWave.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include "..\Indicator\ChZigZag.mqh"
#include "..\Symbol\ChSymbolInfo.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
class Inflexions
{
   private:
      double minZero;
      ChZigZag *zigzag;
      ChSymbolInfo *symbolInfo;
      bool IsInflexion(int index);
   public:
      void Inflexions();
      void ~Inflexions();
      bool Init(string symbol,ENUM_TIMEFRAMES timeFrames);
      int  FixedIndexFrom(int index=0);
      int  PreIndexTo(int index);
     
};

void Inflexions::Inflexions(void)
{
   if (zigzag==NULL) zigzag=new ChZigZag;
   if (symbolInfo==NULL)   symbolInfo=new ChSymbolInfo;
   minZero=0.000000000001;
}

void Inflexions::~Inflexions(void)
{
   if (zigzag!=NULL) delete zigzag;
   if (symbolInfo!=NULL) delete symbolInfo;
   zigzag=NULL;
   symbolInfo=NULL;
}

bool Inflexions::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (zigzag.Create(symbol,timeFrame) && symbolInfo.Init(symbol));
}


int Inflexions::FixedIndexFrom(int index=0)
{
   if (IsInflexion(0))  return (PreIndexTo(0));
   return (PreIndexTo(PreIndexTo(0)));
}

int Inflexions::PreIndexTo(int index)
{
   
   while(!IsInflexion(++index)) {};
   return (index);  
}

bool Inflexions::IsInflexion(int index)
{
   return (zigzag.Main(index)>minZero);
}


class NearActiveWave
{
   private:
   
      double   minZero;
      double   threeGightTwo;
      double   sixOneEight;
      double   threeQuarters;
      double   oneQuarter;
      ChZigZag *zigzag;
      ChSymbolInfo   *symbolInfo;
      Inflexions     *inflexions;
      double ValueOf(double ratio);
      
   public:
      NearActiveWave();
      ~NearActiveWave();
      bool Init(string symbol,ENUM_TIMEFRAMES timeFrames);
      int  FindStart();
      int  FindEnd();
      double ValueOfStart();
      double ValueOfEnd();
      double Amplitude();
      double AmplitudePoints();
      double ZeroDotThreeEightTwoValue();
      double ZeroDotSixOneEightValue();
      double ThreeQuatersValue();
      double OneQuaterValue();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
NearActiveWave::NearActiveWave()
{
   threeGightTwo=0.382;
   sixOneEight=0.618;
   threeQuarters=0.75;
   oneQuarter=0.25;
   zigzag=new ChZigZag;
   symbolInfo=new ChSymbolInfo;
   inflexions=new Inflexions;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
NearActiveWave::~NearActiveWave()
{
   if (zigzag!=NULL) delete zigzag;
   zigzag=NULL;
}

bool NearActiveWave::Init(string symbol,ENUM_TIMEFRAMES timeFrame)
{
   return (  zigzag.Create(symbol,timeFrame) 
          && symbolInfo.Init(symbol) 
          && inflexions.Init(symbol,timeFrame));

}



int NearActiveWave::FindStart()
{
   int startIndex=inflexions.FixedIndexFrom();
   int endIndex=inflexions.PreIndexTo(startIndex);
   while(MathAbs(zigzag.Main(startIndex)-zigzag.Main(endIndex))/symbolInfo.PointValue()<40)
   {
      startIndex=endIndex;
      endIndex=inflexions.PreIndexTo(startIndex);
   }  
   return (startIndex);
}

int NearActiveWave::FindEnd()
{
   return (inflexions.PreIndexTo(FindStart()));
}

double NearActiveWave::Amplitude()
{
   return MathAbs(zigzag.Main(FindStart())-zigzag.Main(FindEnd()));
}

double NearActiveWave::AmplitudePoints()
{
   return (Amplitude()/symbolInfo.PointValue());
}

double NearActiveWave::ZeroDotThreeEightTwoValue()
{
   return (ValueOf(threeGightTwo));
}

double NearActiveWave::ZeroDotSixOneEightValue()
{
   return (ValueOf(sixOneEight));
}

double NearActiveWave::OneQuaterValue(void)
{
   return (ValueOf(oneQuarter));
}

double NearActiveWave::ThreeQuatersValue(void)
{
   return (ValueOf(threeQuarters));
}

double NearActiveWave::ValueOf(double ratio)
{
   double startValue=zigzag.Main(FindStart());
   double endValue=zigzag.Main(FindEnd());
   double ratioValue=Amplitude()*ratio;
   if (startValue>endValue)  return (endValue+ratioValue);
   return (startValue+ratioValue);
}

double NearActiveWave::ValueOfStart()
{
   return (zigzag.Main(FindStart()));
}

double NearActiveWave::ValueOfEnd()
{
   return (zigzag.Main(FindEnd()));
}

