//+------------------------------------------------------------------+
//|                                                     Recorder.mqh |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"

#include <Files\FileTxt.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class  Recorder
{
   private:
      CFileTxt  *file;
      string symbol;
      string directory;     
      string GetFilePath();
   public:
      void Recorder();
      void ~Recorder();
      bool Init(string symbol);
      void WriteWith(int allNumbers,int longNumbers,int shortNumbers);
};

void Recorder::Recorder(void)
{
   this.directory="EmaVote\\";
}

void Recorder::~Recorder(void)
{
   if (file!=NULL) {file.Close();delete file;};
}

bool Recorder::Init(string symbol)
{
   this.symbol=symbol;
   file=new CFileTxt;
   file.Open(GetFilePath(),FILE_READ|FILE_WRITE|FILE_TXT,'\t');
   file.Seek(0,SEEK_END);
   return (true);
}

string Recorder::GetFilePath(void)
{
   return (this.directory+symbol+".log");
}


void Recorder::WriteWith(int allNumbers,int longNumbers,int shortNumbers)
{
      file.WriteString("\nTime : ");
      file.WriteString(TimeToString(TimeCurrent()));
      
      file.WriteString("\tAll  : ");
      file.WriteString(IntegerToString(allNumbers));
      
      file.WriteString("\tLong : ");
      file.WriteString(IntegerToString(longNumbers));
     
      file.WriteString("\tShort : ");
      file.WriteString(IntegerToString(shortNumbers));

      file.WriteString("\tLongRatio : ");
      file.WriteString(DoubleToString((float)longNumbers/(float)allNumbers,3));

      file.WriteString("\tShortRatio : ");
      file.WriteString(DoubleToString((float)shortNumbers/(float)allNumbers,3));
      
    
}
