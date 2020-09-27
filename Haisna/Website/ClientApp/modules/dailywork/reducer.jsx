import { combineReducers } from 'redux';


import questionnaire from './questionnaireModule';
import questionnaire1 from './questionnaire1Module';
import questionnaire2 from './questionnaire2Module';
import questionnaire3 from './questionnaire3Module';
import mngAccuracy from './mngAccuracyModule';
import morningReport from './morningReportModule';

// reducerを結合
export default combineReducers({
  questionnaire,
  questionnaire1,
  questionnaire2,
  questionnaire3,
  mngAccuracy,
  morningReport,
});
