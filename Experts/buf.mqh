//+------------------------------------------------------------------+
//|                                                          bif.mqh |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"

//#include "interprocess.mqh";

int in_buf_current_packet_ind_;
int in_buf_current_packet_pos_;
int in_buf_next_packet_ind_;
int in_len_;
int out_buf_current_packet_ind_;
int out_buf_current_packet_pos_;
uchar in_buf_[];
uchar out_buf_[200000];
int packet_post_ = 0;
int symbolMult_ = 1;

void writeShort(int ind, short v){
	out_buf_[ind] = v >> 8;
	out_buf_[ind + 1] = v & 0xFF;
}
void writeShort(short v){
	writeShort(out_buf_current_packet_ind_ + out_buf_current_packet_pos_, v);
	out_buf_current_packet_pos_ += 2;
}
void writeInt(int ind, int v){
	out_buf_[ind] = v >> 24;
	out_buf_[ind + 1] = (v >> 16) & 0xFF;
	out_buf_[ind + 2] = (v >> 8) & 0xFF;
	out_buf_[ind + 3] = v & 0xFF;
}
void writeInt(int v){
	writeInt(out_buf_current_packet_ind_ + out_buf_current_packet_pos_, v);
	out_buf_current_packet_pos_ += 4;
}
void writeByte(int ind, char v){
	out_buf_[ind] = v;
}
void writeByte(char v){
	writeByte(out_buf_current_packet_ind_ + out_buf_current_packet_pos_, v);
	out_buf_current_packet_pos_ += 1;
}
int writeString(int ind, string v){
   if(v==""){
       writeShort(ind, 0);
       return 0;
   }
   int len = StringToCharArray(
      v,         // Ñ?Ñ‚Ñ€�?¾�?º�?°-�?¸Ñ?Ñ‚�?¾Ñ‡�?½�?¸�?º
      out_buf_,             // �?¼�?°Ñ?Ñ?�?¸�?²
      ind + 2             // �?½�?°Ñ‡�?°�?»ÑŒ�?½�?°Ñ? �?¿�?¾�?·�?¸Ñ†�?¸Ñ? �?² �?¼�?°Ñ?Ñ?�?¸�?²
   ) - 1;
   writeShort(ind, len);
   //Print("Write string ", v, ", bytes ", len);
   return len;
}
void writeString(string v){
	int len = writeString(out_buf_current_packet_ind_ + out_buf_current_packet_pos_, v);
	out_buf_current_packet_pos_ += len + 2;
}
void writeLong(int ind, long v){
	out_buf_[ind] = v >> 56;
	out_buf_[ind + 1] = (v >> 48) & 0xFF;
	out_buf_[ind + 2] = (v >> 40) & 0xFF;
	out_buf_[ind + 3] = (v >> 32) & 0xFF;
	out_buf_[ind + 4] = (v >> 24) & 0xFF;
	out_buf_[ind + 5] = (v >> 16) & 0xFF;
	out_buf_[ind + 6] = (v >> 8) & 0xFF;
	out_buf_[ind + 7] = v & 0xFF;
}
void writeLong(long v){
	writeLong(out_buf_current_packet_ind_ + out_buf_current_packet_pos_, v);
	out_buf_current_packet_pos_ += 8;
}
ushort readShort(uchar &in_buf[], int ind){
	return (in_buf[ind] << 8) | in_buf[ind + 1];
}
ushort readShort(uchar &in_buf[]){
   ushort v = readShort(in_buf, packet_post_);
   packet_post_ += 2;
   return v;
}
ushort readShort(){
	unsigned short v = readShort(in_buf_, in_buf_current_packet_ind_ + in_buf_current_packet_pos_);
	in_buf_current_packet_pos_ += 2;
	return v;
}
unsigned uchar readByte(uchar &in_buf[], int ind){
	return in_buf[ind];
}
uchar readByte(uchar &in_buf[]){
   uchar v = readByte(in_buf, packet_post_);
   packet_post_ += 1;
   return v;
}
unsigned uchar readByte(){
	unsigned char v = readByte(in_buf_, in_buf_current_packet_ind_ + in_buf_current_packet_pos_);
	in_buf_current_packet_pos_ += 1;
	return v;
}
long readLong(uchar &in_buf[], int ind){
	uint v1 = in_buf[ind] << 24;
	v1 |= in_buf[ind + 1] << 16;
	v1 |= in_buf[ind + 2] << 8;
	v1 |= in_buf[ind + 3];
	
	uint v2 = in_buf[ind + 4] << 24;
	v2 |= in_buf[ind + 5] << 16;
	v2 |= in_buf[ind + 6] << 8;
	v2 |= in_buf[ind + 7];

	return (long)v1 * 4294967296 + v2;
}
long readLong(uchar &in_buf[]){
   long v = readLong(in_buf, packet_post_);
   packet_post_ += 8;
   return v;
}
long readLong(){
	long v = readLong(in_buf_, in_buf_current_packet_ind_ + in_buf_current_packet_pos_);
	in_buf_current_packet_pos_ += 8;
	return v;
}
long readInt(uchar &in_buf[], int ind){
	uint v = in_buf[ind] << 24;
	v |= in_buf[ind + 1] << 16;
	v |= in_buf[ind + 2] << 8;
	v |= in_buf[ind + 3];
	return v;
}
uint readInt(){
   uint v = readInt(in_buf_, in_buf_current_packet_ind_ + in_buf_current_packet_pos_);
   in_buf_current_packet_pos_ += 4;
   return v;
}
uint readInt(uchar &in_buf[]){
   uint v = readInt(in_buf, packet_post_);
   packet_post_ += 4;
   return v;
}
string readString(ushort len){
	string v = readString(in_buf_, in_buf_current_packet_ind_ + in_buf_current_packet_pos_, len);
	in_buf_current_packet_pos_ += len;
	return v;
}
string readString(uchar &in_buf[], ushort len){
	string v = readString(in_buf, packet_post_, len);
	packet_post_ += len;
	return v;
}
string readString(uchar &in_buf[], int ind, ushort len){
   uchar buf[];
   ArrayResize(buf, len);
   ArrayCopy(
      buf,         // �?ºÑƒ�?´�?° �?º�?¾�?¿�?¸Ñ€Ñƒ�?µ�?¼
      in_buf,         // �?¾Ñ‚�?ºÑƒ�?´�?° �?º�?¾�?¿�?¸Ñ€Ñƒ�?µ�?¼
      0,         // Ñ? �?º�?°�?º�?¾�?³�?¾ �?¸�?½�?´�?µ�?ºÑ?�?° �?¿�?¸Ñˆ�?µ�?¼ �?² �?¿Ñ€�?¸�?µ�?¼�?½�?¸�?º
      ind,         // Ñ? �?º�?°�?º�?¾�?³�?¾ �?¸�?½�?´�?µ�?ºÑ?�?° �?º�?¾�?¿�?¸Ñ€Ñƒ�?µ�?¼ �?¸�?· �?¸Ñ?Ñ‚�?¾Ñ‡�?½�?¸�?º�?°
      len    // Ñ?�?º�?¾�?»ÑŒ�?º�?¾ Ñ?�?»�?µ�?¼�?µ�?½Ñ‚�?¾�?²
   );
   //Print("Read string of ", to_hex(buf), ", string: ", CharArrayToString(buf));
   return CharArrayToString(buf);
}
void startPacket(){
   startPacket(0, 0);
}
void startPacket(uint client_id, uchar type){
	out_buf_current_packet_pos_ = 2;
	if(client_id > 0){
	   writeInt(client_id);
	   writeByte(type);
	}
}
void sendPacket(){
   endPacket();
   sendBuffer();
}
void sendBuffer(){
	if (out_buf_current_packet_ind_ > 0){
	   //Print("Send ", out_buf_current_packet_ind_," bytes");
//		interprocess_slave_send(out_buf_, out_buf_current_packet_ind_);
		out_buf_current_packet_ind_ = 0;
		/*
		uchar test_buf[10];
		interprocess_slave_send(test_buf, 10);
		
		*/
	}
}
void endPacket(){
	writeShort(out_buf_current_packet_ind_, out_buf_current_packet_pos_ - 2);
	out_buf_current_packet_ind_ += out_buf_current_packet_pos_;
}

