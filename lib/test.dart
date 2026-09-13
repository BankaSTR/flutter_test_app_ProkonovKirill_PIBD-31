//
//
// void printSmth(String? smth){
//   print(smth ?? 'smth');
// }
//
// void printSmthUpper(String? smth){
//   print(smth?.toUpperCase());
// }
//
// void doubleprint(int a){
//   a *= a;
//   print (a);
// }
//
// void printGroup(){
//   final group = ['kirill', 'a', '95', '89'];
//
//   final secondNum = ['95', '55'];
//
//   group.addAll(secondNum);
//
//   print (group);
// }
//
// void hashKeyList(){
//   final Map<String, int> keyValue = {};
//   keyValue['nomer'] = 8;
//
//   final secondKey = {
//     '#1': 1, '#2': 2
//   };
//   keyValue.addAll(secondKey);
//
//   print(keyValue);
// }
//
// enum ItemsType{
//   pc,
//   laptop,
//   phone,
//   tv,
//   pc_mouse,
//   keyboard
// }
//
// void whatIs(){
//   const storeItem = ItemsType.pc;
//   print('''
//   this is a PC item?
//   - its ${storeItem == ItemsType.laptop}''');
// }
//
// bool isArrow(String val) => val == '>';
//
// void printGeneric<T>(List <T> text){
//   print(text is List<String> ? text : 'not text');
// }
//
// void printReduce(int a, int b, int c){
//   final res = [a, b, c].reduce((int a, int c) {return a + c;});
//   print(res);
// }
//
// void main(){
//   printSmth(null);
//   printSmth("print!");
//   printSmthUpper(null);
//   printSmthUpper("smthupper");
//
//   doubleprint(3);
//
//   printGroup();
//
//   hashKeyList();
//
//   whatIs();
//
//   print(isArrow('>'));
//
//   printGeneric(['text', 'text1']);
//
//   printReduce(5, 6, 7);
// }