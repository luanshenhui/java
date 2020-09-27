import { combineReducers } from 'redux';

import interview from './interviewModule';
import specialInterview from './specialInterviewModule';


// reducerを結合
export default combineReducers({
  interview,
  specialInterview,
});
