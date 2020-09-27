import { combineReducers } from 'redux';
import reportForm from './reportFormModule';
import reportLog from './reportLogModule';
import reportSendDate from './reportSendDateModule';

// reducerを結合
export default combineReducers({
  reportForm,
  reportLog,
  reportSendDate,
});
