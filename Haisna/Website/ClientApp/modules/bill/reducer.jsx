import { combineReducers } from 'redux';
import decideAllConsultPrice from './decideAllConsultPriceModule';


import bill from './billModule';
import demand from './demandModule';
import perBill from './perBillModule';
import dmdAddUp from './dmdAddUpModule';
import paymentImportCsv from './paymentImportCsvModule';

// reducerを結合
export default combineReducers({
  bill,
  decideAllConsultPrice,
  demand,
  perBill,
  dmdAddUp,
  paymentImportCsv,
});