bool nextPacket()
{
   
	if (in_buf_next_packet_ind_ + 2 > in_len_) {
		return false;
	}

	in_buf_current_packet_ind_ = in_buf_next_packet_ind_;
	in_buf_current_packet_pos_ = 0;
   
   ushort packet_len = readShort();
   
	in_buf_next_packet_ind_ += packet_len + 2;

	//in_buf_current_packet_pos_ += 4;
   
	if (in_buf_next_packet_ind_ > in_len_)  {
	   in_buf_next_packet_ind_ = in_buf_current_packet_ind_; 
	   //Print("No next ",in_buf_next_packet_ind_, ", ", in_len_);
		return false;
	}
   
   //Print("Recieve packet len ", packet_len);
	return true;
}
string getPacket(){
   return to_hex(in_buf_, in_buf_current_packet_ind_ + 2, readShort(in_buf_, in_buf_current_packet_ind_), false);
}
string endWritePacket(){
   string packet = to_hex(out_buf_, out_buf_current_packet_ind_ + 2, out_buf_current_packet_pos_ - 2, false);
   out_buf_current_packet_pos_ = 0;
   return packet;
}
void readPacket(){
   packet_post_ = 0;
}
void from_hex(string data, uchar &buf[]){
   
   int len = StringLen(data);
   ArrayResize(buf, len / 2);
   //Print("HEX - ", data);
   for(int i=0;i<len;i++){
      buf[(int)(i / 2)] = (from_half_hex(StringGetCharacter(data, i)) << 4) | from_half_hex(StringGetCharacter(data, i+1));
      i++;
   }
   //Print("FROM HEX - ", to_hex(buf));
}
uchar from_half_hex(uchar c ){
   switch(c){
      case 'A':
         return 10;
      case 'B':
         return 11;
      case 'C':
         return 12;
      case 'D':
         return 13;
      case 'E':
         return 14;
      case 'F':
         return 15;
      case '0':
         return 0;
      case '1':
         return 1;
      case '2':
         return 2;
      case '3':
         return 3;
      case '4':
         return 4;
      case '5':
         return 5;
      case '6':
         return 6;
      case '7':
         return 7;
      case '8':
         return 8;
      case '9':
         return 9;
      default: 
         return 0;
   }
}
string to_hex(uchar &buf[], int from , int nb, bool hasSpace){
   string ret = "";
   for(int i=from;i<from+nb;i++){
      StringAdd(ret, half_hex(buf[i] >> 4));
      StringAdd(ret, half_hex(buf[i] & 0x0F));
      if(hasSpace) StringAdd(ret, " ");
   }
   return ret;
}
string to_hex(uchar &buf[]) 
{
   return to_hex(buf, 0, ArraySize(buf), true);
}

