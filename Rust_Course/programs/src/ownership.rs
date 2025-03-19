// control first approuch (c,c++)
      //  programer munually program lihkta ta or memory ko allocate krna or deallocate  krna
      // digaling pointer ka use kia jata ta 
      // y pionter ta jis ko programer ny us ki memory ko free kr dia hota ta lihkn phir  garbage value us m  store ho jati ti

//safety first approch (java ,python)
    // garbage collecter k pass controle ta usy jah pr meory milti wo uay free kr duta ta
       // likn is m msla y ta k kbi kbi programer souch rah hota ta k memory free ho gi ho gi likn abi ua ny ni ki hoti ti
    
  // control third approch (rust)
     // uper wali problem ko rust ny solve kia h k is m memory management achy trakiy sy hoti h
     // is m programer ko kihal krna hota h k wo rust k rule ko follow kry
       // ownership rule
        // 1 - har value ka jo variable  hota h wo us ka owner khlata h 
        // 2-   1 time pr us ka 1 hi owner hota h 
        // 3-  jab owner scope sy bahr jata h tu value drop ho jati h
      pub fn run(){
        let str1=String::from("hello "); // str1 is a owner  of hello 
        let mut str2=str1; //ownership transfer str2 is new owner of hello 
        str2.push_str("word");
        //println!("value x is {}",str1);  // str1 ab free ho gia h isy hum access ni kr skty 
         println!("value y is {}",str2);

}
// let x=5;
// let y=x;
// println!("value x is {}",x);
// println!("value y is {}",y);