import { combineReducers } from 'redux';

import bill from './bill/reducer';
import common from './common/reducer';
import preference from './preference/reducer';
import report from './report/reducer';
import reserve from './reserve/reducer';
import judgement from './judgement/reducer';
import followup from './followup/reducer';
import result from './result/reducer';
import dailywork from './dailywork/reducer';
import inquiry from './inquiry/reducer';
import yudo from './yudo/reducer';

// reducerを結合
export default combineReducers({
  bill,
  common,
  preference,
  report,
  reserve,
  judgement,
  followup,
  result,
  dailywork,
  inquiry,
  yudo,
});
