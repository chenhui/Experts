//+------------------------------------------------------------------+
//|                                                     TestFile.mq5 |
//|                        Copyright 2010, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Files\FileTxt.mqh>
#include <Files\FileBin.mqh>
 
CFileTxt *file;

int OnInit()
{
   file=new CFileTxt;
   string directory="EmaVote\\";
   string fileName=directory+"chenhui";
   file.Open(fileName,FILE_READ|FILE_WRITE|FILE_TXT,'\t');
   file.Seek(0,SEEK_END);
   Write(file,"EURCAD",TimeToString(TimeCurrent()),DoubleToString(3.14,2),IntegerToString(112233));
   Write(file,"EURUSD",TimeToString(TimeCurrent()),DoubleToString(3.14,2),IntegerToString(223344));
   file.Close();
   return 0;
}



void Write(CFileTxt *bfile,string symbol,string time,string price,string count)
{
   bfile.WriteString(symbol);
   bfile.WriteString(time);
   bfile.WriteString(price);
   bfile.WriteString(count);
   bfile.WriteString("\n");
   
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   delete file;
      
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   
}
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
}
//+------------------------------------------------------------------+
