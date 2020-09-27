import { combineReducers } from 'redux';
import itemAndGroupGuide from './itemAndGroupGuideModule';
import sentenceGuide from './sentenceGuideModule';
import bbs from './bbsModule';

// reducerを結合
export default combineReducers({
  itemAndGroupGuide,
  sentenceGuide,
  bbs,
});