string to_hex(string data) 
{
   uchar buf[];
   ArrayResize(buf, StringLen(data));
   StringToCharArray(data, buf);
   return to_hex(buf);
}

string half_hex(int v){
   switch(v){
      case 10:
         return "A";
      case 11:
         return "B";
      case 12:
         return "C";
      case 13:
         return "D";
      case 14:
         return "E";
      case 15:
         return "F";
      default: 
         return IntegerToString(v);
   }
}

void pushOpenOrder(string positionId, long orderId, long tick, long time, string symbol, double price, int orderType, double qty, double st, double tp, double div){
   
   startPacket(CLIENT_ID, TYPE_PUSH);
   writeByte(PUSH_MSG_TYPE_ADD_ORDER);
   writeLong(orderId);
   writeString(positionId);
   writeByte(orderType);
   writeString(symbol);
   //Print("TICK ", tick," TICK WITH OFFSET - ", tick + tickOffset_, " TICK OFFSET - ", tickOffset_);
   writeLong(tick + tickOffset_);
   writeLong(time * 1000);
   writeInt(qty * lotSize(symbol) * symbolMult_ * 100);
   writeLong(price / symbolMult_ * 100000);
   writeLong(st / symbolMult_ * 100000);
   writeLong(tp / symbolMult_ * 100000);
   writeByte(SymbolInfoInteger(symbol,SYMBOL_DIGITS));
   writeLong(div / symbolMult_ * 100000);
   writeInt(lotSize(symbol) * 100);
   endPacket();
   
   onPushOpenOrder(orderId);
}
void pushAddDeal(string positionId, long orderId, long tick, long time, int orderType, double qty, double price, double lotSize, double commission, string commCur) {
   startPacket(CLIENT_ID, TYPE_PUSH);
   writeByte(PUSH_MSG_TYPE_ADD_DEAL);
   writeLong(orderId);
   writeString(positionId);
   writeByte(orderType);
   writeLong(tick + tickOffset_);
   writeLong(time * 1000);
   writeInt(qty * lotSize * symbolMult_ * 100);
   writeLong(price / symbolMult_ * 100000);
   writeInt(commission * 100);
   writeString(commCur);
   endPacket();
}